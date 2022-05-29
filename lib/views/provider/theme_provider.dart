import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    primaryColorLight: const Color.fromARGB(181, 255, 153, 0),
    colorScheme: const ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.orange.shade500),
    indicatorColor: Colors.teal,
    backgroundColor: Colors.orange.shade500,
    shadowColor: const Color.fromARGB(143, 255, 153, 0),
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade800),
    navigationBarTheme:
      NavigationBarThemeData(backgroundColor: Colors.grey.shade800),
    bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade800),
    hintColor: Colors.orange,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.red.shade50,
    primaryColor: Colors.white,
    primaryColorLight: const Color.fromARGB(153, 251, 146, 42),
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(color: Colors.red),
    indicatorColor: Colors.pinkAccent,
    backgroundColor: Colors.red,
    shadowColor: const Color.fromARGB(153, 251, 202, 42),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
    navigationBarTheme:
      const NavigationBarThemeData(backgroundColor: Colors.red),
    bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade800),
    hintColor: Colors.red,
  );
}
