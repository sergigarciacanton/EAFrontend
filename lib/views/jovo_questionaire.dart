import 'dart:async';

import 'package:ea_frontend/jovo_client/models/request.dart';
import 'package:ea_frontend/jovo_client/services/jovo_service.dart';
import 'package:ea_frontend/models/chat_message.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/socket/chat_socket.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/chat.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class JovoQuestionaire extends StatefulWidget {
  // JovoQuestionaire(this.chatId, this.userId);
  // String chatId;
  // String userId;

  @override
  State<JovoQuestionaire> createState() => _JovoQuestionaireState();
}

class _JovoQuestionaireState extends State<JovoQuestionaire> {
  final _jovoResponse = StreamController<JovoRequest>();
  void Function(JovoRequest) get addResponse => _jovoResponse.sink.add;
  Stream<JovoRequest> get getResponse => _jovoResponse.stream;

  @override
  void dispose() {
    super.dispose();
    _jovoResponse.close();
  }

  void fetchRequest() async {
    JovoRequest res =
        await JovoService.sendRequest(await JovoRequest.launchRequest());
    addResponse(res);
  }

  void sendMessage(TextEditingController textEditingController) async {
    JovoRequest res = await JovoService.sendRequest(
        await JovoRequest.textRequest(textEditingController.text));
    addResponse(res);

    textEditingController.clear();
  }

  Future<JovoRequest> fetchLaunchRequest() async {
    return JovoService.sendRequest(await JovoRequest.launchRequest());
  }

  @override
  Widget build(BuildContext context) {
    List<JovoRequest> msgList = [];

    JovoRequest? initialData;

    return FutureBuilder(
        future: fetchLaunchRequest(),
        builder: (context, AsyncSnapshot<JovoRequest> snapshot) {
          if (snapshot.hasData) {
            initialData = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                    title: const ListTile(
                      title: Text("Questioanaire"),
                    ),
                    leading: const CircleAvatar(
                      radius: 48, // Image radius
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKr-4_3JHSaiKkrTwXGXdRXkpl5dl2o7EaGg&usqp=CAU'),
                    )),
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
                  initialData: initialData,
                  builder: (context, AsyncSnapshot<JovoRequest> snapshot) {
                    if (snapshot.hasData) {
                      print('has data!!' + snapshot.data!.toString());
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
                                title: Text("Input/Output"),
                                subtitle: Text(msgList[index].output == null
                                    ? 'no output'
                                    : msgList[index].output![0].message!),
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
