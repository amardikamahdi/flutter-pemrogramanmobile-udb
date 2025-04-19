import 'package:equatable/equatable.dart';

abstract class ButtonEvent extends Equatable {
  const ButtonEvent();

  @override
  List<Object> get props => [];
}

class ButtonPressed extends ButtonEvent {
  final String buttonId;

  const ButtonPressed(this.buttonId);

  @override
  List<Object> get props => [buttonId];
}

class ButtonLoading extends ButtonEvent {
  final String buttonId;
  final bool isLoading;

  const ButtonLoading(this.buttonId, this.isLoading);

  @override
  List<Object> get props => [buttonId, isLoading];
}

class ButtonReset extends ButtonEvent {
  final String buttonId;

  const ButtonReset(this.buttonId);

  @override
  List<Object> get props => [buttonId];
}
