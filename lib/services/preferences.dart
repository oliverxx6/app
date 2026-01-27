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

class PreferencesJob {
  static String? _job;
  static SharedPreferences? _preferencesJob;

  static Future<SharedPreferences?> initPreferencesJob() async {
    _preferencesJob = await SharedPreferences.getInstance();
    return _preferencesJob;
  }

  static Future<String?> get preferencesJobs async {
    await initPreferencesJob();
    _job = _preferencesJob?.getString('job') ?? "";
    return _job;
  }

  static Future<void> setJob(String job) async {
    if (_preferencesJob == null) {
      await initPreferencesJob();
    }
    _preferencesJob?.setString('job', job);
  }

  static Future<void> deletePreferencesJob() async {
    if (_preferencesJob == null) {
      await initPreferencesJob();
    }
    _preferencesJob?.remove('job');
  }
}

class PreferencesJobTwo {
  static String? _job;
  static SharedPreferences? _preferencesJob;

  static Future<SharedPreferences?> initPreferencesJob() async {
    _preferencesJob = await SharedPreferences.getInstance();
    return _preferencesJob;
  }

  static Future<String?> get preferencesJobs async {
    await initPreferencesJob();
    _job = _preferencesJob?.getString('jobTwo') ?? "";
    return _job;
  }

  static Future<void> setJob(String job) async {
    if (_preferencesJob == null) {
      await initPreferencesJob();
    }
    _preferencesJob?.setString('jobTwo', job);
  }

  static Future<void> deletePreferencesJob() async {
    if (_preferencesJob == null) {
      await initPreferencesJob();
    }
    _preferencesJob?.remove('jobTwo');
  }
}

class PreferencesCity {
  static String? _city;
  static SharedPreferences? _preferencesCity;

  static Future<SharedPreferences?> initPreferencesCity() async {
    _preferencesCity = await SharedPreferences.getInstance();
    return _preferencesCity;
  }

  static Future<String?> get preferencesCities async {
    await initPreferencesCity();
    _city = _preferencesCity?.getString('city') ?? "";
    return _city;
  }

  static Future<void> setCity(String city) async {
    if (_preferencesCity == null) {
      await initPreferencesCity();
    }
    _preferencesCity?.setString('city', city);
  }

  static Future<void> deletePreferencesCity() async {
    if (_preferencesCity == null) {
      await initPreferencesCity();
    }
    _preferencesCity?.remove('city');
  }
}
