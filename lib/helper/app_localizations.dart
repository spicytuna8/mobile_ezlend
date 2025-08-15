import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:loan_project/helper/languages.dart';
import 'package:loan_project/languages/language_yue.dart';
import 'package:loan_project/languages/languages_en.dart';
import 'package:loan_project/languages/languages_hans.dart'; // Simplified Chinese
import 'package:loan_project/languages/languages_hant.dart'; // Traditional Chinese
import 'package:loan_project/languages/languages_jp.dart';
import 'package:loan_project/languages/languages_ml.dart';
import 'package:loan_project/languages/languages_tw.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<Languages> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      const Locale('en', ''), // English
      const Locale('zh', 'Hans'), // Simplified Chinese
      const Locale('zh', 'Hant'), // Traditional Chinese
      const Locale(
          'zh', 'TW'), // Taiwanese Mandarin (Traditional Chinese in Taiwan)
      const Locale('ml', ''), // Malayalam
      const Locale('ja', ''), // Japanese
      const Locale('zh', 'HK'), // Hongkong / Cantonese
    ].contains(locale);
  }

  @override
  Future<Languages> load(Locale locale) => _load(locale);

  static Future<Languages> _load(Locale locale) async {
    log('App locale: $locale');
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();

      case 'zh':
        if (locale.countryCode == 'HK') {
          return LanguageYue(); // Hong Kong (Traditional Cantonese style)
        } else if (locale.countryCode == 'TW') {
          return LanguageTW(); // Taiwan (Traditional Mandarin)
        } else if (locale.scriptCode == 'Hant') {
          return LanguageHant(); // Generic Traditional Chinese
        } else {
          return LanguageHans(); // Default: Simplified Chinese
        }

      case 'ml':
        return LanguageMl();
      case 'ja':
        return LanguageJp();

      default:
        return LanguageEn();
    }
  }

  @override
  bool shouldReload(LocalizationsDelegate<Languages> old) => false;
}
