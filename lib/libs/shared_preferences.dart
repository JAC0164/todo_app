import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesProvider = Provider<SharedPreferencesAdapter>((ref) {
  final sharedPref = SharedPreferences.getInstance();
  return SharedPreferencesAdapter(sharedPref);
});

class SharedPreferencesAdapter {
  Future<SharedPreferences> sharedPref;

  SharedPreferencesAdapter(this.sharedPref);

  Future<bool> setBool(String key, bool value) async {
    return (await sharedPref).setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    return (await sharedPref).getBool(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return (await sharedPref).setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    return (await sharedPref).getDouble(key);
  }

  Future<bool> setInt(String key, int value) async {
    return (await sharedPref).setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    return (await sharedPref).getInt(key);
  }

  Future<bool> setString(String key, String value) async {
    return (await sharedPref).setString(key, value);
  }

  Future<String?> getString(String key) async {
    return (await sharedPref).getString(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return (await sharedPref).setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    return (await sharedPref).getStringList(key);
  }
}
