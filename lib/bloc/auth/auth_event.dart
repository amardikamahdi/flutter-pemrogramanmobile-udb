import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {
  const AppStarted();
}

class LogIn extends AuthEvent {
  final String username;
  final String password;

  const LogIn({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class SignUp extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const SignUp({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [username, email, password];
}

class LogOut extends AuthEvent {
  const LogOut();
}
