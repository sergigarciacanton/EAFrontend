import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/club_page.dart';
import 'package:ea_frontend/views/widgets/new_club.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ClubList extends StatefulWidget {
  final Function? setMainComponent;
  const ClubList({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);
  @override
  State<ClubList> createState() => _ClubListState();
}

class _ClubListState extends State<ClubList> {
  late String id;
  final List<int> colorCodes = <int>[600, 500, 400];

  late final Future<User> myfuture;
  late String _locale;
  List<String> categories = [];

  @override
  void initState() {
    myfuture = fetchUser();
  }

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    id = LocalStorage('BookHub').getItem('userId');
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    var user = await UserService.getUser(id);
    user.clubs.forEach((element) async {
      var txt = await concatCategory(element.category);
      categories.add(txt);
    });
    return user;
  }

  concatCategory(List<dynamic> categories) {
    String txt = "";
    getLocale().then((locale) {
      _locale = locale.languageCode;
    });
    if (_locale == "en") {
      categories.forEach((element) {
        txt = txt + ", " + element.en;
      });
    } else if (_locale == "ca") {
      categories.forEach((element) {
        txt = txt + ", " + element.ca;
      });
    } else {
      categories.forEach((element) {
        txt = txt + ", " + element.es;
      });
    }
    return txt.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: myfuture,
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                backgroundColor: Theme.of(context).backgroundColor,
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewClub(clubId: null)),
                  );
                  log('createClub');
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          controller: ScrollController(),
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.clubs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: ListTile(
                                    onTap: () {
                                      widget.setMainComponent!(ClubPage(
                                          elementId:
                                              snapshot.data?.clubs[index].id,
                                          setMainComponent:
                                              widget.setMainComponent));
                                    },
                                    leading: CircleAvatar(
                                      radius: 25, // Image radius
                                      backgroundImage: NetworkImage(
                                          snapshot.data!.clubs[index].photoURL),
                                    ),
                                    title:
                                        Text(snapshot.data?.clubs[index].name),
                                    subtitle: Text(categories[index])
                                    //trailing: Icon(Icons.more_vert),

                                    ));
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
