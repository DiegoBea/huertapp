import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[350],
        textColor: Colors.black,
        timeInSecForIosWeb: 1,
        fontSize: 15.0);
  }
}

class DaysHelper {
  static daysToMonths(int days) {
    return days ~/ 30;
  }
}

class PrintHelper {
  static printInfo(String value) {
    print("\x1B[33m$value");
  }

  static printValue(String value) {
    print("\x1B[32m$value");
  }

  static printError(String value) {
    print("\x1B[31m$value");
  }
}

class DateHelper {
  static String getDynamicDayName(int weekDay) {
    switch (weekDay) {
      case 1:
        return "Lunes";
      case 2:
        return "Martes";
      case 3:
        return "Miércoles";
      case 4:
        return "Jueves";
      case 5:
        return "Viernes";
      case 6:
        return "Sábado";
      case 7:
        return "Domingo";
      default:
        return "";
    }
  }
}
