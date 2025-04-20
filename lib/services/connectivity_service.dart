import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final _networkStatusController = StreamController<NetworkStatus>.broadcast();
  final Connectivity _connectivity = Connectivity();
  Timer? _connectionCheckTimer;

  Stream<NetworkStatus> get networkStatus => _networkStatusController.stream;

  void initialize() {
    _checkInternetConnection();

    _connectivity.onConnectivityChanged.listen((dynamic result) {
      ConnectivityResult connectivityResult;

      if (result is List) {
        connectivityResult =
            result.isNotEmpty
                ? result.first as ConnectivityResult
                : ConnectivityResult.none;
      } else {
        connectivityResult = result as ConnectivityResult;
      }

      _validateConnectionWithInternetCheck(connectivityResult);
    });

    _connectionCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkInternetConnection();
    });
  }

  Future<void> _checkInternetConnection() async {
    try {
      final dynamic result = await _connectivity.checkConnectivity();
      ConnectivityResult connectivityResult;

      if (result is List) {
        connectivityResult =
            result.isNotEmpty
                ? result.first as ConnectivityResult
                : ConnectivityResult.none;
      } else {
        connectivityResult = result as ConnectivityResult;
      }

      _validateConnectionWithInternetCheck(connectivityResult);
    } catch (e) {
      _networkStatusController.add(NetworkStatus.offline);
    }
  }

  Future<void> _validateConnectionWithInternetCheck(
    ConnectivityResult connectivityResult,
  ) async {
    if (connectivityResult == ConnectivityResult.none) {
      _networkStatusController.add(NetworkStatus.offline);
      return;
    }

    try {
      final lookupResult = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      final hasConnection =
          lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;

      _networkStatusController.add(
        hasConnection ? NetworkStatus.online : NetworkStatus.offline,
      );
    } on SocketException catch (_) {
      _networkStatusController.add(NetworkStatus.offline);
    } on TimeoutException catch (_) {
      _networkStatusController.add(NetworkStatus.offline);
    } catch (_) {
      _networkStatusController.add(NetworkStatus.offline);
    }
  }

  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _networkStatusController.close();
    _connectionCheckTimer?.cancel();
  }
}
