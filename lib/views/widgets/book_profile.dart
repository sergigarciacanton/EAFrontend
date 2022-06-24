import 'dart:developer';
import 'package:ea_frontend/routes/comment_service.dart';
import 'package:ea_frontend/views/user_view.dart';
import 'package:flutter/material.dart';
import 'package:ea_frontend/models/book.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import '../../models/comment.dart';
import '../../models/user.dart';
import '../../routes/user_service.dart';

class BookPage extends StatefulWidget {
  final String? elementId;
  final Function? setMainComponent;

  const BookPage({Key? key, this.elementId, this.setMainComponent});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  List<Comment> commentList = List.empty(growable: true);
  bool _nocomments = true;

  String userid = "";
  final titleController = TextEditingController();
  final textController = TextEditingController();
  String typeController = "";
  List<dynamic> usersController = List.empty(growable: true);
  dynamic likesController = "0";
  dynamic dislikesController = "0";
  String idBook = "";

  void initState() {
    super.initState();
    fetchBook();
    getCommentsList();
    fetchUser();
    isSelected = [
      false,
      true,
      false,
    ];
  }

  Future<Book> fetchBook() async {
    return BookService.getBook(widget.elementId!);
  }

  Future<void> getCommentsList() async {
    idBook = widget.elementId!;
    typeController = idBook;
    commentList =
        (await CommentService.getCommentByType(idBook)).cast<Comment>();
    setState(() {
      if (commentList.length != 0) {
        _nocomments = false;
      }
    });
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;
    userid = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(userid);
  }

  late List<bool> isSelected;
  double fontSize = 17;
  double getFontSize(int index) {
    if (index == 0) {
      return 15;
    } else if (index == 1) {
      return 17;
    } else if (index == 2) {
      return 21;
    } else {
      return 15;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchBook(),
        builder: (context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: SingleChildScrollView(
                    child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ToggleButtons(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                          selectedColor: Theme.of(context).backgroundColor,
                          fillColor: Theme.of(context).toggleButtonsTheme.color,
                          children: [
                            Text(
                              'A',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'A',
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              'A',
                              style: TextStyle(fontSize: 21),
                            ),
                          ],
                          isSelected: isSelected,
                          onPressed: (index) {
                            for (var i = 0; i < isSelected.length; i++) {
                              if (i == index) {
                                isSelected[i] = true;
                              } else {
                                isSelected[i] = false;
                              }
                            }
                            fontSize = getFontSize(index);
                            setState(() {});
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      snapshot.data!.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: fontSize * 2,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                  Row(
                    children: stars(snapshot.data!.rate),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 80,
                        width: 80,
                        child: FittedBox(
                          fit: BoxFit.fill, // otherwise the logo will be tiny
                          child: FlutterLogo(),
                        ),
                      ),
                      Expanded(
                          child: Row(children: [
                        Text(
                          snapshot.data!.writer.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: fontSize * 2,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info),
                          iconSize: 50,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserView(
                                          elementId: snapshot.data!.writer.id,
                                          isAuthor: true,
                                          setMainComponent:
                                              widget.setMainComponent,
                                        )));
                          },
                        ),
                      ])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'description')! +
                            ' : ' +
                            snapshot.data!.description,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'specs')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize * 2,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'publishDate')! +
                            ': ' +
                            snapshot.data!.publishedDate.day.toString() +
                            "-" +
                            snapshot.data!.publishedDate.month.toString() +
                            "-" +
                            snapshot.data!.publishedDate.year.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'editorial')! +
                            ': ' +
                            snapshot.data!.editorial,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getTranslated(context, 'categories')! + ': ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < snapshot.data!.category.length; i++)
                        (Text(
                          snapshot.data?.category[i].name + "  ",
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'comments')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize * 2,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          height: 150.0,
                          child: _nocomments
                              ? Column(
                                  children: [
                                    Text(getTranslated(context, 'noComments')!),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: commentList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CommentItem(
                                      commentList[index].user,
                                      commentList[index].title,
                                      commentList[index].text,
                                      commentList[index].type,
                                      commentList[index].users,
                                      commentList[index].likes,
                                      commentList[index].dislikes,
                                      index,
                                    );
                                  }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        getTranslated(context, 'addComment')!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(context, "fieldRequired");
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: fontSize),
                        decoration: InputDecoration(
                            labelText: getTranslated(context, "title")!,
                            hintText: getTranslated(context, "writeTheTitle"),
                            border: OutlineInputBorder()),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: textController,
                        maxLines: 4,
                        maxLength: 300,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getTranslated(context, "fieldRequired");
                          }
                          return null;
                        },
                        style: TextStyle(fontSize: fontSize),
                        decoration: InputDecoration(
                            labelText: getTranslated(context, "text")!,
                            hintText: getTranslated(context, "writeTheText"),
                            border: OutlineInputBorder()),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: Text(
                      getTranslated(context, "addNewComment")!,
                      style: TextStyle(
                          fontSize: fontSize * 1.75,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () async {
                      print("Add new comment");
                      var response = await CommentService.addComment(Comment(
                          user: userid,
                          title: titleController.text,
                          text: textController.text,
                          type: typeController,
                          users: usersController,
                          likes: likesController,
                          dislikes: dislikesController));
                      if (response == "200") {
                        print("New comment added");
                        setState(() {
                          getCommentsList();
                          titleController.text = "";
                          textController.text = "";
                        });
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
                        primary: Theme.of(context).backgroundColor,
                        onPrimary: Theme.of(context).primaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        textStyle: TextStyle(
                            fontSize: fontSize * 1.75,
                            fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            )));
          } else if (snapshot.hasError) {
            print(snapshot);
            log(snapshot.error.toString());
            print(snapshot.error);
          }
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor,
            ),
          );
        });
  }

  Widget CommentItem(dynamic user, String title, String text, String type,
      List<dynamic> users, String likes, String dislikes, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).backgroundColor,
        child: Icon(
          Icons.person_outline_outlined,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        user.userName + ': ' + title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
        ),
      ),
      subtitle: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
    );
  }

  stars(int rate) {
    List<Widget> lista = [];
    int i = 0;
    for (i; i < ((rate / 2) - 0.1).round(); i++) {
      lista.add(const Icon(
        Icons.star,
        color: Colors.amber,
        size: 36.0,
      ));
    }
    // No funciona el detectar si es par convencional asi que esto
    if (rate.isOdd) {
      i++;
      lista.add(const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 36.0,
      ));
    }
    for (i; i < 5; i++) {
      lista.add(const Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 36.0,
      ));
    }
    return lista;
  }
}
