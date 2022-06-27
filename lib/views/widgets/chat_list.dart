import 'dart:developer';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/chat_page.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import 'new_chat.dart';

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
  late String id;
  final List<int> colorCodes = <int>[600, 500, 400];
  late final Future<User> myfuture;

  String parseUsernames(List<User> userList) {
    String s = "";
    userList.forEach((element) {
      s = s + element.userName + ", ";
    });

    if (s != null && s.length >= 2) {
      s = s.substring(0, s.length - 2);
    }
    return s;
  }

  @override
  void initState() {
    myfuture = fetchUser();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    id = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myfuture,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                heroTag: "btn6",
                backgroundColor: Theme.of(context).backgroundColor,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewChat()),
                  );
                  log('createChat');
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            final cloudinaryImage = CloudinaryImage(
                                'https://res.cloudinary.com/tonilovers-inc/image/upload/v1656084146/424242_bycx3c.png');
                            String? url;
                            switch (snapshot.data!.chats[index].users.length) {
                              case 1:
                                url = CloudinaryImage(snapshot
                                        .data!.chats[index].users[0].photoURL)
                                    .transform()
                                    .generate();
                                break;
                              case 2:
                                url = cloudinaryImage
                                    .transform()
                                    .height(50)
                                    .width(50)
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[0].photoURL))
                                    .gravity("west")
                                    .height(50)
                                    .width(24)
                                    .crop("thumb")
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[1].photoURL))
                                    .gravity("east")
                                    .height(50)
                                    .width(24)
                                    .crop("thumb")
                                    .generate();
                                break;

                              case 3:
                                url = cloudinaryImage
                                    .transform()
                                    .height(50)
                                    .width(50)
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[0].photoURL))
                                    .gravity("north_west")
                                    .height(24)
                                    .width(24)
                                    .crop("thumb")
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[1].photoURL))
                                    .gravity("north_east")
                                    .height(24)
                                    .width(24)
                                    .crop("thumb")
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[2].photoURL))
                                    .gravity("south")
                                    .height(24)
                                    .width(49)
                                    .crop("thumb")
                                    .generate();
                                break;

                              default:
                                url = cloudinaryImage
                                    .transform()
                                    .height(50)
                                    .width(50)
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[0].photoURL))
                                    .gravity("north_west")
                                    .height(24)
                                    .width(24)
                                    .crop("thumb")
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[1].photoURL))
                                    .gravity("north_east")
                                    .height(24)
                                    .width(24)
                                    .crop("thumb")
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[2].photoURL))
                                    .gravity("south_west")
                                    .height(24)
                                    .width(24)
                                    .crop("thumb")
                                    .chain()
                                    .overlay(CloudinaryImage(snapshot
                                        .data!.chats[index].users[2].photoURL))
                                    .gravity("south_east")
                                    .height(24)
                                    .width(24)
                                    .crop("thumb")
                                    .generate();
                                break;
                            }

                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  Widget nextPage = await ChatPage(
                                      key: UniqueKey(),
                                      chatId: snapshot.data?.chats[index].id,
                                      userId: id);

                                  widget.setMainComponent!(nextPage);
                                },
                                leading: CircleAvatar(
                                  radius: 25, // Image radius
                                  backgroundImage: NetworkImage(url!),
                                ),
                                title: Text(snapshot.data?.chats[index].name),
                                subtitle: Text(parseUsernames(snapshot
                                    .data?.chats[index].users as List<User>)),
                                //trailing: Icon(Icons.more_vert),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            log(snapshot.error.toString());
            print(snapshot.error);
            //   throw snapshot.error.hashCode;
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }
}
