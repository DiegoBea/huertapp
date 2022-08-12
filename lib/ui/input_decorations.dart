import 'package:flutter/material.dart';
import 'package:huertapp/themes/app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecorations(
      {required String hintText, required String labelText, IconData? prefixIcon}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppTheme.primary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: AppTheme.primary, width: 2),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null ?  Icon(
          prefixIcon,
          color: AppTheme.primary,
        ) : null);
  }
}
