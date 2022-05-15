import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/chat.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/chat_page.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  final Function? setMainComponent;
  const ChatList({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<Chat> entries = <Chat>[];
  final String id = "626956edac92b2cdd46f10f0";
  final List<int> colorCodes = <int>[600, 500, 400];

  late Future<User> user;

  @override
  void initState() {
    super.initState();
    try {
      user = UserService.getUser(id);
    } catch (err) {
      log(err.toString());
      throw err.hashCode;
    }

    log("im here");
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Column(
              children: [
                Text(
                  getTranslated(context, 'chatTitle')!,
                  style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data?.chats.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                if (widget.setMainComponent != null) {
                                  widget.setMainComponent!(ChatPage());
                                }
                              },
                              leading: FlutterLogo(size: 56.0),
                              title: Text(snapshot.data?.chats[index].name),
                              subtitle: Text('this will be the last message'),
                              //trailing: Icon(Icons.more_vert),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
