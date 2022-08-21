import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huertapp/themes/app_theme.dart';

class InputDecorations {
  static InputDecoration authInputDecorations(
      {required String hintText, required String labelText, IconData? prefixIcon, IconButton? suffixIcon}) {
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
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null ?  Icon(
          prefixIcon,
          color: AppTheme.primary,
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
          OutlineInputBorder(borderSide: BorderSide(color: AppTheme.primary), borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primary, width: 2), borderRadius: BorderRadius.circular(15)),
          labelStyle: TextStyle(color: AppTheme.primary),
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
      suffix: isRequired
          ? Icon(
              FontAwesomeIcons.asterisk,
              color: AppTheme.primary,
              size: 15,
            )
          : null,
    );
  }
}
