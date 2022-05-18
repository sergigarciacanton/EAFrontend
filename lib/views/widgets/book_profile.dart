import 'dart:developer';
import 'dart:js';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ea_frontend/models/book.dart';
import 'package:ea_frontend/views/widgets/book_card.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ea_frontend/routes/book_service.dart';
import 'package:ea_frontend/localization/language_constants.dart';
import 'package:ea_frontend/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ea_frontend/models/book.dart';

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

class BookPage extends StatefulWidget {
  final Function? setMainComponent;
  const BookPage({Key? key, this.setMainComponent}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final String id = "6284b7ef2fa88c877a78dcd2";

  var bookStorage;
  Future<Book> fetchBook() async {
    bookStorage = LocalStorage('BookHub');
    await bookStorage.ready;
    print("check");
    return BookService.getBook(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchBook(),
        builder: (context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(getTranslated(context, 'returnToHome')!),
              ),
              body: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        snapshot.data!.title,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0;
                          i < ((snapshot.data!.rate / 2) - 0.1).round();
                          i++)
                        (const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 36.0,
                        )),
                      // No funciona el detectar si es par convencional asi que esto
                      if ((snapshot.data!.rate) == 1 ||
                          (snapshot.data!.rate) == 3 ||
                          (snapshot.data!.rate) == 5 ||
                          (snapshot.data!.rate) == 7 ||
                          (snapshot.data!.rate) == 9)
                        (const Icon(
                          Icons.star_half,
                          color: Colors.amber,
                          size: 36.0,
                        )),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        height: 80,
                        width: 80,
                        child: FittedBox(
                          fit: BoxFit.fill, // otherwise the logo will be tiny
                          child: FlutterLogo(),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.data!.writer,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'description')! +
                            ' : ' +
                            snapshot.data!.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'specs')!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'publishDate')! +
                            ': ' +
                            snapshot.data!.publishedDate.day.toString() +
                            "-" +
                            snapshot.data!.publishedDate.month.toString() +
                            "-" +
                            snapshot.data!.publishedDate.year.toString(),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'editorial')! +
                            ': ' +
                            snapshot.data!.editorial,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getTranslated(context, 'categories')! + ': ',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (int i = 0; i < snapshot.data!.category.length; i++)
                        (Text(
                          snapshot.data?.category[i].name + "  ",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, 'comments')! + ': PROXIMAMENTE',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            print("holaMAL");
            print(snapshot);
            log(snapshot.error.toString());
            print(snapshot.error);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget buildRowAutor() {
    return Row(
      children: const <Widget>[
        SizedBox(
          height: 80,
          width: 80,
          child: FittedBox(
            fit: BoxFit.fill, // otherwise the logo will be tiny
            child: FlutterLogo(),
          ),
        ),
        Expanded(
          child: Text(
            'Nombre Autor va aqui',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
