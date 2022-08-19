import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';

class VegetablePatchService extends ChangeNotifier {
  final List<VegetablePatch> vegetablePatchs = [];
  bool isLoading = true;

  VegetablePatchService() {
    loadUserVegetablePatchs().then((value) => loadVegetablePaths(value));
  }

  Future<List<String>> loadUserVegetablePatchs() async {
    print("Loading user vegetable patchs...");
    List<String> userVegetablePatchs = [];
    isLoading = true;
    notifyListeners();

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('token', isEqualTo: AuthService.userToken)
        .get();
    for (var data in result.docs) {
      // TODO: Limpiar
      List vegetablePatchsIds = data.get('vegetable_patch') as List;
      for (var vegetable_patch in vegetablePatchsIds) {
        userVegetablePatchs.add(vegetable_patch);
      }
    }
    return userVegetablePatchs;
  }

  loadVegetablePaths(List<String> value) async {
    print("Loading vegetable patchs...");
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('vegetable_patch')
        .where('uid', whereIn: value)
        .get();
    for (var element in result.docs) {
      VegetablePatch vegetable_patch = VegetablePatch(
        uid: element.get('uid'),
        name: element.get('name'),
        crops: null,
      );
      vegetablePatchs.add(vegetable_patch);
    }
    CropsService cropsService = CropsService();
    cropsService.crops.forEach((element) {
      print("${element.name} - ${element.id}");
    });

    print(cropsService.crops
        .where((element) => element.id == "-N9R0TmQ6AuHr4jWh0PM").first.name);
  }
}
