import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StoreAdapterKind {
  shared,
  secure,
}

sealed class StoreAdapter {
  const StoreAdapter();

  StoreAdapterKind get kind;

  FutureOr<String?> read(String key);
  FutureOr<void> write(String key, String? value);
}

class SharedStoreAdapter extends StoreAdapter {
  const SharedStoreAdapter(this._instance);

  final SharedPreferences _instance;

  @override
  StoreAdapterKind get kind => StoreAdapterKind.shared;

  @override
  FutureOr<String?> read(String key) {
    return _instance.getString(key);
  }

  @override
  FutureOr<void> write(String key, String? value) async {
    await (value != null
        ? _instance.setString(key, value)
        : _instance.remove(key));
  }
}

class SecureStoreAdapter extends StoreAdapter {
  const SecureStoreAdapter(this._instance);

  final FlutterSecureStorage _instance;

  @override
  StoreAdapterKind get kind => StoreAdapterKind.secure;
  @override
  FutureOr<String?> read(String key) {
    return _instance.read(key: key);
  }

  @override
  FutureOr<void> write(String key, String? value) async {
    await _instance.write(key: key, value: value);
  }
}
