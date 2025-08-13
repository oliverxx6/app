import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static String? _email;
  static SharedPreferences? _preferences;

  static Future<SharedPreferences?> initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future<String?> get preferences async {
    await initPreferences();
    _email = _preferences?.getString('email') ?? "";
    return _email;
  }

  static Future<void> setEmail(String email) async {
    if (_preferences == null) {
      await initPreferences();
    }
    _preferences?.setString('email', email);
  }

  static Future<void> deletePreferences() async {
    if (_preferences == null) {
      await initPreferences();
    }
    _preferences?.remove('email');
  }
}

class PreferencesRegister {
  static String? _uid;
  static SharedPreferences? _preferences;

  static Future<SharedPreferences?> initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future<String?> get preferences async {
    await initPreferences();
    _uid = _preferences?.getString('uid') ?? "";
    return _uid;
  }

  static Future<void> setOk(String uid) async {
    if (_preferences == null) {
      await initPreferences();
    }
    _preferences?.setString('uid', uid);
  }

  static Future<void> deletePreferences() async {
    if (_preferences == null) {
      await initPreferences();
    }
    _preferences?.remove('uid');
  }
}

class PreferencesName {
  static String? _name;
  static SharedPreferences? _preferencesName;

  static Future<SharedPreferences?> initPreferencesName() async {
    _preferencesName = await SharedPreferences.getInstance();
    return _preferencesName;
  }

  static Future<String?> get preferencesName async {
    await initPreferencesName();
    _name = _preferencesName?.getString('name') ?? "";
    return _name;
  }

  static Future<void> setName(String name) async {
    if (_preferencesName == null) {
      await initPreferencesName();
    }
    _preferencesName?.setString('name', name);
  }

  static Future<void> deletePreferencesName() async {
    if (_preferencesName == null) {
      await initPreferencesName();
    }
    _preferencesName?.remove('name');
  }
}
