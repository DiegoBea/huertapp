import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = Colors.green.shade300;
  // TODO: Eliminar
  static TextStyle title1 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 30);
  static TextStyle title2 = const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: AppBarTheme(color: primary, elevation: 0),
    textButtonTheme:
        TextButtonThemeData(style: TextButton.styleFrom(primary: primary)),
    textTheme: TextTheme(
      headline4: TextStyle(color: primary),
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primary,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(20),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primary,
    appBarTheme: AppBarTheme(color: primary, elevation: 0),
    textButtonTheme:
        TextButtonThemeData(style: TextButton.styleFrom(primary: primary)),
    textTheme: TextTheme(
      headline4: TextStyle(color: primary),
    ),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primary,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(20),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primary),
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}
