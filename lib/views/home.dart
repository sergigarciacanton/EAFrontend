import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final LocalStorage storage = LocalStorage('BookHub');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
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
                    child:
                        Text('English', style: TextStyle(color: Colors.white))),
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
    );
  }
}
