import 'package:equatable/equatable.dart';

class ButtonState extends Equatable {
  final Map<String, bool> loadingButtons;

  const ButtonState({this.loadingButtons = const {}});

  bool isLoading(String buttonId) {
    return loadingButtons[buttonId] ?? false;
  }

  ButtonState copyWith({Map<String, bool>? loadingButtons}) {
    return ButtonState(loadingButtons: loadingButtons ?? this.loadingButtons);
  }

  @override
  List<Object> get props => [loadingButtons];
}
