import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';

class UserService extends ChangeNotifier {
  bool isLoading = true;
  bool isSaving = false;

  Future<FirestoreUser?> getUser(uid) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'uid',
          isEqualTo: uid,
        )
        .get();

    if (result.docs.isEmpty) return null;
    PrintHelper.printValue(result.docs[0].data().toString());
    return FirestoreUser(
        name: result.docs[0].get('name'),
        email: result.docs[0].get('email'),
        photoUrl: result.docs[0].get('photo_url'),
        uid: result.docs[0].get('uid'),
        devicesTokens: List<String>.from(result.docs[0].get('devices_tokens')));
  }

  void setUser(FirestoreUser user) async {
    PrintHelper.printInfo('Añadiendo ${user.name}...');
    PrintHelper.printInfo('Token de ${user.name}: ${user.devicesTokens}');
    await FirebaseFirestore.instance.collection("users").add(user.toMap());
    PrintHelper.printInfo('${user.name} añadido correctamente');
  }

  Future updateUser(FirestoreUser user) async {
    PrintHelper.printInfo('Actualizando ${user.name}...');
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .limit(1)
        .get()
        .then((value) {
      for (var selectedUser in value.docs) {
        selectedUser.reference.update(
          {
            "name": user.name,
            "photo_url": user.photoUrl,
            "devices_tokens": user.devicesTokens,
          }
        );
      }
    });
    PrintHelper.printInfo('${user.name} actualizado correctamente');
    notifyListeners();
  }
}
