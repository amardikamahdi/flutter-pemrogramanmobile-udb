import 'api_service.dart';

enum ConnectionStatus { initial, checking, connected, disconnected }

class ConnectionService {
  static Future<ConnectionStatus> checkConnection() async {
    try {
      final isConnected = await ApiService.testConnection();
      return isConnected
          ? ConnectionStatus.connected
          : ConnectionStatus.disconnected;
    } catch (e) {
      return ConnectionStatus.disconnected;
    }
  }
}
