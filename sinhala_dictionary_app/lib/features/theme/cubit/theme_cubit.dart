import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sinhala_dictionary_app/core/services/local_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorageService localStorageService;

  ThemeCubit({required this.localStorageService})
    : super(localStorageService.getThemeMode());

  void toggleTheme() async {
    final isDark = (state == ThemeMode.dark);
    final newMode = isDark ? ThemeMode.light : ThemeMode.dark;

    emit(newMode);
    await localStorageService.saveThemeMode(newMode);
  }

  void changeTheme(ThemeMode mode) async {
    emit(mode);
    await localStorageService.saveThemeMode(mode);
  }
}
