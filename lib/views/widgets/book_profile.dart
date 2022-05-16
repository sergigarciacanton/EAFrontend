import 'dart:developer';
import 'dart:js';

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
  final String id = "62696a7f776cb2959215c4a5";

  var bookStorage;
  Future<Book> fetchBook() async {
    bookStorage = LocalStorage('BookHub');
    await bookStorage.ready;
    print("check");
    return BookService.getBook(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Return to dashboard'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildRowTitle(context),
          const SizedBox(height: 50),
          buildRowAutor(),
          const SizedBox(height: 20),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Descripción:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Especificaciones',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  //decoration: TextDecoration.underline
                ),
              ),
            ),
          ),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Fecha de publicación:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Comentarios:',
                textAlign: TextAlign.left,
                style: TextStyle(
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
  }

  Widget buildRowTitle(BuildContext context) {
    return FutureBuilder(
        future: fetchBook(),
        builder: (context, AsyncSnapshot<Book> snapshot) {
          if (snapshot.hasData) {
            log("hola");
            print(snapshot.data);
            return Row(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 20,
                ),
                Text(
                  snapshot.data?.category[0].name,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 310,
                ),
                const Text(
                  '4/5',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 36.0,
                ),
              ],
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
            'Nombre Autor',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
