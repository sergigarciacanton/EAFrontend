import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../localization/language_constants.dart';
import '../../main.dart';

class NewClub extends StatefulWidget {
  const NewClub({Key? key}) : super(key: key);

  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> {
  @override
  Widget build(BuildContext context) {
    String category = "MYSTERY";
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "newClub")!,
              style: TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Image.network(
              "https://cdn-icons-png.flaticon.com/512/4693/4693893.png",
              height: 150),
          const SizedBox(
            height: 20,
          ),
          InputName(),
          const SizedBox(
            height: 10,
          ),
          const InputDescription(),
          const SizedBox(
            height: 10,
          ),
          InputID(),
          const SizedBox(
            height: 20,
          ),
          selectCategories(context, category),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Text(
              getTranslated(context, "addNewClub")!,
              textScaleFactor: 1,
            ),
            onPressed: () {
              if (kDebugMode) {
                print("Add new club");
              }
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                onPrimary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          )
        ])));
  }
}

class InputName extends StatelessWidget {
  const InputName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          cursorColor: Colors.black,
          validator: (value) {
            if (value!.isEmpty) {
              return getTranslated(context, "fieldRequired");
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              labelText: getTranslated(context, "name"),
              hintText: getTranslated(context, "writeTheName"),
              border: OutlineInputBorder()),
        ));
  }
}

class InputDescription extends StatelessWidget {
  const InputDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          maxLines: 8,
          maxLength: 500,
          cursorColor: Colors.black,
          validator: (value) {
            if (value!.isEmpty) {
              return getTranslated(context, "fieldRequired");
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              labelText: getTranslated(context, "description"),
              hintText: getTranslated(context, "writeTheDescription"),
              border: OutlineInputBorder()),
        ));
  }
}

class InputID extends StatelessWidget {
  const InputID({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          cursorColor: Colors.black,
          validator: (value) {
            if (value!.isEmpty) {
              return getTranslated(context, "fieldRequired");
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
              labelText: "ID",
              hintText: getTranslated(context, "writeID"),
              border: OutlineInputBorder()),
        ));
  }
}

Widget selectCategories(BuildContext context, String category) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton(
            value: category,
            items: const [
              DropdownMenuItem<String>(
                  value: 'SCI-FI',
                  child: Text(
                    'SCI-FI',
                    style: TextStyle(color: Colors.white),
                  )),
              DropdownMenuItem<String>(
                  value: 'MYSTERY',
                  child:
                      Text('MYSTERY', style: TextStyle(color: Colors.white))),
              DropdownMenuItem<String>(
                  value: 'THRILLER',
                  child:
                      Text('THRILLER', style: TextStyle(color: Colors.white))),
              DropdownMenuItem<String>(
                  value: 'ROMANCE',
                  child:
                      Text('ROMANCE', style: TextStyle(color: Colors.white))),
              DropdownMenuItem<String>(
                  value: 'WESTERN',
                  child:
                      Text('WESTERN', style: TextStyle(color: Colors.white))),
              DropdownMenuItem<String>(
                  value: 'DYSTOPIAN',
                  child:
                      Text('DYSTOPIAN', style: TextStyle(color: Colors.white))),
              DropdownMenuItem<String>(
                  value: 'CONTEMPORANY',
                  child: Text('CONTEMPORANY',
                      style: TextStyle(color: Colors.white))),
              DropdownMenuItem<String>(
                  value: 'FANTASY',
                  child: Text(
                    'FANTASY',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
            onChanged: (String? value) async {
              Locale _locale = await setLocale(value!);
              MyApp.setLocale(context, _locale);
            }),
        const SizedBox(
          width: 20,
        ),
      ],
    );
