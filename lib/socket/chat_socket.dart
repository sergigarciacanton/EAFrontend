import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  // ChatSocket streamSocket = ChatSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
  void connectAndListen() {
    print("socket connect and listen");
    IO.Socket socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    print("2");
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('event', (data) => this.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  }
}
