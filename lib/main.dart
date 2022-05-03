import 'package:flutter/material.dart';
import 'package:ea_frontend/views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookHub',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        primaryColor:const Color.fromRGBO(247, 151, 28, 1),
      ),
      home: const LoginPage(),
    );
  }
}