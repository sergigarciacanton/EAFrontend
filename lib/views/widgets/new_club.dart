import 'package:ea_frontend/models/category.dart';
import 'package:ea_frontend/routes/club_service.dart';
import 'package:ea_frontend/views/widgets/club_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../localization/language_constants.dart';
import '../../main.dart';
import '../../models/newclub.dart';

class NewClub extends StatefulWidget {
  const NewClub({Key? key}) : super(key: key);

  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final idController = TextEditingController();
  String categoryController = "";

  @override
  Widget build(BuildContext context) {
    ClubService clubService = ClubService();
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 30,
          ),
          Image.network(
              "https://cdn-icons-png.flaticon.com/512/4693/4693893.png",
              height: 150),
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: nameController,
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
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: descriptionController,
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
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: idController,
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
              )),
          const SizedBox(
            height: 20,
          ),
          Container(
              child: Row(
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
                      child: Text('MYSTERY',
                          style: TextStyle(color: Colors.white))),
                  DropdownMenuItem<String>(
                      value: 'THRILLER',
                      child: Text('THRILLER',
                          style: TextStyle(color: Colors.white))),
                  DropdownMenuItem<String>(
                      value: 'ROMANCE',
                      child: Text('ROMANCE',
                          style: TextStyle(color: Colors.white))),
                  DropdownMenuItem<String>(
                      value: 'WESTERN',
                      child: Text('WESTERN',
                          style: TextStyle(color: Colors.white))),
                  DropdownMenuItem<String>(
                      value: 'DYSTOPIAN',
                      child: Text('DYSTOPIAN',
                          style: TextStyle(color: Colors.white))),
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
                onChanged: (category) =>
                    categoryController = category.toString(),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          )),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Text(
              getTranslated(context, "addNewClub")!,
              textScaleFactor: 1,
            ),
            onPressed: () async {
              print("Add new club");
              var response = await ClubService.newClub(NewClubModel(
                  clubname: nameController.text,
                  description: descriptionController.text,
                  idAdmin: idController.text,
                  category: categoryController));
              if (response == "201") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ClubList()));
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(response.toString()),
                    );
                  },
                );
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
