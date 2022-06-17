import 'package:ea_frontend/models/club.dart';
import 'package:ea_frontend/models/editclub.dart';
import 'package:ea_frontend/routes/club_service.dart';
import 'package:ea_frontend/views/home_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../../localization/language_constants.dart';
import '../../models/newclub.dart';

class NewClub extends StatefulWidget {
  String? clubId;
  NewClub({
    Key? key,
    required this.clubId,
    }) : super(key: key);

  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  String idController = "";
  var storage = LocalStorage('BookHub');
  late Club club;

  void fetchUser() async {
    await storage.ready;

    idController = LocalStorage('BookHub').getItem('userId');
  }

  void fetchClub() async {
    club = await ClubService.getClub(widget.clubId!);
    nameController.text = club.name;
    descriptionController.text = club.description;
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    if(widget.clubId != null) {
      fetchClub();
    }
    else {

    }
  }

  String categoryController = "";

  @override
  Widget build(BuildContext context) {
    String category = "MYSTERY";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.clubId == null 
            ? getTranslated(context, "newClub")!
            : getTranslated(context, "editClub")!,
          style: const TextStyle(fontWeight: FontWeight.bold)
        ),
        foregroundColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                style: const TextStyle(
                    fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                    labelText: getTranslated(context, "name"),
                    hintText:
                        getTranslated(context, "writeTheNameClub"),
                    border: const OutlineInputBorder()),
              )
            ),
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
                style: const TextStyle(
                    fontSize: 20, color: Colors.black),
                decoration: InputDecoration(
                  labelText:
                      getTranslated(context, "description"),
                  hintText: getTranslated(
                      context, "writeTheDescription"),
                  border: const OutlineInputBorder()
                ),
              )
            ),
            const SizedBox(
              height: 10,
            ),
            Container (
              child: Row (
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
                        )
                      ),
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
                        )
                      )
                    ],
                    onChanged: (category) =>
                        categoryController = category.toString(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text(
                widget.clubId == null 
                  ? getTranslated(context, "addNewClub")!
                  : getTranslated(context, "submitEditClub")!,
                textScaleFactor: 1,
              ),
              onPressed: () async {
                var response;
                if(widget.clubId == null) {
                  response = await ClubService.newClub(NewClubModel(
                    clubName: nameController.text,
                    description: descriptionController.text,
                    idAdmin: idController,
                    category: categoryController
                  ));
                }
                else {
                  response = await ClubService.editClub(widget.clubId!, EditClubModel(
                    clubName: nameController.text,
                    description: descriptionController.text
                  ));
                }
                if (response == "200") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeScaffold()));
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold
                )
              ),
            )
          ]
        )
      )
    );
  }
}
