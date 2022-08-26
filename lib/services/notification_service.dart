import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';

class NotificationService extends ChangeNotifier {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future _backgroundHandler(RemoteMessage message) async {
    PrintHelper.printInfo("onBackground Handler ${message.messageId}");
    ToastHelper.showToast("Message ID: ${message.messageId}");
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    PrintHelper.printInfo("onMessage Handler ${message.messageId}");
    ToastHelper.showToast("Message ID: ${message.messageId}");
  }

  static Future _onOpenHandler(RemoteMessage message) async {
    PrintHelper.printInfo("onOpen Handler ${message.messageId}");
    ToastHelper.showToast("Message ID: ${message.messageId}");
  }

  NotificationService() {
    initializeNotifications();
  }

  static Future initializeNotifications() async {
    token = await messaging.getToken();
    PrintHelper.printInfo("Messaging token: $token");

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenHandler);
  }
}
