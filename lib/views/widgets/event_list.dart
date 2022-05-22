import 'dart:developer';

import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/routes/user_service.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/views/event_page.dart';
import 'package:ea_frontend/views/widgets/calendar.dart';
import 'package:ea_frontend/views/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:table_calendar/table_calendar.dart';

class EventList extends StatefulWidget {
  final Function? setMainComponent;
  const EventList({
    Key? key,
    this.setMainComponent,
  }) : super(key: key);
  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  late String id;
  final List<int> colorCodes = <int>[600, 500, 400];

  var storage;
  Future<User> fetchUser() async {
    storage = LocalStorage('BookHub');
    await storage.ready;

    id = LocalStorage('BookHub').getItem('userId');
    return UserService.getUser(id);
  }

  getDate(DateTime d) {
    String date = "${d.day}/${d.month}/${d.year}";
    return Text(date);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        if (widget.setMainComponent != null) {
                          widget.setMainComponent!(
                              const BuildMap(modo: "AllEvents"));
                        } else {
                          Route route = MaterialPageRoute(
                              builder: (context) =>
                                  const BuildMap(modo: "AllEvents"));
                          Navigator.of(context).push(route);
                        }
                      },
                      tooltip: getTranslated(context, "goMap"),
                      child: const Icon(Icons.map),
                    ),
                    const SizedBox(
                      width:
                          15.0, //Esto es solo para dar cierto margen entre los FAB
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (widget.setMainComponent != null) {
                          widget.setMainComponent!(
                              const BuildCalendar(modo: "AllEvents"));
                        } else {
                          Route route = MaterialPageRoute(
                              builder: (context) =>
                                  const BuildCalendar(modo: "AllEvents"));
                          Navigator.of(context).push(route);
                        }
                      },
                      tooltip: getTranslated(context, "goCalendar"),
                      child: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(
                      width:
                          15.0, //Esto es solo para dar cierto margen entre los FAB
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.orange,
                      child: const Icon(Icons.add),
                      onPressed: () {
                        log('createEvent');
                      },
                    ),
                  ]),
              body: Column(
                children: [
                  Text(
                    getTranslated(context, 'eventTitle')!,
                    style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data?.events.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  if (widget.setMainComponent != null) {
                                    widget.setMainComponent!(EventPage(
                                        elementId:
                                            snapshot.data?.events[index].id));
                                  } else {
                                    Route route = MaterialPageRoute(
                                        builder: (context) => EventPage(
                                            elementId: snapshot
                                                .data?.events[index].id));
                                    Navigator.of(context).push(route);
                                  }
                                },
                                leading: const FlutterLogo(size: 56.0),
                                title: Text(snapshot.data?.events[index].name),
                                subtitle: getDate(snapshot
                                    .data?.events[index].eventDate as DateTime),
                                //trailing: Icon(Icons.more_vert),
                              ),
                            );
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
