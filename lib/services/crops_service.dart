import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
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
    PrintHelper.printInfo("Cargando cultivos...");
    // Avisar a los "listeners" que se está cargando datos
    isLoading = true;
    notifyListeners();

    // Crear url para la petición http y obtener la respuesta
    final url = Uri.https(_baseUrl, 'crops.json');
    final response = await http.get(url);

    // Obtener y recorrer los resultados, añadiendolos a la lista
    final Map<String, dynamic> cropsMap = json.decode(response.body);
    cropsMap.forEach((key, value) {
      final tmpCrop = Crop.fromMap(value);
      tmpCrop.uid = key;
      crops.add(tmpCrop);
      PrintHelper.printValue(tmpCrop.toJson());
    });

    // crops.sort(
    //   (a, b) => a.name.compareTo(b.name),
    // );

    PrintHelper.printInfo("********Final lectura de cultivos********");

    // Avisar a los "listeners" que se ha terminado de cargar los datos
    isLoading = false;
    notifyListeners();

    return crops;
  }

  Crop getCropByUid(String uid) {
    return crops.firstWhere((element) => element.uid == uid);
  }
}
