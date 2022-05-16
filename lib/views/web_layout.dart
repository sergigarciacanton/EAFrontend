import 'package:ea_frontend/views/chat_page.dart';
import 'package:ea_frontend/views/help.dart';
import 'package:ea_frontend/views/home.dart';
import 'package:ea_frontend/views/settings_profile.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class WebLayout extends StatefulWidget {
  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  Widget mainComponent = Home();

  setMainComponent(Widget component) {
    setState(() {
      mainComponent = component;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            "public/logo.png",
            fit: BoxFit.contain,
            height: 64,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {
                setState(() {
                  mainComponent = Home();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Profile and App settings',
              onPressed: () {
                setState(() {
                  mainComponent = SettingsProfile();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'Help',
              onPressed: () {
                setState(() {
                  mainComponent = Help();
                });
              },
            )
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Row(children: <Widget>[
            SizedBox(
                width: 4 * constraints.maxWidth / 5,
                child: Scrollbar(isAlwaysShown: false, child: mainComponent)),
            SizedBox(
                width: constraints.maxWidth / 5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          //   color: Colors.red,
                          height: constraints.maxHeight / 3,
                          width: constraints.maxWidth / 5,
                          child: ChatList(
                            setMainComponent: setMainComponent,
                          )),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          height: constraints.maxHeight / 3,
                          width: constraints.maxWidth / 5,
                          //    color: Colors.blue,
                          child: EventList(
                            setMainComponent: setMainComponent,
                          )),
                      Container(
                          padding: const EdgeInsets.all(10.0),
                          height: constraints.maxHeight / 3,
                          width: constraints.maxWidth / 5,
                          //   color: Colors.green,
                          child: ClubList(
                            setMainComponent: setMainComponent,
                          ))
                    ]))
          ]);
        }));
  }
}
