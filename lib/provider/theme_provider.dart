import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    loadThemePrefs();
  }

  final sharedPreferences = SharedPreferences.getInstance();

  Future<void> loadThemePrefs() async {
    final prefs = await sharedPreferences;
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final prefs = await sharedPreferences;
    await prefs.setBool('isDarkMode', state);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

final appThemeProvider = Provider<ThemeData>((ref) {
  final isDarkmode = ref.watch(themeProvider);
  return isDarkmode
      ? ThemeData.dark()
      : ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(backgroundColor: ColorsConst.kWhite),
          scaffoldBackgroundColor: ColorsConst.kWhite,
        );
});
