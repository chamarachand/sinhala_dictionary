import 'package:flutter/material.dart';

abstract class AppTheme {
  static const _seedColor = Colors.teal;

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    appBarTheme: AppBarTheme(centerTitle: true),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(centerTitle: true),
  );
}
