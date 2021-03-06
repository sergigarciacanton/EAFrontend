import 'dart:developer';

import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/chat.dart';
import 'package:ea_frontend/models/event.dart';
import 'package:ea_frontend/routes/chat_service.dart';
import 'package:ea_frontend/routes/event_service.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/views/user_view.dart';
import 'package:ea_frontend/views/widgets/calendar.dart';
import 'package:ea_frontend/views/widgets/map.dart';
import 'package:ea_frontend/views/widgets/new_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localstorage/localstorage.dart';

import '../models/comment.dart';
import '../routes/comment_service.dart';
import 'chat_page.dart';

class EventPage extends StatefulWidget {
  final Function? setMainComponent;
  final String? elementId;

  const EventPage({
    Key? key,
    this.elementId,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late String idUser;
  late String _locale;
  var storage;

  late String eventName;
  late Chat chat;
  late String idEvent;
  List<CommentLike> commentLikeList = List.empty(growable: true);
  List<Comment> commentList = [];
  bool _nocomments = true;
  List<dynamic> usersController = List.empty(growable: true);
  TextEditingController controllerPost = TextEditingController(text: '');
  TextEditingController controllerPostTitle = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    fetchEvent();
    getEvent();
    getCommentsList();
  }

  Future<void> getCommentsList() async {
    idEvent = widget.elementId!;
    commentList = [];
    var comments = await CommentService.getCommentByType(widget.elementId!);
    if (comments != null) {
      commentList = comments;
    }
    setState(() {
      if (commentList.length != 0) {
        _nocomments = false;
        for (int cont = 0; cont < commentList.length; cont++) {
          CommentLike commentLike = CommentLike(commentList[cont], false);
          commentLikeList.add(commentLike);
        }
      }
    });
  }

  Future<void> getEvent() async {
    Event event = await EventService.getEvent(widget.elementId!);
    eventName = event.name;
    chat = await ChatService.getByName(eventName);
  }

  //GET ELEMENTID WITH widget.elementId;
  Future<Event> fetchEvent() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idUser = LocalStorage('BookHub').getItem('userId');
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    return EventService.getEvent(widget.elementId!);
  }

  Future<void> leaveEvent() async {
    await EventService.leaveEvent(widget.elementId!);
    await ChatService.leaveChat(chat.id, idUser);
    setState(() {});
  }

