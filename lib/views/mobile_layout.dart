import 'package:ea_frontend/views/home.dart';
import 'package:ea_frontend/views/new_book_page.dart';
import 'package:ea_frontend/views/new_club_page.dart';
import 'package:ea_frontend/views/settings_page.dart';
import 'package:ea_frontend/views/widgets/chat_list.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:ea_frontend/views/widgets/event_list.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

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
  var views = ["Home", "Club", "Event", "Chat", "Perfil"];

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
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Grup'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Event'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.face), label: 'Perfil')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
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
