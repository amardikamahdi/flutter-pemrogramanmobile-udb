import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/connectivity_service.dart';
import 'connectivity_event.dart';
import 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService = ConnectivityService();
  StreamSubscription? _connectivitySubscription;
  bool _hasBeenConnectedBefore = false;

  ConnectivityBloc()
    : super(
        const ConnectivityState(
          status: NetworkStatus.online,
          shouldShowErrorScreen: false,
        ),
      ) {
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ConnectivityRequested>(_onConnectivityRequested);

    _connectivitySubscription = _connectivityService.networkStatus.listen((
      status,
    ) {
      add(ConnectivityChanged(status));
    });
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    if (event.status == NetworkStatus.online) {
      _hasBeenConnectedBefore = true;
      emit(state.copyWith(status: event.status, shouldShowErrorScreen: false));
    } else {
      emit(
        state.copyWith(
          status: event.status,
          shouldShowErrorScreen: _hasBeenConnectedBefore,
        ),
      );
    }
  }

  void _onConnectivityRequested(
    ConnectivityRequested event,
    Emitter<ConnectivityState> emit,
  ) async {
    final connectionResult = await _connectivityService.checkConnection();

    if (connectionResult) {
      _hasBeenConnectedBefore = true;
      emit(
        state.copyWith(
          status: NetworkStatus.online,
          shouldShowErrorScreen: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: NetworkStatus.offline,
          shouldShowErrorScreen: _hasBeenConnectedBefore,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
