import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NotificationService extends ChangeNotifier {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  final DateFormat formatter = DateFormat('dd-MM-yy');

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

  Future<DateTime> _getNextWatering(DateTime sownDate, int interval) async {
    DateTime now = DateTime.now();
    int difference = now.difference(sownDate).inDays;
    int wateredCount = difference ~/ interval;
    DateTime lastWateringDate =
        sownDate.add(Duration(days: wateredCount * interval));

    DateTime nextWatering = lastWateringDate.add(Duration(days: interval));
    PrintHelper.printInfo("Siguiente regado: $nextWatering");

    return nextWatering;
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

  Future saveNotifications(OrchardCropRelation relation) async {
    OrchardNotification orchardNotification = OrchardNotification(
        uid: const Uuid().v1(),
        relationUid: relation.uid!,
        dateHarvest: relation.harvestNotification
            ? Timestamp.fromDate(
                relation.sownDate.add(Duration(days: relation.harvestDays)))
            : null,
        dateGermination: relation.germinationNotification
            ? Timestamp.fromDate(
                relation.sownDate.add(Duration(days: relation.germinationDays)))
            : null,
        // En principio, si se puede activar la notificación de transplante, los días de transplante no son nulos
        dateTransplant: relation.transplantNotification &&
                relation.transplantDays != null
            ? Timestamp.fromDate(
                relation.sownDate.add(Duration(days: relation.transplantDays!)))
            : null,
        nextWatering: relation.wateringNotification &&
                relation.wateringIntervalDays != null &&
                relation.wateringIntervalDays != 0
            ? Timestamp.fromDate(await _getNextWatering(
                relation.sownDate, relation.wateringIntervalDays!))
            : null);

    // Si ya ha pasado la fecha de cosecha, no se añade o se elimina la notificación
    if (orchardNotification.dateHarvest != null &&
        orchardNotification.dateHarvest!
                .toDate()
                .difference(DateTime.now())
                .inDays <
            0) {
      deleteNotifications(relation.uid ?? '');
      return;
    }

    await getNotification(relation.uid!).then((notification) async {
      if (notification != null) {
        var selectedNotification = await FirebaseFirestore.instance
            .collection('notifications')
            .where('uid', isEqualTo: notification.uid)
            .limit(1)
            .get();

        var element = selectedNotification.docs[0];
        element.reference.update({
          "date_harvest": orchardNotification.dateHarvest,
          "date_germination": orchardNotification.dateGermination,
          "date_transplant": orchardNotification.dateTransplant,
          "next_watering": orchardNotification.nextWatering,
        });
        return;
      }

      PrintHelper.printInfo("Añadiendo nueva notificación...");
      FirebaseFirestore.instance
          .collection('notifications')
          .add(orchardNotification.toMap());
    });
  }

  deleteNotifications(String relationUid) async {
    PrintHelper.printInfo("Eliminando notificaciones de $relationUid");
    final QuerySnapshot notifications = await FirebaseFirestore.instance
        .collection('notifications')
        .limit(1)
        .where('relation_uid', isEqualTo: relationUid)
        .get();

    if (notifications.docs.isEmpty) return null;

    for (var element in notifications.docs) {
      element.reference.delete();
    }
  }

  Future<OrchardNotification?> getNotification(String relationUid) async {
    final QuerySnapshot notifications = await FirebaseFirestore.instance
        .collection('notifications')
        .limit(1)
        .where('relation_uid', isEqualTo: relationUid)
        .get();

    if (notifications.docs.isEmpty) return null;

    var element = notifications.docs[0];

    return OrchardNotification(
        uid: element.get('uid'),
        relationUid: relationUid,
        dateHarvest: element.get('date_harvest'),
        dateGermination: element.get('date_germination'),
        dateTransplant: element.get('date_transplant'),
        nextWatering: element.get('next_watering'));
  }
}
