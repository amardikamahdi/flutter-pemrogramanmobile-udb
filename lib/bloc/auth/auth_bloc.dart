import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.unknown()) {
    on<AppStarted>(_onAppStarted);
    on<LogIn>(_onLogIn);
    on<SignUp>(_onSignUp);
    on<LogOut>(_onLogOut);

    // Automatically authenticate the user for demonstration purposes
    add(const LogIn(username: "Demo User", password: "123456"));
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');

    if (username != null) {
      emit(AuthState.authenticated(username));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onLogIn(LogIn event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.unknown));

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (event.username.isNotEmpty && event.password.length >= 6) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', event.username);
        emit(AuthState.authenticated(event.username));
      } else {
        emit(
          const AuthState.unauthenticated(
            'Invalid credentials. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.unknown));

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (event.username.isNotEmpty &&
          event.email.contains('@') &&
          event.password.length >= 6) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', event.username);
        emit(AuthState.authenticated(event.username));
      } else {
        emit(
          const AuthState.unauthenticated(
            'Invalid signup details. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(AuthState.unauthenticated(e.toString()));
    }
  }

  Future<void> _onLogOut(LogOut event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    emit(const AuthState.unauthenticated());
  }
}
