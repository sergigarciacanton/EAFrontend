import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
      colorScheme: const ColorScheme.dark(),
      iconTheme: IconThemeData(color: Colors.orange.shade500),
      backgroundColor: Colors.orange.shade500,
      navigationBarTheme:
          const NavigationBarThemeData(backgroundColor: Colors.black),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade800));

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.red.shade50,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(color: Colors.red),
    backgroundColor: Colors.red,
    navigationBarTheme:
        const NavigationBarThemeData(backgroundColor: Colors.red),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: Colors.grey.shade800),
  );
}
