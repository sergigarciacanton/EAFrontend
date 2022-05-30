import 'dart:async';
import 'dart:developer';
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
  IO.Socket connectAndListen(String chatId) {
    print('Executed connectAnd Listen');
    IO.Socket socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    socket.onConnect((_) {
      print('connected websocket');
    });

    socket.emit('new-chat', chatId);
    //When an event recieved from server, data is added to the stream
    socket.on('textMessage', (data) {
      print(data + ' received');
      addResponse(data);
    });
    socket.onDisconnect((_) => print('disconnect'));

    return socket;
  }

  void sentMessage() {}
}
