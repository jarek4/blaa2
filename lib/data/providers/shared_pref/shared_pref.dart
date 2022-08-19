import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _preferences;
  static const _keyCurrentLocale = 'currentLocale';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setLocale(String locale) async {
    await _preferences?.setString(_keyCurrentLocale, locale);
    print('SharedPref setLocale: $locale');
  }

  static Locale getLocale() =>
      Locale(_preferences?.getString(_keyCurrentLocale) ?? 'en');

  static String getLocaleCode() =>
      _preferences?.getString(_keyCurrentLocale) ?? 'en';

  static void clearLocale() => _preferences?.remove(_keyCurrentLocale);
}
