import 'dart:developer';

import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/models/club.dart';
import 'package:ea_frontend/routes/club_service.dart';
import 'package:flutter/material.dart';

class ClubEventPage extends StatefulWidget {
  final String? elementId;

  const ClubEventPage({
    Key? key,
    this.elementId,
  }) : super(key: key);

  @override
  State<ClubEventPage> createState() => _ClubEventPageState();
}

class _ClubEventPageState extends State<ClubEventPage> {
  //GET ELEMENTID WITH widget.elementId;
  Future<Club> fetchClub() async {
    return ClubService.getClub(widget.elementId!);
  }

  final String _posts = "24";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: fetchClub(),
        builder: (context, AsyncSnapshot<Club> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: Stack(
              children: <Widget>[
                _buildCoverImage(screenSize),
                SafeArea(
                    child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 20,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                height: 210,
                                child: _buildEntityImage(),
                              ),
                              Expanded(
                                  child: Container(
                                      child: _club(context, snapshot)))
                            ]),
                      )),
                ))
              ],
            ));
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

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 6,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildEntityImage() {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            width: 140.0,
            height: 140.0,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: NetworkImage(
                    'https://media.istockphoto.com/photos/group-of-friends-taking-part-in-book-club-at-home-picture-id499373254?k=20&m=499373254&s=612x612&w=0&h=Vd4LsLqIJqG6wtVVyy2590-lndlHh4j3tHn7pj4hq90='),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 4.0,
              ),
            ),
          ),
        ]));
  }

  Widget _buildAdmin(AsyncSnapshot<Club> snapshot) {
    return Container(
        padding: const EdgeInsets.all(5),
        color: Colors.grey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(snapshot.data?.admin.userName + '   '),
            const Image(
              height: 40,
              width: 40,
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80'),
            )
          ],
        ));
  }

  Widget _club(BuildContext context, AsyncSnapshot<Club> snapshot) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildName(snapshot), _buildAdmin(snapshot)],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: concatCategory(snapshot),
        ),
        _buildStatContainer("Followers",
            snapshot.data!.usersList.length.toString(), "Comments", "59"),
        _buildDescription(context, snapshot),
        Column(
          children: userList(snapshot),
        ),
        _buildButtons()
      ],
    );
  }

  Widget _buildName(AsyncSnapshot<Club> snapshot) {
    return Text(snapshot.data!.name,
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 28.0,
          fontWeight: FontWeight.w700,
        ));
  }

  concatCategory(AsyncSnapshot<Club> snapshot) {
    List<Widget> lista = [];
    snapshot.data?.category.forEach((element) {
      lista.add(_buildCategory(context, element.name!));
    });
    return lista;
  }

  Widget _buildCategory(BuildContext context, String category) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
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
      lista.add(_buildUser(element.userName!, element.mail!));
    });
    return lista;
  }

  Widget _buildUser(String userName, String mail) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text('    ' + userName + '(' + mail + ')'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = const TextStyle(
      color: Colors.black54,
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

  Widget _buildStatContainer(
      String users, String numUsers, String comments, String numComments) {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem(users, numUsers),
          _buildStatItem(comments, numComments),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, AsyncSnapshot<Club> snapshot) {
    TextStyle bioTextStyle = const TextStyle(
      fontWeight: FontWeight.w500, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
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
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => print("followed"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: const Color(0xFF404A5C),
                ),
                child: const Center(
                  child: Text(
                    "FOLLOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Message"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "MESSAGE",
                      style: TextStyle(fontWeight: FontWeight.w600),
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