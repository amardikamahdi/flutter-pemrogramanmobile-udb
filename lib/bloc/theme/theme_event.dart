import 'package:equatable/equatable.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

class ThemeSystemPreferenceLoaded extends ThemeEvent {
  final bool isDarkMode;

  const ThemeSystemPreferenceLoaded(this.isDarkMode);

  @override
  List<Object> get props => [isDarkMode];
}
