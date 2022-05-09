import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LocalStorage storage = LocalStorage('BookHub');
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
      body: PageView(controller: pageController, children: [
        Column(
          children: [
            const SizedBox(height: 50),
            Text(
              getTranslated(context, 'interest')!,
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return BookCard(
                      title: "Book " + index.toString(),
                      rate: (5 - index).toString(),
                      imageUrl: "");
                },
              ),
            ),
            DropdownButton(
                value: getTranslated(context, 'lenguageCode')!,
                items: const [
                  DropdownMenuItem<String>(
                      value: 'es',
                      child: Text(
                        'Español',
                        style: TextStyle(color: Colors.white),
                      )),
                  DropdownMenuItem<String>(
                      value: 'en',
                      child: Text('English',
                          style: TextStyle(color: Colors.white))),
                  DropdownMenuItem<String>(
                      value: 'ca',
                      child: Text(
                        'Català',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
                onChanged: (String? value) async {
                  Locale _locale = await setLocale(value!);
                  MyApp.setLocale(context, _locale);
                }),
          ],
        ),
      ]),
    );
  }
}
