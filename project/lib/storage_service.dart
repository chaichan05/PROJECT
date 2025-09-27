import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyIsLoggedIn = "isLoggedIn";
  static const String keyIsInMenu = "isInMenu";

  // login state
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, value);
  }

  static Future<bool> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  // menu state
  static Future<void> setInMenu(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsInMenu, value);
  }

  static Future<bool> getInMenu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsInMenu) ?? false;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
