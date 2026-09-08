import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sinhala_dictionary_app/core/enums/ai_language.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  static const String _themeKey = "theme_mode";
  static const String _aiLanguageKey = "ai_language";

  ThemeMode getThemeMode() {
    final themeString = _prefs.getString(_themeKey);

    List<ThemeMode> modes = ThemeMode.values;

    return modes.firstWhere(
      (e) => (e.name == themeString),
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeKey, themeMode.name);
  }

  AiLanguage getAiLangauge() {
    final languageString = _prefs.getString(_aiLanguageKey);

    return AiLanguage.values.firstWhere(
      (lang) => lang.value == languageString,
      orElse: () => AiLanguage.english,
    );
  }

  Future<void> saveAiLanguage(AiLanguage language) async {
    await _prefs.setString(_aiLanguageKey, language.value);
  }
}
