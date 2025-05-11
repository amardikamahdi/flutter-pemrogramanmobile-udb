import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.initial()) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeSystemPreferenceLoaded>(_onThemeSystemPreferenceLoaded);

    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    // Try to get saved theme preference
    final savedTheme = prefs.getString('theme_mode');

    if (savedTheme != null) {
      // If theme preference is saved, use it
      add(ThemeSystemPreferenceLoaded(savedTheme == 'dark'));
    } else {
      // If no saved preference, use the system theme
      final isPlatformDark =
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
      add(ThemeSystemPreferenceLoaded(isPlatformDark));

      // Save this preference
      await prefs.setString('theme_mode', isPlatformDark ? 'dark' : 'light');
    }
  }

  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) async {
    final newMode = state.isDarkMode ? AppThemeMode.light : AppThemeMode.dark;

    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode',
      newMode == AppThemeMode.dark ? 'dark' : 'light',
    );

    emit(state.copyWith(themeMode: newMode));
  }

  void _onThemeSystemPreferenceLoaded(
    ThemeSystemPreferenceLoaded event,
    Emitter<ThemeState> emit,
  ) {
    emit(
      state.copyWith(
        themeMode: event.isDarkMode ? AppThemeMode.dark : AppThemeMode.light,
      ),
    );
  }
}
