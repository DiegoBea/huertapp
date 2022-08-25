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
    print("\x1B[33m${value}");
  }

  static printValue(String value){
    print("\x1B[32m${value}");
  }
}
