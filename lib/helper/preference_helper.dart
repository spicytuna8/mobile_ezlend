import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

//NOTE: generic Shared Preference
  Future<bool> isSharedPref(String key) async {
    final prefs = await sharedPreferences;
    return prefs.getBool(key) ?? false;
  }

  void setSharedPref(String key, bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(key, value);
  }

  Future<String> getStringSharedPref(String key) async {
    final prefs = await sharedPreferences;
    return prefs.getString(key) ?? '';
  }

  void setStringSharedPref(String key, String data) async {
    final prefs = await sharedPreferences;
    prefs.setString(key, data);
  }

  void removeStringSharedPref(String key) async {
    final prefs = await sharedPreferences;
    prefs.remove(key);
  }

  Future<String> get getToken async {
    final prefs = await sharedPreferences;
    String data = prefs.getString('token') ?? '';
    return data;
  }
}
