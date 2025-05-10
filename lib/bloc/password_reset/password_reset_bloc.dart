import 'package:bloc/bloc.dart';
import 'password_reset_event.dart';
import 'password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {
  PasswordResetBloc() : super(const PasswordResetState()) {
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<PasswordResetReset>(_onPasswordResetReset);
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<PasswordResetState> emit,
  ) async {
    emit(
      state.copyWith(status: PasswordResetStatus.loading, email: event.email),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (event.email.contains('@')) {
        emit(state.copyWith(status: PasswordResetStatus.success));
      } else {
        emit(
          state.copyWith(
            status: PasswordResetStatus.failure,
            errorMessage: 'Invalid email address',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: PasswordResetStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onPasswordResetReset(
    PasswordResetReset event,
    Emitter<PasswordResetState> emit,
  ) {
    emit(const PasswordResetState());
  }
}
