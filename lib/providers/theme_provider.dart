import 'package:flutter/material.dart';
import 'package:huertapp/shared_preferences/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;
  static Color primary = Preferences.isDarkMode
      ? Colors.green.shade600.withOpacity(0.9)
      : Colors.green.shade300;
  static Color withoutColor =
      Preferences.isDarkMode ? Colors.grey.shade800 : Colors.white;
  static Color backgroundColor =
      Preferences.isDarkMode ? Colors.grey.shade900 : Colors.white;

  ThemeProvider({required bool isDarkMode})
      : currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();

  setLightMode() {
    currentTheme = ThemeData.light();
    primary = Colors.green.shade300;
    withoutColor = Colors.white;
    notifyListeners();
  }

  setDarkMode() {
    currentTheme = ThemeData.dark();
    primary = Colors.green.shade600.withOpacity(0.9);
    withoutColor = Colors.grey.shade800;
    notifyListeners();
  }
}
