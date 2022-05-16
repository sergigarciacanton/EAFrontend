import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewBook extends StatefulWidget {
  const NewBook({Key? key}) : super(key: key);

  @override
  _NewBookState createState() => _NewBookState();
}

class _NewBookState extends State<NewBook> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          InputTitle(),
          const SizedBox(
            height: 10,
          ),
          InputISBN(),
          const SizedBox(
            height: 10,
          ),
          InputDescription(),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: const Text(
              'Add new book',
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
          )
        ],
      ),
    );
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
              return "The title is required.";
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
              labelText: "Title",
              hintText: "Write the title of the book",
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
              return "The ISBN is required.";
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
              labelText: "ISBN",
              hintText: "Write the ISBN of the book",
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
              return "The description is required.";
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
              labelText: "Description",
              hintText: "Write the description of the book",
              border: OutlineInputBorder()),
        ));
  }
}
