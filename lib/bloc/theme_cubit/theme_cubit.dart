import 'package:coozy_the_cafe/bloc/theme_cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light));

  /// Toggles the current brightness between light and dark.
  void toggleTheme(bool? isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDarkMode == true) {
      await prefs.setBool('isDarkMode', true);
      emit(ThemeState(themeMode: ThemeMode.dark));
    } else {
      await prefs.setBool('isDarkMode', false);
      emit(ThemeState(themeMode: ThemeMode.light));
    }
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final theme = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    emit(
      ThemeState(themeMode: theme),
    );
  }

  void themeSelector() async {
    if (state.themeMode == ThemeMode.dark) {
      emit(ThemeState(themeMode: ThemeMode.light));
    } else if (state.themeMode == ThemeMode.light) {
      emit(ThemeState(themeMode: ThemeMode.dark));
    } else if (state.themeMode == ThemeMode.system) {
      emit(ThemeState(themeMode: ThemeMode.system));
    } else {
      emit(ThemeState(themeMode: ThemeMode.light));
    }
  }
}
