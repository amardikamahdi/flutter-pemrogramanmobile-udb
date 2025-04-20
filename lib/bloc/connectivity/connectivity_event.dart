import 'package:equatable/equatable.dart';
import '../../services/connectivity_service.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object?> get props => [];
}

class ConnectivityChanged extends ConnectivityEvent {
  final NetworkStatus status;

  const ConnectivityChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class ConnectivityRequested extends ConnectivityEvent {
  const ConnectivityRequested();
}
