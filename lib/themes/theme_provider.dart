import 'package:flutter/material.dart';
import 'package:immobiliakamer/themes/lightmode.dart';
import 'package:immobiliakamer/themes/darkmode.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode ? darkMode : lightMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
