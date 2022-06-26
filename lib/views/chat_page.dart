import 'dart:async';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/chat_message.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/socket/chat_socket.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/chat.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final String chatId;
  final String userId;
  ChatPage({Key? key, required this.chatId, required this.userId})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatMessage> msgList = [];
  late Future<Chat> chat;
  var scrollController = ScrollController();
  User? user;

  late IO.Socket socket;
  final _socketResponse = StreamController<ChatMessage>();
  void Function(ChatMessage) get addResponse => _socketResponse.sink.add;
  Stream<ChatMessage> get getResponse => _socketResponse.stream;

  void connectAndListen(String chatId) {
    print('Executed connectAnd Listen');
    setState(() {
      socket = IO.io(
          const String.fromEnvironment('API_URL',
              defaultValue: 'http://localhost:3000'),
          IO.OptionBuilder().setTransports(['websocket']).build());
    });

    socket.connect();

    socket.onConnect((_) {
      print('connected websocket');
      socket.emit('new-chat', chatId);
    });

    //When an event recieved from server, data is added to the stream
    socket.on('textMessage', (data) {
      print(data + ' received');
      ChatMessage msg = ChatMessage.fromJson(jsonDecode(data));
      addResponse(msg);
    });
    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  void dispose() {
    log('Dispose Chat and disconnect Socket! ' + widget.chatId);
    socket.disconnect();
    socket.dispose();
    _socketResponse.close();
    super.dispose();
  }

  @override
  void initState() {
    print('initstate' + widget.chatId);
    chat = fetchChat();

    Future.delayed(const Duration(milliseconds: 1000),
        () => connectAndListen(widget.chatId));
    // connectAndListen(widget.chatId);
    super.initState();
  }

  Future<Chat> fetchChat() async {
    return ChatService.getChat(widget.chatId);
  }

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

  void sendMessage(TextEditingController textEditingController) {
    print('emit on ' + widget.chatId + ' text ' + textEditingController.text);
    var js = json.encode(ChatMessage.toJson(ChatMessage(
        user: user!,
        message: textEditingController.text,
        date: DateTime.now())));

    socket!.emit(widget.chatId, js);
    textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    print("build chat");

    return FutureBuilder(
        future: chat,
        builder: (context, AsyncSnapshot<Chat> snapshot) {
          if (snapshot.hasData) {
            var l = snapshot.data!.messages;
            if (l.length > 0) {
              msgList = l as List<ChatMessage>;
            }
            snapshot.data!.users.forEach((element) {
              //print(element.name);
              if (element.id == widget.userId) {
                user = element;
              }
            });

            final cloudinaryImage = CloudinaryImage(
                'https://res.cloudinary.com/tonilovers-inc/image/upload/v1656084146/424242_bycx3c.png');
            String? url;
            switch (snapshot.data!.users.length) {
              case 1:
                url = CloudinaryImage(snapshot.data!.users[0].photoURL)
                    .transform()
                    .generate();
                break;
              case 2:
                url = cloudinaryImage
                    .transform()
                    .height(50)
                    .width(50)
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[0].photoURL))
                    .gravity("west")
                    .height(50)
                    .width(24)
                    .crop("thumb")
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[1].photoURL))
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
                    .overlay(CloudinaryImage(snapshot.data!.users[0].photoURL))
                    .gravity("north_west")
                    .height(24)
                    .width(24)
                    .crop("thumb")
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[1].photoURL))
                    .gravity("north_east")
                    .height(24)
                    .width(24)
                    .crop("thumb")
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[2].photoURL))
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
                    .overlay(CloudinaryImage(snapshot.data!.users[0].photoURL))
                    .gravity("north_west")
                    .height(24)
                    .width(24)
                    .crop("thumb")
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[1].photoURL))
                    .gravity("north_east")
                    .height(24)
                    .width(24)
                    .crop("thumb")
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[2].photoURL))
                    .gravity("south_west")
                    .height(24)
                    .width(24)
                    .crop("thumb")
                    .chain()
                    .overlay(CloudinaryImage(snapshot.data!.users[2].photoURL))
                    .gravity("south_east")
                    .height(24)
                    .width(24)
                    .crop("thumb")
                    .generate();
                break;
            }
            return Scaffold(
                appBar: AppBar(
                  title: ListTile(
                    title: Text(snapshot.data!.name),
                    subtitle: Text(
                        parseUsernames(snapshot.data!.users as List<User>)),
                  ),
                  leading: CircleAvatar(
                    radius: 48, // Image radius
                    backgroundImage: NetworkImage(url!),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).backgroundColor),
                        minimumSize: MaterialStateProperty.all(Size(250, 10)),
                        maximumSize: MaterialStateProperty.all(Size(250, 20)),
                      ),
                      child: Text(
                        getTranslated(context, 'leave_chat')!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        String res = await ChatService.leaveChat(
                            widget.chatId, widget.userId);

                        if (res == "200") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScaffold()));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(res),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: BottomAppBar(child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  TextEditingController textEditingController =
                      TextEditingController();
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
                            primary: Theme.of(context)
                                .backgroundColor, // <-- Button color
                          ),
                        ),
                      ],
                    ),
                  );
                })),
                body: StreamBuilder(
                  stream: getResponse,
                  initialData: ChatMessage(
                      message: "-1", user: user, date: DateTime.now()),
                  builder: (context, AsyncSnapshot<ChatMessage> snapshot) {
                    if (snapshot.hasData) {
                      print('has data!!' + snapshot.data!.message);
                      if (snapshot.data!.message != "-1") {
                        msgList.add(snapshot.data!);
                      }
                      Future.delayed(
                          const Duration(milliseconds: 100),
                          (() => scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn)));
                      return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(8),
                          itemCount: msgList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {},
                                leading: CircleAvatar(
                                  radius: 25, // Image radius
                                  backgroundImage: NetworkImage(
                                      msgList[index].user.photoURL),
                                ),
                                title: Text(msgList[index].user.name),
                                subtitle: Text(msgList[index].message),
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
                      child: Text('No messages yet'),
                    );
                  },
                ));
          } else if (snapshot.hasError) {
            print(snapshot.error);
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }
}
