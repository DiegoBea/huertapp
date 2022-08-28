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

  // TODO: Revisar bug al editar notificaciones
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

  bool _isFutureDate(DateTime date) {
    DateTime now = DateTime.now();
    return now.difference(date).inDays > 0;
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

  Future saveNotification(OrchardCropRelation relation) async {
    if (!relation.harvestNotification &&
        !relation.wateringNotification &&
        !relation.germinationNotification &&
        !relation.transplantNotification) {
      deleteNotification(relation.uid ?? '');
      return;
    }

    final DateFormat formatter = DateFormat("yyyy-MM-dd");

// TODO: Si la fecha es anterior a la actual, no se guarda la notificación
    OrchardNotification orchardNotification = OrchardNotification(
        uid: const Uuid().v1(),
        relationUid: relation.uid!,
        dateHarvest: relation.harvestNotification && _isFutureDate(relation.sownDate.add(Duration(days: relation.harvestDays)))
            ? formatter.format(
                relation.sownDate.add(Duration(days: relation.harvestDays)))
            : null,
        dateGermination: relation.germinationNotification && _isFutureDate(relation.sownDate.add(Duration(days: relation.germinationDays)))
            ? formatter.format(
                relation.sownDate.add(Duration(days: relation.germinationDays)))
            : null,
        // En principio, si se puede activar la notificación de transplante, los días de transplante no son nulos
        dateTransplant: relation.transplantNotification && 
                relation.transplantDays != null && _isFutureDate(relation.sownDate.add(Duration(days: relation.transplantDays!)))
            ? formatter.format(
                relation.sownDate.add(Duration(days: relation.transplantDays!)))
            : null,
        nextWatering: relation.wateringNotification &&
                relation.wateringIntervalDays != null &&
                relation.wateringIntervalDays != 0
            ? formatter.format(await _getNextWatering(
                relation.sownDate, relation.wateringIntervalDays!))
            : null);

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

  deleteNotification(String relationUid) async {
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
