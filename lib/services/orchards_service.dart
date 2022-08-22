import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';
import 'package:uuid/uuid.dart';

class OrchardService extends ChangeNotifier {
  final List<Orchard> orchards = [];
  late Orchard selectedOrchard;

  bool isLoading = true;
  bool isEditing = false;
  bool isSaving = false;

  OrchardService() {
    loadOrchards();
  }

  _refreshOrder() {
    orchards.sort((a, b) => a.name.compareTo(b.name));
  }

  Future<List<Orchard>> loadOrchards() async {
    PrintHelper.printInfo("Cargando huertos...");

    String? token;
    await AuthService().readToken().then((value) => token = value);

    orchards.clear();

    if (token == null) return [];

    final QuerySnapshot ownerVegetablePatch = await FirebaseFirestore.instance
        .collection('orchards')
        .where('owners', arrayContains: token!)
        .get();
    for (var element in ownerVegetablePatch.docs) {
      Orchard orchard = Orchard(
        uid: element.get('uid'),
        name: element.get('name'),
        description: element.get('description'),
        lstOwners: List<String>.from(element.get('owners')),
        onwer: true,
      );
      orchards.add(orchard);
    }

    final QuerySnapshot guestOrchards = await FirebaseFirestore.instance
        .collection('orchards')
        .where('guests', arrayContains: token!)
        .get();
    for (var element in guestOrchards.docs) {
      Orchard orchard = Orchard(
        uid: element.get('uid'),
        name: element.get('name'),
        description: element.get('description'),
        lstOwners: List<String>.from(element.get('owners')),
        onwer: false,
      );
      orchards.add(orchard);
    }

    for (var element in orchards) {
      PrintHelper.printValue(element.name);
    }

    orchards.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    PrintHelper.printInfo("********Final lectura de huertos********");

    isLoading = false;
    notifyListeners();

    return orchards;
  }

  Future saveOrchard(Orchard orchard) async {
    isSaving = true;
    notifyListeners();

    if (orchard.uid == null) {
      await addOrchard(orchard);
    } else {
      await updateOrchard(orchard);
    }

    isSaving = false;
    notifyListeners();
  }

  Future addOrchard(Orchard orchard) async {
    String? token;
    await AuthService().readToken().then((value) => token = value);

    if (token == null) return;

    orchard.lstOwners.add(token!);
    orchard.lstGuests = [];
    orchard.uid = const Uuid().v1();

    await FirebaseFirestore.instance
        .collection('orchards')
        .add(orchard.toMap());
    orchards.add(orchard);
    _refreshOrder();
    notifyListeners();
  }

  Future updateOrchard(Orchard orchard) async {
    await FirebaseFirestore.instance
        .collection('orchards')
        .where('uid', isEqualTo: orchard.uid)
        .limit(1)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.update({
          "name": orchard.name,
          "description": orchard.description,
          "lstOwners": orchard.lstOwners,
          "lstGuests": orchard.lstGuests
        });
      }
    });
    var index = orchards.indexWhere((element) => element.uid == orchard.uid);
    orchards[index] = orchard;
    _refreshOrder();
    notifyListeners();
  }

  Future deleteOrchard(Orchard orchard) async {
    if (orchard.lstOwners.length == 1) {
      await FirebaseFirestore.instance
          .collection('orchards')
          .where('uid', isEqualTo: orchard.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    }
    orchards.remove(orchard);
    _refreshOrder();
    notifyListeners();
  }
}
