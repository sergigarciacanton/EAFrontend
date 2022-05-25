import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/views/club_page.dart';
import 'package:ea_frontend/views/home.dart';
import 'package:ea_frontend/views/settings_page.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  final LocalStorage storage = LocalStorage('BookHub');
  int _selectedIndex = 0;
  PageController pageController = PageController();
  String appBarTitle = 'Home';
  var views = ["Home", "Club", "Event", "Chat", "User"];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      appBarTitle = views[index];
    });
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).navigationBarTheme.backgroundColor,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: getTranslated(context, 'home')!),
            BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: getTranslated(context, 'clubTitle')!),
            BottomNavigationBarItem(
                icon: const Icon(Icons.event),
                label: getTranslated(context, 'eventTitle')!),
            BottomNavigationBarItem(
                icon: const Icon(Icons.chat),
                label: getTranslated(context, 'chatTitle')!),
            BottomNavigationBarItem(
                icon: const Icon(Icons.face),
                label: getTranslated(context, 'profile')!)
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).backgroundColor,
          unselectedItemColor: Theme.of(context).primaryColor,
          selectedIconTheme: Theme.of(context).iconTheme,
          unselectedIconTheme: Theme.of(context).iconTheme,
          onTap: onTapped),
      body: PageView(controller: pageController, children: const [
        Home(),
        ClubList(),
        EventList(),
        ChatList(),
        SettingPage(),
      ]),
    );
  }
}
