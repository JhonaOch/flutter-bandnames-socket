import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  // ignore: constant_identifier_names
  Online,
  // ignore: constant_identifier_names
  Offline,
  // ignore: constant_identifier_names
  Connecting
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    //print("object");
    _socket = IO.io(
        'https://dev-backend-jh.herokuapp.com/',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            //.disableAutoConnect()  // disable auto-connection
            // optional
            .build());
    _socket.connect();

    _socket.onConnect((_) {
      //print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      //print('desconectado');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (data){
    //   print('nuevo-mensaje: $data');

    // });
  }
}
