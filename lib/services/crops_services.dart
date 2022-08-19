import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:http/http.dart' as http;

class CropsService extends ChangeNotifier {
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
    print("Loading crops...");
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'crops.json');
    final response = await http.get(url);

    final Map<String, dynamic> cropsMap = json.decode(response.body);

    cropsMap.forEach((key, value) {
      final tmpCrop = Crop.fromMap(value);
      tmpCrop.id = key;
      crops.add(tmpCrop);
      // print(value);
      print(tmpCrop.toJson());
    });

    crops.sort(
      (a, b) => a.name.compareTo(b.name),
    );

    isLoading = false;
    notifyListeners();

    return crops;
  }
}
