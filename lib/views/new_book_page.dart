import 'package:ea_frontend/views/widgets/new_book.dart';
import 'package:flutter/material.dart';

class NewBookPage extends StatelessWidget {
  const NewBookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NewBookPage',
        home: Scaffold(
          backgroundColor: Color.fromARGB(124, 247, 202, 111),
          appBar: AppBar(
            title: Text('N E W   B O O K'),
            foregroundColor: Colors.black,
            centerTitle: true,
            backgroundColor: Colors.orange,
          ),
          body: const NewBook(),
        ));
  }
}
