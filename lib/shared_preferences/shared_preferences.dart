import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String PREF_NAME = "MyPrefs";
  static SharedPreferencesManager? _instance;
  SharedPreferences? _sharedPreferences;

  SharedPreferencesManager._();

  static Future<SharedPreferencesManager?> getInstance() async {
    if (_instance == null) {
      _instance = SharedPreferencesManager._();
      await _instance?._initSharedPreferences();
    }
    return _instance;
  }

  Future<void> _initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setValue(String key, String value) async {
    await _sharedPreferences?.setString(key, value);
  }

  String getValue(String key, String defaultValue) {
    return _sharedPreferences?.getString(key) ?? defaultValue;
  }

  Future<void> removeValue(String key) async {
    await _sharedPreferences?.remove(key);
  }

  Future<void> clearAll() async {
    await _sharedPreferences?.clear();
  }
}
