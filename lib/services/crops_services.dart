import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/models/models.dart';
import 'package:http/http.dart' as http;

class CropsService extends ChangeNotifier {
  final String _baseUrl =
      'huertapp-609ed-default-rtdb.europe-west1.firebasedatabase.app';
  final List<Crop> crops = [];
  bool isLoading = true;

  CropsService() {
    loadCrops();
  }

  Future<List<Crop>> loadCrops() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'crops.json');
    final response = await http.get(url);

    final Map<String, dynamic> cropsMap = json.decode(response.body);

    cropsMap.forEach((key, value) {
      final tmpCrop = Crop.fromMap(value);
      tmpCrop.id = key;
      crops.add(tmpCrop);
    });

    isLoading = false;
    notifyListeners();

    return crops;
  }
}
