import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AppThemeMode { light, dark }

class ThemeState extends Equatable {
  final AppThemeMode themeMode;

  const ThemeState({required this.themeMode});

  factory ThemeState.initial() =>
      const ThemeState(themeMode: AppThemeMode.light);

  ThemeState copyWith({AppThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }

  bool get isDarkMode => themeMode == AppThemeMode.dark;

  @override
  List<Object> get props => [themeMode];
}
