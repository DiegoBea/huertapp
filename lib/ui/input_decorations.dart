import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecorations(
      {required String hintText, required String labelText, IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(169, 180, 254, 219),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(169, 180, 254, 219), width: 2),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null ?  Icon(
          prefixIcon,
          color: const Color.fromARGB(169, 180, 254, 219),
        ) : null);
  }
}
