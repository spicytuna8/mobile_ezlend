import 'package:flutter/material.dart';
import 'package:loan_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(prefSelectedLanguageCode) ?? "en";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case 'zh-Hant': // Traditional Chinese
      return const Locale('zh', 'Hant');
    case 'zh-Hans': // Simplified Chinese
      return const Locale('zh', 'Hans');
    case 'zh-TW': // Taiwanese Mandarin (Traditional Chinese)
      return const Locale('zh', 'TW');
    case 'ml': // Malayalam
      return const Locale('ml', '');
    case 'ja': // Japanese
      return const Locale('ja', '');
    case 'zh-HK': // Hongkong
      return const Locale('zh', 'HK');
    default: // English as fallback
      return const Locale('en', '');
  }
}

void changeLanguage(BuildContext context, String selectedLanguageCode) async {
  var locale = await setLocale(selectedLanguageCode);
  MyApp.setLocale(context, locale);
}
