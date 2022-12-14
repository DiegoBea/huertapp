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

  DateTime nextWatering(DateTime sownDate, int interval) {
    DateTime now = DateTime.now();
    // Obtener los días que han pasado desde que se sembró hasta hoy
    int difference = now.difference(sownDate).inDays;
    // Obtener las veces que se debería de haber regado
    int wateredCount = difference ~/ interval;
    // Obtener la última vez que se regó, multiplicando las veces x el intervalo
    DateTime lastWateringDate =
        sownDate.add(Duration(days: wateredCount * interval));

    // Añadir a la fecha obtenida, el intervalo
    DateTime nextWatering = lastWateringDate.add(Duration(days: interval));
    PrintHelper.printInfo("Siguiente regado: $nextWatering");

    return nextWatering;
  }

  bool _isFutureDate(DateTime date) {
    DateTime now = DateTime.now();
    var result = date.difference(now).inDays >= 0;
    return result;
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
    // Comprobar las notificaciones, si no se activa ninguna, no se guarda
    if (!relation.harvestNotification &&
        !relation.wateringNotification &&
        !relation.germinationNotification &&
        !relation.transplantNotification) {
      deleteNotification(relation.uid ?? '');
      return;
    }

    final DateFormat formatter = DateFormat("yyyy-MM-dd");
    
    // Crear notificación
    OrchardNotification orchardNotification = OrchardNotification(
        uid: const Uuid().v1(),
        relationUid: relation.uid!,
        dateHarvest:
        // Si existe notificación y es futura, se indica la fecha (aplicable al resto de notificaciones)
            relation.harvestNotification && _isFutureDate(relation.sownDate.add(Duration(days: relation.harvestDays)))
                ? formatter.format(
                    relation.sownDate.add(Duration(days: relation.harvestDays)))
                : null,
        dateGermination:
            relation.germinationNotification && _isFutureDate(relation.sownDate.add(Duration(days: relation.germinationDays)))
                ? formatter.format(relation.sownDate
                    .add(Duration(days: relation.germinationDays)))
                : null,
        dateTransplant: relation.transplantNotification &&
                relation.transplantDays != null &&
                _isFutureDate(relation.sownDate
                    .add(Duration(days: relation.transplantDays!)))
            ? formatter.format(
                relation.sownDate.add(Duration(days: relation.transplantDays!)))
            : null,
        nextWatering: relation.wateringNotification &&
                relation.wateringIntervalDays != null &&
                relation.wateringIntervalDays != 0
            ? formatter.format(nextWatering(relation.sownDate, relation.wateringIntervalDays!))
            : null);

    // Obtener notificación y actualizarla (en el caso de actualizar)
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
      // Añadir notificación
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
