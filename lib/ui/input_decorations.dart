import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/providers/theme_provider.dart';
import 'package:huertapp/themes/app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecorations(
      {required String hintText, required String labelText, IconData? prefixIcon, IconButton? suffixIcon}) {
    return InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: ThemeProvider.primary,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: ThemeProvider.primary, width: 2),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null ?  Icon(
          prefixIcon,
          color: ThemeProvider.primary,
        ) : null);
  }

  static InputDecoration inputDecoration(
      {String? hintText,
      String? labelText,
      IconData? prefixIcon,
      IconData? suffixIcon,
      required bool isRequired}) {
    return InputDecoration(
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: ThemeProvider.primary)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ThemeProvider.primary, width: 2)),
          labelStyle: TextStyle(color: ThemeProvider.primary),
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      suffix: isRequired
          ? Icon(
              FontAwesomeIcons.asterisk,
              color: ThemeProvider.primary,
              size: 15,
            )
          : null,
    );
  }
}
