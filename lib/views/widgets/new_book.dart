import 'package:ea_frontend/localization/language_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'event_list.dart';

class NewBook extends StatefulWidget {
  const NewBook({Key? key}) : super(key: key);

  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "newBook")!,
              style: TextStyle(fontWeight: FontWeight.bold)),
          foregroundColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.network(
                  "https://static.vecteezy.com/system/resources/previews/001/200/107/original/book-png.png",
                  height: 150),
              const SizedBox(
                height: 20,
              ),
              const InputTitle(),
              const SizedBox(
                height: 10,
              ),
              InputISBN(),
              const SizedBox(
                height: 10,
              ),
              const InputDescription(),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: Text(
                  getTranslated(context, "addNewBook")!,
                  textScaleFactor: 1,
                ),
                onPressed: () {
                  if (kDebugMode) {
                    print("Add new book");
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(40),
                          child: ElevatedButton(
                            child: const Text(
                              'Back',
                              textScaleFactor: 1,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventList()),
                              );
                              print("backButton");
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange,
                                onPrimary: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ]),
            ],
          ),
        ));
  }
}

class InputTitle extends StatelessWidget {
  const InputTitle({
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
              labelText: getTranslated(context, "title")!,
              hintText: getTranslated(context, "writeTheTitle"),
              border: OutlineInputBorder()),
        ));
  }
}

class InputISBN extends StatelessWidget {
  const InputISBN({
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
              labelText: getTranslated(context, "ISBN"),
              hintText: getTranslated(context, "writeTheISBN"),
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
