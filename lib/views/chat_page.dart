import 'package:ea_frontend/socket/chat_socket.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  ChatPage(this.chatId);
  String chatId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    ChatSocket chatSocket = ChatSocket();
    IO.Socket socket = chatSocket.connectAndListen(widget.chatId);
    List<String> msgList = [];

    @override
    void dispose() {
      print('Dispose Chat and disconnect Socket!');
      super.dispose();
      socket.disconnect();
    }

    void sendMessage(TextEditingController textEditingController) {
      print('emit on ' + widget.chatId + ' text ' + textEditingController.text);
      socket.emit(widget.chatId, textEditingController.text);
      textEditingController.clear();
    }

    return Scaffold(
        appBar: AppBar(
            title: ListTile(
              title: Text("Chat title"),
              subtitle: Text("Online"),
            ),
            leading: CircleAvatar(
              radius: 48, // Image radius
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKr-4_3JHSaiKkrTwXGXdRXkpl5dl2o7EaGg&usqp=CAU'),
            )),
        bottomNavigationBar: BottomAppBar(child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          TextEditingController textEditingController = TextEditingController();
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: constraints.maxWidth * 4 / 5,
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (value) {
                      sendMessage(textEditingController);
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendMessage(textEditingController);
                  },
                  child: Icon(Icons.send, color: Colors.black),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    primary:
                        Theme.of(context).backgroundColor, // <-- Button color
                  ),
                ),
              ],
            ),
          );
        })),
        body: StreamBuilder(
          stream: chatSocket.getResponse,
          // initialData: [],
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              print('has data!!' + snapshot.data!);
              msgList.add(snapshot.data!);
              return ListView.builder(
                  controller: ScrollController(),
                  padding: const EdgeInsets.all(8),
                  itemCount: msgList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        onTap: () {},
                        leading: FlutterLogo(size: 56.0),
                        title: Text(msgList[index]),
                        subtitle: Text('this will be the last message'),
                        //trailing: Icon(Icons.more_vert),
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              print(snapshot.error);
              //   throw snapshot.error.hashCode;
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).backgroundColor,
              ),
            );
          },
        ));
  }
}
