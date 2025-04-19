import 'package:bloc/bloc.dart';
import 'button_event.dart';
import 'button_state.dart';

class ButtonBloc extends Bloc<ButtonEvent, ButtonState> {
  ButtonBloc() : super(const ButtonState()) {
    on<ButtonLoading>(_onButtonLoading);
    on<ButtonPressed>(_onButtonPressed);
    on<ButtonReset>(_onButtonReset);
  }

  void _onButtonLoading(ButtonLoading event, Emitter<ButtonState> emit) {
    final loadingButtons = Map<String, bool>.from(state.loadingButtons);
    loadingButtons[event.buttonId] = event.isLoading;
    emit(state.copyWith(loadingButtons: loadingButtons));
  }

  void _onButtonPressed(ButtonPressed event, Emitter<ButtonState> emit) {
    // Handle button press action if needed
    // For now, just set loading state to true
    final loadingButtons = Map<String, bool>.from(state.loadingButtons);
    loadingButtons[event.buttonId] = true;
    emit(state.copyWith(loadingButtons: loadingButtons));
  }

  void _onButtonReset(ButtonReset event, Emitter<ButtonState> emit) {
    final loadingButtons = Map<String, bool>.from(state.loadingButtons);
    loadingButtons[event.buttonId] = false;
    emit(state.copyWith(loadingButtons: loadingButtons));
  }
}
