import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? username;
  final String? error;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.username,
    this.error,
  });

  const AuthState.unknown() : this();

  const AuthState.authenticated(String username)
    : this(status: AuthStatus.authenticated, username: username);

  const AuthState.unauthenticated([String? error])
    : this(status: AuthStatus.unauthenticated, error: error);

  bool get isAuthenticated => status == AuthStatus.authenticated;

  AuthState copyWith({AuthStatus? status, String? username, String? error}) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, username, error];
}
