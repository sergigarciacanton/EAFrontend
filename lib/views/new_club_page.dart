import 'package:ea_frontend/views/widgets/new_club.dart';
import 'package:flutter/material.dart';

import '../localization/language_constants.dart';

class NewClubPage extends StatelessWidget {
  const NewClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NewClubPage',
        home: Scaffold(
          backgroundColor: Color.fromARGB(124, 247, 202, 111),
          appBar: AppBar(
            title: Text("N E W  C L U B"),
            foregroundColor: Colors.black,
            centerTitle: true,
            backgroundColor: Colors.orange,
          ),
          body: const NewClub(),
        ));
  }
}