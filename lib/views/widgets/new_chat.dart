import 'package:ea_frontend/models/newchat.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../localization/language_constants.dart';
import '../../models/chat.dart';
import 'event_list.dart';

class NewChat extends StatefulWidget {
  const NewChat({Key? key}) : super(key: key);

  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  final nameController = TextEditingController();
  List<String> usersController = List.empty(growable: true);

  List<UserList> userList = [
    UserList("6282807fe7cb332941b325fc", "Roberto", false),
    UserList("62836f79b688c998845cfc07", "alguien", false),
    UserList("62695e77c0d07f7296b9c37e", "Pepa", false),
  ];

  List<UserList> selectedUsers = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    ChatService chatService = ChatService();

    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "newChat")!,
              style: TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.network("https://cdn-icons-png.flaticon.com/512/61/61582.png",
                height: 200),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: nameController,
                  cursorColor: Colors.black,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, "fieldRequired");
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  decoration: InputDecoration(
                      labelText: getTranslated(context, "name"),
                      hintText: getTranslated(context, "writeTheName"),
                      border: OutlineInputBorder()),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return UserItem(
                            userList[index].id,
                            userList[index].userName,
                            userList[index].isSlected,
                            index,
                          );
                        }),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: Text(
                getTranslated(context, "addNewChat")!,
                textScaleFactor: 1,
              ),
              onPressed: () async {
                print("Add new chat");
                var response = await ChatService.newChat(NewChatModel(
                    name: nameController.text, userIds: usersController));
                if (response == "201") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatList()));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(response.toString()),
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        )));
  }

  Widget UserItem(String id, String userName, bool isSelected, int index) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.person_outline_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(
        userName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(id),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Colors.orange,
            )
          : Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
      onTap: () {
        setState(() {
          userList[index].isSlected = !userList[index].isSlected;
          if (userList[index].isSlected == true) {
            selectedUsers.add(UserList(id, userName, true));
          } else if (userList[index].isSlected == false) {
            selectedUsers.removeWhere(
                (item) => item.userName == userList[index].userName);
          }
          usersController = [];
          for (int i = 0; i < selectedUsers.length; i++) {
            usersController.add(selectedUsers[i].id);
          }
        });
      },
    );
  }
}