  Future<void> joinEvent() async {
    await EventService.joinEvent(widget.elementId!);
    await ChatService.joinChat(chat.id, idUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return FutureBuilder(
        future: fetchEvent(),
        builder: (context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                floatingActionButton: (snapshot.data!.admin.id == idUser)
                    ? FloatingActionButton(
                        heroTag: "btn2",
                        backgroundColor: Theme.of(context).iconTheme.color,
                        child: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewEvent(eventId: snapshot.data!.id)),
                          );
                          log('editEvent');
                        },
                      )
                    : null,
                body: Stack(
                  children: <Widget>[
                    SafeArea(
                        child: CustomScrollView(
                      slivers: <Widget>[
                        SliverPersistentHeader(
                          delegate: MySliverAppBar(
                              snapshot: snapshot,
                              expandedHeight: 150,
                              profileImage_url: snapshot.data!.photoURL),
                          pinned: true,
                        ),
                        SliverToBoxAdapter(
                            child: SafeArea(
                          child: SingleChildScrollView(
                              child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    minHeight: 30,
                                  ),
                                  child: IntrinsicHeight(
                                      child: Container(
                                          child: _Event(context, snapshot,
                                              screenSize))))),
                        )),
                      ],
                    ))
                  ],
                ));
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

  Widget _buildAdmin(AsyncSnapshot<Event> snapshot) {
    return Container(
        margin: EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(4.0)),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text("Admin: ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(snapshot.data?.admin.userName,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w700,
                      )),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Image(
                height: 40,
                width: 40,
                image: NetworkImage(snapshot.data?.admin.photoURL),
              )
            ],
          ),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserView(
                          elementId: snapshot.data?.admin.id,
                          isAuthor: false,
                          setMainComponent: widget.setMainComponent,
                        )))
          },
        ));
  }

  Widget _Event(
      BuildContext context, AsyncSnapshot<Event> snapshot, Size screenSize) {
    return Column(
      children: [
        Container(height: 3, color: Theme.of(context).backgroundColor),
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              SizedBox(
                width: screenSize.width / 1.5,
                child: _buildName(snapshot),
              ),
              Container(
                width: screenSize.width / 3.5,
              )
            ])),
        const SizedBox(height: 30),
        Row(children: [
          _buildDate(snapshot),
          const SizedBox(
            width: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: concatCategory(snapshot)),
        ]),
        _buildStatContainer(snapshot),
        _buildSeparator(screenSize),
        _buildDescription(context, snapshot),
        _buildSeparator(screenSize),
        Container(
          padding: const EdgeInsets.all(10),
          height: screenSize.height / 2,
          width: screenSize.width / 1.5,
          child: _buildMap(context, snapshot),
        ),
        _buildButtons(snapshot),
        _buildSeparator(screenSize),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 150.0,
                child: _nocomments
                    ? Column(
                        children: [
                          Text(getTranslated(context, 'noPosts')!),
                        ],
                      )
                    : ListView.builder(
                        itemCount: commentLikeList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CommentItem(
                            commentLikeList,
                            index,
                          );
                        }),
              ),
            ),
          ],
        ),
        (snapshot.data!.admin.id == idUser) ? addPost() : Container(),
        Container(
            width: screenSize.width / 1.5,
            constraints: BoxConstraints(maxHeight: screenSize.height / 3),
            child: SingleChildScrollView(
              child: Column(
                children: userList(snapshot),
              ),
            ))
      ],
    );
  }

  Widget addPost() {
    return FlatButton(
        child: Text(getTranslated(context, 'newPost')!),
        onPressed: () => {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        padding: EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context, 'newPost')!,
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: TextField(
                                controller: controllerPostTitle,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 3),
                                    labelText:
                                        getTranslated(context, 'postTitle')!,
                                    hintText:
                                        getTranslated(context, 'postTitle')!,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).shadowColor,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: TextFormField(
                                maxLines: 10,
                                maxLength: 1000,
                                controller: controllerPost,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(bottom: 3),
                                    labelText:
                                        getTranslated(context, 'description')!,
                                    hintText:
                                        getTranslated(context, 'description')!,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).shadowColor,
                                    )),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (controllerPost.text.isEmpty &&
                                      controllerPostTitle.text.isEmpty) {
                                    print("algun campo vacio");
                                  } else {
                                    var response =
                                        await CommentService.addComment(
                                            NewCommentModel(
                                                user: idUser,
                                                title: controllerPostTitle.text,
                                                text: controllerPost.text,
                                                type: widget.elementId!,
                                                users: usersController,
                                                likes: "0"));
                                    Navigator.of(context).pop();
                                    widget.setMainComponent!(EventPage(
                                        elementId: widget.elementId!,
                                        setMainComponent:
                                            widget.setMainComponent));
                                  }
                                },
                                child: Text(getTranslated(context, 'accept')!))
                          ],
                        ),
                      ),
                    );
                  })
            });
  }

  Widget CommentItem(List<CommentLike> commentLikeList, int index) {
    return ListTile(
        title: Text(
          commentLikeList[index].comment.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
        ),
        subtitle: Text(
          commentLikeList[index].comment.text,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
        trailing: commentLikeList[index].isSlected
            ? Icon(
                Icons.favorite,
                color: Theme.of(context).backgroundColor,
              )
            : const Icon(
                Icons.favorite_border_outlined,
                color: Colors.grey,
              ),
        onTap: () async {
          int likes = int.parse(commentLikeList[index].comment.likes);
          setState(() {
            commentLikeList[index].isSlected =
                !commentLikeList[index].isSlected;
            if (commentLikeList[index].isSlected == true) {
              likes = likes + 1;
              commentLikeList[index].comment.users.add(idUser);
            } else if (commentLikeList[index].isSlected == false) {
              commentLikeList[index]
                  .comment
                  .users
                  .removeWhere((item) => item == idUser);
            }
          });
          String id = commentLikeList[index].comment.id;
          Comment com = Comment(
              id: id,
              user: commentLikeList[index].comment.user,
              title: commentLikeList[index].comment.title,
              text: commentLikeList[index].comment.text,
              type: commentLikeList[index].comment.type,
              users: commentLikeList[index].comment.users,
              likes: likes);
          await CommentService.updateComment(
              commentLikeList[index].comment.id, com);
        });
  }

  Widget _buildName(AsyncSnapshot<Event> snapshot) {
    if (snapshot.data!.name == true) {
      eventName = snapshot.data!.name;
    }
    return Text(snapshot.data!.name,
        style: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
        ));
  }

  Widget _buildDate(AsyncSnapshot<Event> snapshot) {
    return Row(children: [
      IconButton(
        icon: const Icon(Icons.calendar_today),
        iconSize: 50,
        tooltip: getTranslated(context, "goCalendar"),
        onPressed: () {
          widget.setMainComponent!(BuildCalendar(
            modo: snapshot.data!.eventDate.toString(),
            setMainComponent: widget.setMainComponent,
            eventId: widget.elementId,
          ));
        },
      ),
      Text(
          snapshot.data!.eventDate.day.toString() +
              "-" +
              snapshot.data!.eventDate.month.toString() +
              "-" +
              snapshot.data!.eventDate.year.toString(),
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ))
    ]);
  }

  concatCategory(AsyncSnapshot<Event> snapshot) {
    List<Widget> lista = [];
    if (_locale == "en") {
      snapshot.data?.category.forEach((element) {
        lista.add(_buildCategory(context, element.en!));
      });
    } else if (_locale == "ca") {
      snapshot.data?.category.forEach((element) {
        lista.add(_buildCategory(context, element.ca!));
      });
    } else {
      snapshot.data?.category.forEach((element) {
        lista.add(_buildCategory(context, element.es!));
      });
    }
    return lista;
  }

  Widget _buildCategory(BuildContext context, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  userList(AsyncSnapshot<Event> snapshot) {
    List<Widget> lista = [];
    snapshot.data?.usersList.forEach((element) {
      if (element.id != snapshot.data!.admin.id) {
        lista.add(_buildUser(
            element.userName!, element.mail!, element.photoURL!, element.id!));
      }
    });
    return lista;
  }

  Widget _buildUser(String userName, String mail, String imageURL, String id) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(10),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        imageURL,
                        //image.transform().generate()!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text('    ' + userName),
                      Text('    (' + mail + ')'),
                    ],
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserView(
                              elementId: id,
                              isAuthor: false,
                              setMainComponent: widget.setMainComponent,
                            )));
              },
            )));
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildStatContainer(AsyncSnapshot<Event> snapshot) {
    return Container(
      height: 60.0,
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).navigationBarTheme.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem(getTranslated(context, 'followers')!,
              snapshot.data!.usersList.length.toString()),
          _buildStatItem("Posts", commentList.length.toString()),
          _buildAdmin(snapshot)
        ],
      ),
    );
  }

  Widget _buildDescription(
      BuildContext context, AsyncSnapshot<Event> snapshot) {
    TextStyle bioTextStyle = const TextStyle(
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        snapshot.data!.description,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: const EdgeInsets.only(top: 6, bottom: 6),
    );
  }

  Widget _buildButtons(AsyncSnapshot<Event> snapshot) {
    if (snapshot.data!.usersList
        .where((item) => item.id == idUser)
        .isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => widget.setMainComponent!(ChatPage(
                    key: UniqueKey(), chatId: chat.id, userId: idUser)),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Theme.of(context).indicatorColor,
                  ),
                  child: const Center(
                    child: Text(
                      "GO TO THE CHAT",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            (snapshot.data!.admin.id != idUser)
                ? const SizedBox(width: 60.0)
                : Container(),
            (snapshot.data!.admin.id != idUser)
                ? Expanded(
                    child: InkWell(
                      onTap: () => leaveEvent(),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.redAccent,
                        ),
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "leave",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => joinEvent(),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(), color: Colors.greenAccent),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Join",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMap(BuildContext context, AsyncSnapshot<Event> snapshot) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(snapshot.data!.location.latitude,
            snapshot.data!.location.longitude),
        zoom: 13.0,
        onTap: (TapPosition, LatLng) {
          widget.setMainComponent!((BuildMap(
            modo: "AllEvents",
            center: snapshot.data!.location,
            setMainComponent: widget.setMainComponent,
            eventId: widget.elementId,
          )));
        },
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              anchorPos: AnchorPos.align(AnchorAlign.center),
              width: 30.0,
              height: 30.0,
              point: LatLng(snapshot.data!.location.latitude,
                  snapshot.data!.location.longitude),
              builder: (ctx) => const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  AsyncSnapshot<Event> snapshot;
  var image = CloudinaryImage(
      'https://res.cloudinary.com/tonilovers-inc/image/upload/v1656078344/Events_bedvr3.jpg');
  String profileImage_url;
  MySliverAppBar(
      {required this.snapshot,
      required this.expandedHeight,
      required this.profileImage_url});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.width < 11000) {
      screenSize = screenSize / 5 * 4;
    }
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  image.transform().width(500).height(100).generate()!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
          child: Opacity(
            opacity: shrinkOffset / expandedHeight,
            child: Text(
              snapshot.data!.name,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 23,
              ),
            ),
          ),
        ),
        Positioned(
          top: expandedHeight / 2 - shrinkOffset,
          left: screenSize.width / 1.5,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(profileImage_url),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).backgroundColor, width: 3),
              ),
              child: SizedBox(
                height: expandedHeight,
                width: screenSize.width / 4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
