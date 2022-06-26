import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/club.dart';
import 'package:ea_frontend/routes/club_service.dart';
import 'package:ea_frontend/views/user_view.dart';
import 'package:ea_frontend/views/chat_page.dart';
import 'package:ea_frontend/views/widgets/call.dart';
import 'package:ea_frontend/views/widgets/new_club.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/chat.dart';
import '../routes/chat_service.dart';

class ClubPage extends StatefulWidget {
  final Function? setMainComponent;
  final String? elementId;

  const ClubPage({
    Key? key,
    this.elementId,
    this.setMainComponent,
  }) : super(key: key);

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  late String idUser;
  late String _locale;
  var storage;
  ClientRole? _role = ClientRole.Broadcaster;
  late String clubName;
  late Chat chat;

  @override
  void initState() {
    super.initState();
    fetchClub();
    getClub();
  }

  Future<void> getClub() async {
    Club club = await ClubService.getClub(widget.elementId!);
    clubName = club.name;
    chat = await ChatService.getByName(clubName);
  }

  Future<Club> fetchClub() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    idUser = LocalStorage('BookHub').getItem('userId');
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    return ClubService.getClub(widget.elementId!);
  }

  Future<void> unsubscribe() async {
    await ClubService.unsubscribeClub(widget.elementId!);
    await ChatService.leaveChat(chat.id, idUser);
    setState(() {});
  }

  Future<void> subscribe() async {
    await ClubService.subscribeClub(widget.elementId!);
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
        future: fetchClub(),
        builder: (context, AsyncSnapshot<Club> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                floatingActionButton: (snapshot.data!.admin.id == idUser)
                    ? FloatingActionButton(
                        backgroundColor: Theme.of(context).iconTheme.color,
                        child: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                maintainState: false,
                                builder: (context) =>
                                    NewClub(clubId: widget.elementId)),
                          );
                          log('editClub');
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
                                          child: _club(context, snapshot,
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

  Widget _buildAdmin(AsyncSnapshot<Club> snapshot) {
    return Container(
        margin: const EdgeInsets.all(5),
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
                image: NetworkImage(snapshot.data!.admin!.photoURL),
              )
            ],
          ),
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    maintainState: false,
                    builder: (context) => UserView(
                          elementId: snapshot.data?.admin.id,
                          isAuthor: false,
                          setMainComponent: widget.setMainComponent,
                        )))
          },
        ));
  }

  Widget _club(
      BuildContext context, AsyncSnapshot<Club> snapshot, Size screenSize) {
    return Column(
      children: [
        Container(height: 3, color: Theme.of(context).backgroundColor),
        const SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Container(
                width: screenSize.width / 1.5,
                child: _buildName(snapshot),
              ),
              Container(
                width: screenSize.width / 3.5,
              )
            ])),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: concatCategory(snapshot),
        ),
        _buildStatContainer(snapshot),
        _buildSeparator(screenSize),
        _buildDescription(context, snapshot),
        _buildSeparator(screenSize),
        _buildVideoConference(snapshot),
        _buildButtons(snapshot),
        _buildSeparator(screenSize),
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

  Widget _buildName(AsyncSnapshot<Club> snapshot) {
    if (snapshot.data!.name == true) {
      clubName = snapshot.data!.name;
    }
    return Text(snapshot.data!.name,
        style: const TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
        ));
  }

  concatCategory(AsyncSnapshot<Club> snapshot) {
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

  userList(AsyncSnapshot<Club> snapshot) {
    List<Widget> lista = [];
    snapshot.data?.usersList.forEach((element) {
      if (element.id != snapshot.data!.admin.id) {
        lista.add(_buildUser(
            element.userName!, element.mail!, element.id!, element.photoURL));
      }
    });
    return lista;
  }

  Widget _buildUser(String userName, String mail, String id, String photoURL) {
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
                        photoURL,
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
                        maintainState: false,
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

  Widget _buildStatContainer(AsyncSnapshot<Club> snapshot) {
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
          _buildStatItem("Posts", "58"),
          _buildAdmin(snapshot)
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, AsyncSnapshot<Club> snapshot) {
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

  Widget _buildButtons(AsyncSnapshot<Club> snapshot) {
    if (snapshot.data!.usersList
        .where((item) => item.id == idUser)
        .isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => ChatPage(
                            key: UniqueKey(),
                            chatId: chat.id,
                            userId: idUser))),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color: Theme.of(context).indicatorColor,
                  ),
                  child: Center(
                    child: Text(
                      getTranslated(context, 'openChat')!.toUpperCase(),
                      style: const TextStyle(
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
                      onTap: () => unsubscribe(),
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Colors.redAccent,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              getTranslated(context, 'unsubscribe')!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
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
                onTap: () => subscribe(),
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                      border: Border.all(), color: Colors.greenAccent),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        getTranslated(context, 'subscribe')!,
                        style: const TextStyle(
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

  Widget _buildVideoConference(AsyncSnapshot<Club> snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () async => {
                // await for camera and mic permissions before pushing video page
                //await _handleCameraAndMic(Permission.camera);
                //await _handleCameraAndMic(Permission.microphone);
                // push video page with given channel name

                if (snapshot.data!.usersList
                    .where((item) => item.id == idUser)
                    .isEmpty)
                  {_role = ClientRole.Audience},
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    maintainState: false,
                    builder: (context) => CallPage(
                      channelName: snapshot.data!.name,
                      role: _role,
                    ),
                  ),
                )
              },
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                    border: Border.all(), color: Colors.blueAccent),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      getTranslated(context, 'videoconference')!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
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

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  AsyncSnapshot<Club> snapshot;

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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://res.cloudinary.com/tonilovers-inc/image/upload/v1656076593/istockphoto-1334803015-612x612_opdkva.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 15, 0, 0),
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
                  //TODO Change to club image
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
