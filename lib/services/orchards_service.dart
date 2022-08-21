import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';

class OrchardService extends ChangeNotifier {
  final List<Orchard> orchards = [];
  bool isLoading = true;
  late Orchard selectedOrchard;

  OrchardService() {
    loadOrchards();
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
}
