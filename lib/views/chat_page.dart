import 'package:ea_frontend/models/chat.dart';
import 'package:ea_frontend/socket/chat_socket.dart';
import 'package:ea_frontend/views/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ChatPage extends StatelessWidget {
  ChatSocket chatSocket = ChatSocket();
  fetchChat() async {
    chatSocket.connectAndListen();
  }

  @override
  Widget build(BuildContext context) {
    print("connect build");
    chatSocket.connectAndListen();
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
        body: StreamBuilder(
          stream: chatSocket.getResponse,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return ChatBuble(true, snapshot.data!);
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              print(snapshot.error);
              //   throw snapshot.error.hashCode;
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
