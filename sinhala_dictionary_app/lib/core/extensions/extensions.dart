import 'package:flutter/material.dart';

extension ThemeModeX on ThemeMode {
  String get displayName {
    return switch (this) {
      ThemeMode.light => 'Light Theme',
      ThemeMode.dark => 'Dark Theme',
      ThemeMode.system => 'Follow System Default',
    };
  }
}
