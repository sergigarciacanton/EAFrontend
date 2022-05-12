import 'package:ea_frontend/views/help.dart';
import 'package:ea_frontend/views/home.dart';
import 'package:ea_frontend/views/settings_profile.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class WebLayout extends StatefulWidget {
  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  Widget mainComponent = Home();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
          body: Row(children: <Widget>[
            SizedBox(
                width: 4 * constraints.maxWidth / 5,
                // Only one scroll position can be attached to the
                // PrimaryScrollController if using Scrollbars. Providing a
                // unique scroll controller to this scroll view prevents it
                // from attaching to the PrimaryScrollController.
                child: Scrollbar(isAlwaysShown: false, child: mainComponent)),
            SizedBox(
                width: constraints.maxWidth / 5,
                // This vertical scroll view has not been provided a
                // ScrollController, so it is using the
                // PrimaryScrollController.
                child: Scrollbar(
                    isAlwaysShown: true,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.red,
                              child: ChatList()),
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.blue,
                              child: EventList()),
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              color: Colors.green,
                              child: ClubList())
                        ])))
          ]));
    });
  }
}
