import 'dart:async';

import 'package:collection/collection.dart';
import 'package:material/material.dart';

import 'adapter.dart';

typedef StoreDeserializer<T> = FutureOr<T?> Function(String value);
typedef StoreSerializer<T> = FutureOr<String> Function(T value);

abstract interface class Store<T> {
  factory Store.derived(T Function() computation) = _DerivedStore<T>;
  factory Store.constant(T value) = _ConstantStore<T>;

  T get value;
}

class _DerivedStore<T> implements Store<T> {
  const _DerivedStore(this._computation);

  final T Function() _computation;

  @override
  T get value => _computation();
}

extension ConstStoreExtension<T> on T {
  Store<T> get store => Store.constant(this);
}

class _ConstantStore<T> implements Store<T> {
  const _ConstantStore(this.value);

  @override
  final T value;
}

class MemoryStore<T> with ChangeNotifier implements Store<T> {
  MemoryStore(this.defaultStore);

  final Store<T> defaultStore;

  T? _value;

  @override
  T get value => _value ?? defaultStore.value;

  set value(T? newValue) {
    _value = newValue;
    notifyListeners();
  }

  bool get isDefault => _value == null;

  void reset() {
    value = null;
  }

  PersistedStore<T> persistWith({
    required String key,
    StoreAdapterKind? adapter,
    required StoreDeserializer<T> deserialize,
    required StoreSerializer<T> serialize,
  }) =>
      PersistedStore(
        key: key,
        defaultStore: defaultStore,
        deserialize: deserialize,
        serialize: serialize,
      );
}

extension MemoryStoreStringExtension on MemoryStore<String> {
  static String defaultDeserialize(String value) => value;
  static String defaultSerialize(String value) => value;

  PersistedStore<String> persist(
    String key, {
    StoreDeserializer<String>? deserialize,
    StoreSerializer<String>? serialize,
  }) =>
      persistWith(
        key: key,
        deserialize: deserialize ?? defaultDeserialize,
        serialize: serialize ?? defaultSerialize,
      );
}

extension MemoryStoreBoolExtension on MemoryStore<bool> {
  static bool? defaultDeserialize(String value) => switch (value) {
        "false" => false,
        "true" => true,
        _ => null,
      };
  static String defaultSerialize(bool value) => switch (value) {
        false => "false",
        true => "true",
      };

  PersistedStore<bool> persist(
    String key, {
    StoreDeserializer<bool>? deserialize,
    StoreSerializer<bool>? serialize,
  }) =>
      persistWith(
        key: key,
        deserialize: deserialize ?? defaultDeserialize,
        serialize: serialize ?? defaultSerialize,
      );
}

class PersistedStore<T> extends MemoryStore<T> {
  PersistedStore({
    required this.key,
    StoreAdapterKind? adapter,
    required Store<T> defaultStore,
    required StoreDeserializer<T> deserialize,
    required StoreSerializer<T> serialize,
  })  : adapterKind = adapter,
        _deserialize = deserialize,
        _serialize = serialize,
        super(defaultStore);

  final StoreAdapterKind? adapterKind;
  StoreAdapter? _findAdapter(Iterable<StoreAdapter> adapters) {
    return (adapterKind != null
            ? adapters
                .firstWhereOrNull((adapter) => adapter.kind == adapterKind)
            : null) ??
        adapters.firstOrNull;
  }

  final StoreDeserializer<T> _deserialize;
  final StoreSerializer<T> _serialize;

  final String key;

  @override
  set value(T? newValue) {
    _value = newValue;
    saved = false;
    notifyListeners();
  }

  /// To prevent infinite recursion
  /// `true` if value is not yet persisted, `false` otherwise
  bool saved = true;

  Future<void> load(Iterable<StoreAdapter> adapters) async {
    final adapter = _findAdapter(adapters);
    if (adapter == null) return;

    final serialized = await adapter.read(key);
    final deserialized =
        serialized != null ? await _deserialize(serialized) : null;
    if (deserialized != null) {
      _value = deserialized;
    }

    saved = true;
    notifyListeners();
  }

  Future<void> save(Iterable<StoreAdapter> adapters) async {
    final adapter = _findAdapter(adapters);
    if (adapter == null) return;

    final serialized = _value != null ? await _serialize(_value as T) : null;
    await adapter.write(key, serialized);

    saved = true;
  }
}
