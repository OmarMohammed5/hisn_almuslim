import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    loadTheme();
  }

  //// Switch between [Dark && Light]
  void toggleTheme() async {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(newTheme);
    // save theme mode to local storage
    final prefs = await SharedPreferences.getInstance();

    /// isDark = true -> Dark Mode
    /// isDark = false -> Light Mode
    prefs.setBool("is Dark", newTheme == ThemeMode.dark);
  }

  /// Saved theme mode when user open your app again
  void loadTheme() async {
    /// load theme mode from local storage
    final prefs = await SharedPreferences.getInstance();

    /// if no theme mode saved, default to light mode
    final isDark = prefs.getBool("is Dark") ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
