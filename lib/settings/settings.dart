import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:material/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'store/store.dart';
import 'store/adapter.dart';

mixin _SettingsBase on Iterable<PersistedStore>, ChangeNotifier {
  final firstRunStore = MemoryStore<bool>(
    true.store,
  ).persist("first_run");

  final useSystemBrightnessStore = MemoryStore<bool>(
    true.store,
  ).persist("use_system_brightness");

  final brightnessStore = MemoryStore<Brightness>(
    PlatformDispatcher.instance.platformBrightness.store,
  ).persistWith(
    key: "brightness",
    deserialize: (value) => switch (value) {
      "light" => Brightness.light,
      "dark" => Brightness.dark,
      _ => null,
    },
    serialize: (value) => switch (value) {
      Brightness.light => "light",
      Brightness.dark => "dark",
    },
  );

  final useDynamicColorStore = MemoryStore<bool>(
    true.store,
  ).persist("use_dynamic_color");

  final exchangeKindsStore = MemoryStore<Set<ExchangeKind>>(
    {ExchangeKind.plainText}.store,
  ).persistWith(
    key: "export_kinds",
    deserialize: (value) {
      ExchangeKind? deserialize(String value) => switch (value) {
            "plain_text" => ExchangeKind.plainText,
            "markdown" => ExchangeKind.markdown,
            "json" => ExchangeKind.json,
            _ => null,
          };
      return value
          .split(",")
          .map((value) => deserialize(value.trim()))
          .whereNotNull()
          .toSet();
    },
    serialize: (values) {
      String serialize(ExchangeKind value) => switch (value) {
            ExchangeKind.plainText => "plain_text",
            ExchangeKind.markdown => "markdown",
            ExchangeKind.json => "json",
          };
      return values.map(serialize).join(", ");
    },
  );

  final localeStore = MemoryStore<SupportedLocale>(
    SupportedLocale.system.store,
  ).persistWith(
    key: "locale",
    deserialize: (value) => switch (value) {
      "en" => SupportedLocale.en,
      "ru" => SupportedLocale.ru,
      _ => null,
    },
    serialize: (value) => switch (value) {
      SupportedLocale.system => "system",
      SupportedLocale.en => "en",
      SupportedLocale.ru => "ru",
    },
  );

  final editorKindStore =
      MemoryStore<EditorKind>(EditorKind.fleather.store).persistWith(
    key: "editor_kind",
    deserialize: (value) => switch (value.toLowerCase()) {
      "flutter_quill" => EditorKind.flutterQuill,
      "fleather" => EditorKind.fleather,
      "super_editor" => EditorKind.superEditor,
      _ => null,
    },
    serialize: (value) => switch (value) {
      EditorKind.flutterQuill => "flutter_quill",
      EditorKind.fleather => "fleather",
      EditorKind.superEditor => "super",
    },
  );

  @override
  Iterator<PersistedStore> get iterator => <PersistedStore>[
        firstRunStore,
        useSystemBrightnessStore,
        brightnessStore,
        useDynamicColorStore,
        exchangeKindsStore,
        localeStore,
        editorKindStore,
      ].iterator;
}

class Settings extends Iterable<PersistedStore>
    with ChangeNotifier, _SettingsBase {
  static Settings read(BuildContext context) {
    return context.read<Settings>();
  }

  static Settings watch(BuildContext context) {
    return context.watch<Settings>();
  }

  static Future<Settings> initialize({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  }) async {
    final settings = Settings(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
    );
    await settings.load();
    return settings;
  }

  Settings({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
  }) : _adapters = {
          SharedStoreAdapter(sharedPreferences),
          SecureStoreAdapter(secureStorage),
        } {
    for (final store in this) {
      store.addListener(
        () async {
          notifyListeners();
          if (!store.saved) {
            await store.save(_adapters);
          }
        },
      );
    }
  }

  final Set<StoreAdapter> _adapters;

  Future<void> load() async {
    await Future.wait([
      for (final store in this) store.load(_adapters),
    ]);
  }

  Future<void> save() async {
    await Future.wait([
      for (final store in this) store.save(_adapters),
    ]);
  }

  void resetAll() {
    for (final store in this) {
      store.reset();
    }
  }

  bool get firstRun => firstRunStore.value;
  set firstRun(bool? value) => firstRunStore.value = value;

  bool get useSystemBrightness => useSystemBrightnessStore.value;
  set useSystemBrightness(bool? value) =>
      useSystemBrightnessStore.value = value;

  Brightness get brightness => brightnessStore.value;
  set brightness(Brightness? value) => brightnessStore.value = value;

  ThemeMode get themeMode =>
      useSystemBrightness ? ThemeMode.system : brightness.themeMode;

  bool get useDynamicColor => useDynamicColorStore.value;
  set useDynamicColor(bool? value) => useDynamicColorStore.value = value;

  Set<ExchangeKind> get exchangeKinds => exchangeKindsStore.value;
  set exchangeKinds(Set<ExchangeKind>? value) =>
      exchangeKindsStore.value = value;

  SupportedLocale get locale => localeStore.value;
  set locale(SupportedLocale? value) => localeStore.value = value;

  EditorKind get editorKind => editorKindStore.value;
  set editorKind(EditorKind? value) => editorKindStore.value = value;
}

enum ExchangeKind {
  plainText,
  markdown,
  json,
}

enum SupportedLocale {
  system,
  en,
  ru;

  Locale? get locale => switch (this) {
        SupportedLocale.system => null,
        SupportedLocale.en => const Locale("en"),
        SupportedLocale.ru => const Locale("ru"),
      };

  String nameOf(BuildContext context) {
    return name;
  }
}

extension BrightnessExtension on Brightness {
  ThemeMode get themeMode => switch (this) {
        Brightness.light => ThemeMode.light,
        Brightness.dark => ThemeMode.dark,
      };
}

enum EditorKind {
  flutterQuill,
  fleather,
  superEditor,
}
