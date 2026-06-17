import 'package:socket_io_client/socket_io_client.dart' as IO;

final urlSocket = "https://backendalmasar.napoltech.com";

class SocketHelper {
  static IO.Socket? _socket;

  static void connect() {
    if (_socket != null && _socket!.connected) {
      print('⚠️ Socket is already connected.');
      return;
    }

    _socket = IO.io(urlSocket, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionDelay': 2000,
      'reconnectionAttempts': 5,
      'rejectUnauthorized': false,
      'secure': true,
    });

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ Socket Connected');
      emitEvent("status", {"message": "Connected"});
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket Disconnected');
      emitEvent("status", {"message": "Disconnected"});
    });

    _socket!.onError((data) {
      print('🚨 Socket Error: $data');
    });
  }

  static bool isConnected() {
    return _socket != null && _socket!.connected;
  }

  /// إرسال حدث للسيرفر
  static void emitEvent(String event, dynamic data) {
    if (isConnected()) {
      _socket!.emit(event, data);
      print('📤 Emit: $event -> $data');
    } else {
      print('⚠️ Cannot emit. Socket not connected.');
    }
  }

  /// الاستماع لحدث
  static void onEvent(String event, Function(dynamic) onData) {
    _socket!.on(event, (data) {
      onData(data);
    });
  }

  /// فصل الاتصال
  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  /// التحقق من حالة الاتصال
}
