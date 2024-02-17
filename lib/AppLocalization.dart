import 'dart:async' show Future;
import 'dart:convert';

import 'package:coozy_cafe/model/language_model/language_model.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale? locale;
  LanguageModel? language;

  AppLocalizations(this.locale, this.language);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/locale/${language!.file}');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String? translate(String key) {
    if (_localizedStrings == null) {
      Constants.debugLog(AppLocalizations, "Please check json file path.");
      return null;
    }
    if (_localizedStrings!.containsKey(key)) {
      return _localizedStrings?[key] ?? "";
    } else {
      Constants.debugLog(AppLocalizations, "String key is not Founded:$key");
      return null;
    }
  }

  static String getCurrentLanguageCode(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);

    if (appLocalizations != null) {
      String? currentLanguageCode = appLocalizations.locale?.languageCode;
      return currentLanguageCode ??
          "en"; // Default to "en" if the language code is not available
    } else {
      return "en"; // Default to "en" if AppLocalizations instance is not available
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final List<LanguageModel> languages;

  const AppLocalizationsDelegate(this.languages);

  @override
  bool isSupported(Locale locale) {
    return languages
        .map((language) => language.code)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    String languageCode = await LanguagePreferences.getLanguageCode();
    LanguageModel language =
        languages.firstWhere((language) => language.code == languageCode);

    AppLocalizations localizations = AppLocalizations(locale, language);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

//
// AppLocalizations.of(context).translate('hello'),
