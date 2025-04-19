import 'package:equatable/equatable.dart';

enum PasswordResetStatus { initial, loading, success, failure }

class PasswordResetState extends Equatable {
  final PasswordResetStatus status;
  final String email;
  final String? errorMessage;

  const PasswordResetState({
    this.status = PasswordResetStatus.initial,
    this.email = '',
    this.errorMessage,
  });

  PasswordResetState copyWith({
    PasswordResetStatus? status,
    String? email,
    String? errorMessage,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, email, errorMessage];
}
