import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  final List<Province> provinces = [];
  final String _baseUrlProvinces = "www.el-tiempo.net";
  bool isloading = false;

  WeatherService() {
    getProvinces();
  }

  Future<List<Province>> getProvinces() async {
    isloading = true;
    notifyListeners();
    final url = Uri.https(_baseUrlProvinces, '/api/json/v2/provincias');
    final response = await http.get(url);

    final Map<String, dynamic> provincesMap = json.decode(response.body);

    for (MapEntry<String, dynamic> province in provincesMap.entries) {
      if (province.key == "provincias") {
        for (var provinceValue in province.value) {
          final tmpProvince = Province.fromMap(provinceValue);
          await getTownships(tmpProvince.provCod).then((value) {
            tmpProvince.townships.addAll(value);
            PrintHelper.printValue("$value");
          });
          provinces.add(tmpProvince);
          PrintHelper.printValue(tmpProvince.toJson());
        }
      }
    }

    isloading = false;
    notifyListeners();
    return provinces;
  }

  Future<List<Township>> getTownships(String provinceCode) async {
    final List<Township> townships = [];
    final url = Uri.https(
        _baseUrlProvinces, '/api/json/v2/provincias/$provinceCode/municipios');
    final response = await http.get(url);

    final Map<String, dynamic> townshipsMap = json.decode(response.body);

    for (MapEntry<String, dynamic> township in townshipsMap.entries) {
      if (township.key == "municipios") {
        try {
          var townshipsList = Map<String, dynamic>.from(township.value);
          townshipsList.forEach((key, value) {
            final tmpTownship = Township.fromJson(jsonEncode(value));
            townships.add(tmpTownship);
            PrintHelper.printValue(tmpTownship.toJson());
          });
        } catch (e) {
          PrintHelper.printError("Error: $e");
          try {
            for (var township in township.value) {
              final tmpTownship = Township.fromMap(township);
              townships.add(tmpTownship);
              PrintHelper.printValue(tmpTownship.toJson());
            }
          } catch (e) {
            PrintHelper.printError("Error: $e");
          }
        }
      }
    }

    return townships;
  }

  // Comunidades autónomas: https://www.el-tiempo.net/api/json/v2/provincias
  // Municipios: https://www.el-tiempo.net/api/json/v2/provincias/{$code/44}/municipios

  // Obtención de datos:
  // Base URL: https://opendata.aemet.es/opendata/
  // $baseUrl/api/prediccion/especifica/municipio/diaria/{$code/44001}/?api_key={eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c}
  // api_key = eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c
}
