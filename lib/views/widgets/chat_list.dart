import 'dart:developer';

import 'package:ea_frontend/models/chat.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Chat> entries = <Chat>[];
  final String id = "626956edac92b2cdd46f10f0";
  final List<int> colorCodes = <int>[600, 500, 100];

  late Future<User> user;

  @override
  void initState() {
    super.initState();
    user = UserService.getUser(id);

    log("im here");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    color: Colors.amber[colorCodes[index]],
                    child: Center(child: Text('Entry ${snapshot.data}')),
                  );
                });
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
