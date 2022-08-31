import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  final List<Province> provinces = [];
  final List<Aemet> predictions = [];
  final String _baseUrlProvinces = "www.el-tiempo.net";
  final String _baseUrlAemet = "opendata.aemet.es";
  final String _token =
      "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c";
  bool isloading = false;

  WeatherService() {
    getProvinces();
    // getWeather("01001");
    getWeather("44240");
    getWeather("44192");
    getWeather("44001");
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

  Future getWeather(String code) async {
    isloading = true;
    notifyListeners();
    final url = Uri.https(
        _baseUrlAemet,
        '/opendata/api/prediccion/especifica/municipio/diaria/$code/',
        {'api_key': _token});
    final response = await http.get(url);
    if (response.statusCode != 200) return "";

    String urlInfo = json.decode(response.body)["datos"];

    Map<String, String> urlBody = _getAemetUrl(urlInfo);

    final urlData = Uri.https(urlBody["base_url"]!, urlBody["path"]!);

    final responseData = await http.get(urlData);

    try {
      var body = jsonDecode(responseData.body);
      PrintHelper.printError("${body[0]}");
      Aemet aemet = Aemet.fromMap(body[0]);
      predictions.add(aemet);
      PrintHelper.printValue(aemet.toJson());
    } catch (e) {
      PrintHelper.printError("$e");
    }

    isloading = false;
    notifyListeners();
  }

  Map<String, String> _getAemetUrl(String url) {
    url = url.replaceAll("https://", '');
    List<String> tmpUrl = url.split('/');
    String path = '/';
    for (var i = 1; i < tmpUrl.length; i++) {
      path += "${tmpUrl[i]}/";
    }
    return {"base_url": tmpUrl[0], "path": path};
  }

  // Comunidades autónomas: https://www.el-tiempo.net/api/json/v2/provincias
  // Municipios: https://www.el-tiempo.net/api/json/v2/provincias/{$code/44}/municipios

  // Obtención de datos:
  // Base URL: https://opendata.aemet.es/opendata/
  // $baseUrl/api/prediccion/especifica/municipio/diaria/{$code/44001}/?api_key={eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c}
  // api_key = eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c
}
