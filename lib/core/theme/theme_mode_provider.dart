import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'dark_mode';

  ThemeModeNotifier() : super(ThemeMode.system) {
    _restore();
  }

  Future<void> _restore() async {
    final preferences = await SharedPreferences.getInstance();
    state = preferences.getBool(_key) == true ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool enabled) async {
    state = enabled ? ThemeMode.dark : ThemeMode.light;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_key, enabled);
  }
}
