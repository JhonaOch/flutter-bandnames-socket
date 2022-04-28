import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

   ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;


  SocketService(){
    _initConfig();
  }

  void _initConfig() {
    
    // Dart client
     //print("object");
   _socket = IO.io('http://192.168.100.20:3000/',IO.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Dart VM
      //.disableAutoConnect()  // disable auto-connection
       // optional
      .build()
  );
    _socket.connect();

    _socket.onConnect((_) {
    print('connect');
    _serverStatus=ServerStatus.Online;
    notifyListeners();
    
  });

  _socket.onDisconnect((_) {
    print('desconectado');
    _serverStatus=ServerStatus.Offline;
    notifyListeners();
    
  });

    // socket.on('nuevo-mensaje', (data){
    //   print('nuevo-mensaje: $data');
  

    // });
   




  
  }

}
