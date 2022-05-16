import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NewClub extends StatefulWidget {
  const NewClub({Key? key}) : super(key: key);

  @override
  _NewClubState createState() => _NewClubState();
}

class _NewClubState extends State<NewClub> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          InputName(),
          const SizedBox(
            height: 10,
          ),
          const InputDescription(),
          const SizedBox(
            height: 10,
          ),
          InputCategory(),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text(
              'Add new club',
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
        ],
      ),
    );
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
              return "The name is required.";
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Write the name of the club",
              border: OutlineInputBorder()),
        ));
  }
}

class InputCategory extends StatelessWidget {
  const InputCategory({
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
              return "The category is required.";
            }
            return null;
          },
          style: const TextStyle(fontSize: 20, color: Colors.black),
          decoration: const InputDecoration(
              labelText: "Category",
              hintText: "Adventure, Fantasy, Romance, Contemponary",
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
              hintText: "Write the description of the club",
              border: OutlineInputBorder()),
        ));
  }
}
