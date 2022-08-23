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
        photoURL: result.docs[0].get('photoURL'),
        uid: result.docs[0].get('uid'));
  }

  checkUser(FirestoreUser user) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .limit(1)
        .where(
          'email',
          isEqualTo: user.email,
        )
        .get();

    if (result.docs.isEmpty) {
      setUser(user);
      return;
    }
  }

  void setUser(FirestoreUser user) async {
    PrintHelper.printInfo('Añadiendo ${user.name}...');
    await FirebaseFirestore.instance.collection("users").add(user.toMap());
    PrintHelper.printInfo('${user.name} añadido correctamente');
  }

  Future updateUser(FirestoreUser user) async {
    PrintHelper.printInfo('Actualizando ${user.name}...');
    // PrintHelper.printInfo('${user.name} actualizado correctamente');
    notifyListeners();
  }
}
