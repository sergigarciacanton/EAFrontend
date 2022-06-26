import 'dart:async';

import 'package:ea_frontend/jovo_client/models/request.dart';
import 'package:ea_frontend/jovo_client/services/jovo_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/chat_message.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/socket/chat_socket.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:ea_frontend/views/questionnaire.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/chat.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:chat_bubbles/chat_bubbles.dart';

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

  void sendMessage(TextEditingController textEditingController,
      JovoRequest launchRequest, JovoRequest launchResponse) async {
    JovoRequest req = await JovoRequest.textRequest(
        textEditingController.text, launchRequest, launchResponse);
    addResponse(req);

    JovoRequest res = await JovoService.sendRequest(req);
    addResponse(res);

    textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    List<JovoRequest> msgList = [];

    JovoRequest? launchRequest;
    JovoRequest? launchResponse;

    Widget bottomAppbar = LayoutBuilder(
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
                  sendMessage(
                      textEditingController, launchRequest!, launchResponse!);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(launchResponse!.toJson().toString());
                sendMessage(
                    textEditingController, launchRequest!, launchResponse!);
              },
              child: Icon(Icons.send, color: Colors.black),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: Theme.of(context).backgroundColor, // <-- Button color
              ),
            ),
          ],
        ),
      );
    });

    Future<JovoRequest> fetchLaunchRequest() async {
      launchRequest = await JovoRequest.launchRequest(
          LocalStorage('BookHub').getItem('userId'));
      return JovoService.sendRequest(launchRequest!);
    }

    return FutureBuilder(
        future: fetchLaunchRequest(),
        builder: (context, AsyncSnapshot<JovoRequest> snapshot) {
          if (snapshot.hasData) {
            launchResponse = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  actions: [
                    Container(
                      width: 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).backgroundColor),
                          minimumSize: MaterialStateProperty.all(
                              Size(MediaQuery.of(context).size.width, 60)),
                        ),
                        child: Text(
                          getTranslated(context, 'goToOldQuestionnaire')!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) => const Questionnaire()));
                        },
                      ),
                    ),
                    TextButton(
                      child: Text(
                        getTranslated(context, 'skip')!,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                maintainState: false,
                                builder: (context) => const HomeScaffold()));
                      },
                    ),
                  ],
                  title: ListTile(
                    title: Text(
                      getTranslated(context, 'jovoQuestionnaire')!,
                      textScaleFactor: 1.2,
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(child: bottomAppbar),
                body: StreamBuilder(
                  stream: getResponse,
                  initialData: launchResponse,
                  builder: (context, AsyncSnapshot<JovoRequest> snapshot) {
                    if (snapshot.hasData) {
                      print('has data!!' + snapshot.data!.toString());
                      msgList.add(snapshot.data!);

                      return ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: msgList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (msgList[index].context!.session!.end != null &&
                                msgList[index].context!.session!.end!) {
                              return Container(
                                width: 250,
                                child: Column(
                                  children: [
                                    BubbleSpecialThree(
                                      text: snapshot.data!.output == null
                                          ? 'no output'
                                          : snapshot.data!.output![0].message!,
                                      isSender: false,
                                      color: Theme.of(context).indicatorColor,
                                      tail: true,
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Theme.of(context)
                                                    .backgroundColor),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                60)),
                                      ),
                                      child: Text(
                                        getTranslated(context, 'proceed')!,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                maintainState: false,
                                                builder: (context) =>
                                                    const HomeScaffold()));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (msgList[index].output == null) {
                              return BubbleSpecialThree(
                                text: msgList[index].input == null
                                    ? 'no input'
                                    : msgList[index].input!.text!,
                                color: Theme.of(context).backgroundColor,
                                tail: true,
                                isSender: true,
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              );
                            } else {
                              return BubbleSpecialThree(
                                text: msgList[index].output == null
                                    ? 'no output'
                                    : msgList[index].output![0].message!,
                                isSender: false,
                                color: Theme.of(context).indicatorColor,
                                tail: true,
                                textStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              );
                            }
                          });
                    } else if (snapshot.hasError) {
                      log(snapshot.error.toString());
                      print(snapshot.error);
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
