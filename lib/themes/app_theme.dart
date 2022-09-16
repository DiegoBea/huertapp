import 'package:flutter/material.dart';
import 'package:huertapp/shared_preferences/preferences.dart';

class AppTheme {
  static Color primary = Preferences.isDarkMode ? Colors.green.shade300 : Colors.red;
  static TextStyle title1 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
  static TextStyle title2 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
}
