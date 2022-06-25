import 'dart:developer';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/newchat.dart';
import 'package:ea_frontend/routes/author_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/club_page.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:ea_frontend/views/widgets/book_profile.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../routes/chat_service.dart';
import 'chat_page.dart';

class UserView extends StatefulWidget {
  final Function? setMainComponent;
  final String? elementId;
  final bool? isAuthor;
  const UserView({
    Key? key,
    this.elementId,
    this.isAuthor,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var author;
  var user;
  var currentUser;
  var titleText;
  var chat;

  @override
  void initState() {
    super.initState();
    fetchUser();
    chatExist();
  }

  Future<dynamic> fetchUser() async {
    currentUser =
        await UserService.getUser(LocalStorage('BookHub').getItem('userId'));
    author = await AuthorService.getAuthor(widget.elementId!);
    if (author != null) {
      titleText = getTranslated(context, 'writerInfo')! + " " + author.name;
      if (author.user == null) {
        return author;
      }
    }
    if (widget.isAuthor!) {
      user = await UserService.getUserdyn(author.user.id);
      if (user == null) {
        return author;
      }
    } else {
      user = await UserService.getUserdyn(widget.elementId!);
      titleText = getTranslated(context, 'userInfo')! + " " + user.userName;
    }
    chatExist();
    return user;
  }

  void chatExist() {
    if (user != null && currentUser.id != user.id) {
      currentUser.chats.forEach((element) {
        if (element.users.length == 2 &&
            (element.users[0].id == user.id ||
                element.users[1].id == user.id)) {
          chat = element.id;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(titleText),
                backgroundColor: Theme.of(context).backgroundColor,
                elevation: 1,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .selectedItemColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: Container(
                padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).shadowColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        snapshot.data!.photoURL as String))),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35, left: 20),
                      child: RichText(
                          text: TextSpan(
                              text: getTranslated(context, 'name')! + ": ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                              children: <TextSpan>[
                            TextSpan(
                                text: snapshot.data!.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal))
                          ])),
                    ),
                    (user != null)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 15, left: 20),
                            child: RichText(
                                text: TextSpan(
                                    text:
                                        getTranslated(context, 'mail')! + ": ",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: snapshot.data!.mail,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal))
                                ])),
                          )
                        : Container(),
                    (author != null)
                        ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 20),
                              child: RichText(
                                  text: TextSpan(
                                      text:
                                          getTranslated(context, 'biography')! +
                                              ": ",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: author.biography,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic))
                                  ])),
                            ),
                            (author.books.length != 0)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 35, left: 20, bottom: 15),
                                    child: Text(
                                      getTranslated(context, 'books')!,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))
                                : Container(),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: bookList(),
                                ))
                          ])
                        : const SizedBox(
                            height: 35,
                          ),
                    (user != null)
                        ? Column(children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  getTranslated(context, 'clubs')!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: clubList(snapshot),
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, bottom: 15),
                                child: Text(
                                  getTranslated(context, 'events')!,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: eventList(snapshot),
                                )),
                          ])
                        : Container(),
                    optionChat(),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
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

  Widget optionChat() {
    if (user == null || currentUser.id == user.id) {
      return Container();
    }
    print("hola" + chat.toString());

    if (chat != null) {
      return ElevatedButton(
          child: Text(getTranslated(context, 'openChat')!),
          onPressed: () => {
                Navigator.of(context).pop(),
                widget.setMainComponent!(ChatPage(
                    key: UniqueKey(),
                    chatId: chat,
                    userId: LocalStorage('BookHub').getItem('userId'))),
              });
    }

    return ElevatedButton(
        child: Text(getTranslated(context, 'startChat')!),
        onPressed: () async => {
              await ChatService.newChat(NewChatModel(
                  name: currentUser.name + " & " + user.name,
                  userIds: [currentUser.id, user.id])),
              currentUser = await UserService.getUser(
                  LocalStorage('BookHub').getItem('userId')),
              chatExist(),
              Navigator.of(context).pop(),
              widget.setMainComponent!(ChatPage(
                  key: UniqueKey(),
                  chatId: chat,
                  userId: LocalStorage('BookHub').getItem('userId')))
            });
  }

  List<Widget> clubList(AsyncSnapshot<dynamic> snapshot) {
    List<Widget> list = [];
    snapshot.data!.clubs.forEach((element) {
      list.add(Container(
          width: 300,
          height: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: Text(element.name),
                subtitle: Text(getTranslated(context, 'followers')! +
                    ": " +
                    element.usersList.length.toString()),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                    ),
                    ElevatedButton(
                        child: Text(getTranslated(context, 'more')!),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              widget.setMainComponent!(ClubPage(
                                  elementId: element.id,
                                  setMainComponent: widget.setMainComponent))
                            })
                  ]),
            ]),
          )));
    });
    return list;
  }

  List<Widget> eventList(AsyncSnapshot<dynamic> snapshot) {
    List<Widget> list = [];
    snapshot.data!.events.forEach((element) {
      list.add(Container(
          width: 300,
          height: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: Text(element.name),
                subtitle: Text(getTranslated(context, 'participants')! +
                    ": " +
                    element.usersList.length.toString()),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                    ),
                    ElevatedButton(
                        child: Text(getTranslated(context, 'more')!),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              widget.setMainComponent!(EventPage(
                                elementId: element.id,
                                setMainComponent: widget.setMainComponent,
                              ))
                            })
                  ]),
            ]),
          )));
    });
    return list;
  }

  List<Widget> bookList() {
    List<Widget> list = [];
    author.books.forEach((element) {
      list.add(Container(
          width: 300,
          height: 150,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(15),
            elevation: 10,
            child: Column(children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                title: Text(element.title),
                subtitle: Text(getTranslated(context, 'publishDate')! +
                    ": " +
                    element.publishedDate.day.toString() +
                    "/" +
                    element.publishedDate.month.toString() +
                    "/" +
                    element.publishedDate.year.toString()),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 30,
                    ),
                    ElevatedButton(
                        child: Text(getTranslated(context, 'more')!),
                        onPressed: () => {
                              Navigator.of(context).pop(),
                              widget.setMainComponent!(BookPage(
                                elementId: element.id,
                              ))
                            })
                  ]),
            ]),
          )));
    });
    return list;
  }
}
