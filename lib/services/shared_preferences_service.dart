import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  static get instance {
    _instance ??= SharedPreferencesService._();

    return _instance!;
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static dynamic getData(String key) {
    Object? value;

    value = _preferences.getString(key);

    return value;
  }

  static Future<void> saveData(String key, dynamic value) async {
    if (value is String) {
      await _preferences.setString(key, value);
    } else if (value is int) {
      await _preferences.setInt(key, value);
    } else if (value is double) {
      await _preferences.setDouble(key, value);
    } else if (value is bool) {
      await _preferences.setBool(key, value);
    } else if (value is List<String>) {
      await _preferences.setStringList(key, value);
    }
  }
}
