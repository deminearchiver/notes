import 'dart:async';
import 'package:notes/utils/utils.dart';
import 'package:material/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<T> sharedPreferences<T>(
        FutureOr<T> Function(SharedPreferences preferences) onValue) =>
    SharedPreferences.getInstance().then(onValue);

class Settings with ChangeNotifier {
  Settings._() {
    reload();
  }

  static final _instance = Settings._();
  static Settings get instance => _instance;

  Future<void> reload() async {
    final preferences = await SharedPreferences.getInstance();
    {
      final value = preferences.getInt("databaseVersion");
      if (value != null) {
        _databaseVersion = value;
      }
    }
    {
      final value = preferences.getBool("firstRun");
      if (value != null) {
        _firstRun = value;
      }
    }
    {
      final value = preferences.getString("locale");
      if (value != null) {
        final parsed = tryParseLocale(value);
        if (parsed != null) _locale = parsed;
      } else {
        _locale = null;
      }
    }
    {
      final name = preferences.getString("themeMode") ?? "";
      final value = ThemeMode.values.byNameOptional(name);
      if (value != null) {
        _themeMode = value;
      }
    }
    {
      final value = preferences.getBool("developerMode");
      if (value != null) {
        _developerMode = value;
      }
    }
    {
      final value = preferences.getBool("demoMode");
      if (value != null) {
        _demoMode = value;
      }
    }
    notifyListeners();
  }

  void reset() {
    databaseVersion = 1;
    firstRun = true;
    locale = null;
    themeMode = ThemeMode.system;
    developerMode = false;
    demoMode = false;
  }

  int _databaseVersion = 1;
  int get databaseVersion => _databaseVersion;
  set databaseVersion(int value) {
    _databaseVersion = value;
    notifyListeners();
    sharedPreferences(
      (preferences) => preferences.setInt("databaseVersion", value),
    );
  }

  bool _firstRun = true;
  bool get firstRun => _firstRun;
  set firstRun(bool value) {
    _firstRun = value;
    notifyListeners();
    sharedPreferences(
      (preferences) => preferences.setBool("firstRun", value),
    );
  }

  Locale? _locale;
  Locale? get locale => _locale;
  set locale(Locale? value) {
    _locale = value;
    notifyListeners();
    sharedPreferences(
      (preferences) => value != null
          ? preferences.setString(
              "locale",
              value.toLanguageTag(),
            )
          : preferences.remove("locale"),
    );
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
    sharedPreferences(
      (preferences) => preferences.setString("themeMode", value.name),
    );
  }

  bool _developerMode = false;
  bool get developerMode => _developerMode;
  set developerMode(bool value) {
    _developerMode = value;
    notifyListeners();
    sharedPreferences(
      (preferences) => preferences.setBool("developerMode", value),
    );
  }

  bool _demoMode = false;
  bool get demoMode => _demoMode;
  set demoMode(bool value) {
    _demoMode = value;
    notifyListeners();
    sharedPreferences(
      (preferences) => preferences.setBool("demoMode", value),
    );
  }
}

extension EnumByName<T extends Enum> on Iterable<T> {
  T? byNameOptional(String name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}
