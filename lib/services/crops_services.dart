import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:http/http.dart' as http;

class CropsService extends ChangeNotifier {
  // TODO: Revisar
  static final CropsService _instance = CropsService._internal();
  final String _baseUrl =
      'huertapp-609ed-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Crop> crops = [];
  bool isLoading = true;

  factory CropsService() {
    return _instance;
  }

  CropsService._internal() {
    loadCrops();
  }

  Future<List<Crop>> loadCrops() async {
    PrintHelper.printInfo("Cargando cultivos...");
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'crops.json');
    final response = await http.get(url);

    final Map<String, dynamic> cropsMap = json.decode(response.body);

    cropsMap.forEach((key, value) {
      final tmpCrop = Crop.fromMap(value);
      tmpCrop.uid = key;
      crops.add(tmpCrop);
      PrintHelper.printValue(tmpCrop.toJson());
    });

    crops.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    PrintHelper.printInfo("********Final lectura de cultivos********");

    isLoading = false;
    notifyListeners();

    return crops;
  }
}
