import 'package:equatable/equatable.dart';

abstract class PasswordResetEvent extends Equatable {
  const PasswordResetEvent();

  @override
  List<Object?> get props => [];
}

class PasswordResetRequested extends PasswordResetEvent {
  final String email;

  const PasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordResetReset extends PasswordResetEvent {
  const PasswordResetReset();
}
