import 'package:equatable/equatable.dart';
import '../../services/connectivity_service.dart';

class ConnectivityState extends Equatable {
  final NetworkStatus status;
  final bool shouldShowErrorScreen;

  const ConnectivityState({
    required this.status,
    this.shouldShowErrorScreen = false,
  });

  ConnectivityState copyWith({
    NetworkStatus? status,
    bool? shouldShowErrorScreen,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      shouldShowErrorScreen:
          shouldShowErrorScreen ?? this.shouldShowErrorScreen,
    );
  }

  @override
  List<Object?> get props => [status, shouldShowErrorScreen];
}
