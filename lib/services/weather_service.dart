import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:http/http.dart' as http;

class WeatherService extends ChangeNotifier {
  final List<Province> provinces = [];
  final Map<String, Map<String, dynamic>> predictions = {};
  final String _baseUrlProvinces = "www.el-tiempo.net";
  final String _baseUrlAemet = "opendata.aemet.es";
  final String _token =
      "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c";
  bool isloading = false;

  WeatherService() {
    // getProvinces();
    getWeather("44240");
    getWeather("44192");
    getWeather("44216");
    getWeather("01001");
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
    Map<String, HourlyPrediction> hourly = {};
    Map<String, DailyPrediction> daily = {};
    await getWeatherHourly(code)
        .then((value) => value != null ? hourly = {"hourly": value} : null);
    await getWeatherDaily(code)
        .then((value) => value != null ? daily = {"daily": value} : null);

    if (hourly.entries.isNotEmpty && daily.entries.isNotEmpty) {
      predictions[code] = {};
      for (var map in [hourly, daily]) {
        for (var entry in map.entries) {
          predictions[code]!.addAll({entry.key: entry.value});
        }
      }
    }

    _sortList();
    isloading = false;
    notifyListeners();
  }

  Future<DailyPrediction?> getWeatherDaily(String code) async {
    final url = Uri.https(
        _baseUrlAemet,
        '/opendata/api/prediccion/especifica/municipio/diaria/$code/',
        {'api_key': _token});
    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    String urlInfo = json.decode(response.body)["datos"];

    Map<String, String> urlBody = _getAemetUrl(urlInfo);

    final urlData = Uri.https(urlBody["base_url"]!, urlBody["path"]!);

    PrintHelper.printInfo(urlData.toString());

    final responseData = await http.get(urlData);

    var body = jsonDecode(responseData.body);
    DailyPrediction aemet = DailyPrediction.fromMap(body[0]);
    PrintHelper.printValue(aemet.toJson());
    return aemet;
  }

  Future<HourlyPrediction?> getWeatherHourly(String code) async {
    final url = Uri.https(
        _baseUrlAemet,
        '/opendata/api/prediccion/especifica/municipio/horaria/$code/',
        {'api_key': _token});
    final response = await http.get(url);
    if (response.statusCode != 200) return null;

    String urlInfo = json.decode(response.body)["datos"];

    Map<String, String> urlBody = _getAemetUrl(urlInfo);

    final urlData = Uri.https(urlBody["base_url"]!, urlBody["path"]!);

    PrintHelper.printInfo(urlData.toString());

    final responseData = await http.get(urlData);

    var body = jsonDecode(responseData.body);
    HourlyPrediction aemet = HourlyPrediction.fromMap(body[0]);
    // aemet.temperaturaActual = aemet.prediccion.dia[0].temperatura.dato.where((element) => element.)
    return aemet;
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

  String getSkyType(String value) {
    switch (value) {
      case "11":
      case "11n":
        return "Despejado";
      case "12":
      case "12n":
        return "Poco nuboso";
      case "13":
      case "13n":
        return "Intervalos nubosos";
      case "14":
      case "14n":
        return "Nuboso";
      case "15":
      case "15n":
        return "Muy nuboso";
      case "16":
      case "16n":
        return "Cubierto";
      case "17":
      case "17n":
        return "Nubes altas";
      case "23":
      case "23n":
        return "Intervalos nubosos con lluvia escasa";
      case "24":
      case "24n":
        return "Nuboso con lluvia";
      case "25":
        return "Cubierto con lluvia";
      case "26":
        return "Muy nuboso con lluvia";
      case "33":
      case "33n":
        return "Intervalos nubosos con nieve";
      case "34":
      case "34n":
        return "Nuboso con nieve";
      case "35":
        return "Muy nuboso con nieve";
      case "36":
        return "Cubierto con nieve";
      case "43":
      case "43n":
        return "Intervalos nubosos con lluvia escasa";
      case "46":
        return "Cubierto con lluvia escasa";
      case "51":
      case "51n":
        return "Intervalos nubosos con tormenta";
      case "52":
      case "52n":
        return "Nuboso con tormenta";
      case "53":
        return "Muy nuboso con tormenta";
      case "54":
        return "Cubierto con tormenta";
      case "61":
      case "61n":
        return "Intervalos nubosos con tormenta y lluvia escasa";
      case "62":
      case "62n":
        return "Nuboso con tormenta y lluvia escasa";
      case "63":
        return "Muy nuboso con tormenta y lluvia escasa";
      case "64":
        return "Cubierto con tormenta y lluvia escasa";
      case "71":
      case "71n":
        return "Intervalos nubosos con nieve escasa";
      case "72":
      case "72n":
        return "Nubosos con nieve escasa";
      case "73":
        return "Muy nuboso con nieve escasa";
      case "74":
        return "Cubierto con nieve escasa";
      case "81":
        return "Niebla";
      case "82":
        return "Bruma";
      case "83":
        return "Niebla";
      default:
        return "despejado";
    }
  }

  _sortList() {
    var sortedEntries = predictions.entries.toList()
      ..sort((a, b) {
        var aValue = a.value["hourly"] as HourlyPrediction;
        var bValue = b.value["hourly"] as HourlyPrediction;
        return aValue.nombre.compareTo(bValue.nombre);
      });

    predictions
      ..clear()
      ..addEntries(sortedEntries);
  }

  // Comunidades autónomas: https://www.el-tiempo.net/api/json/v2/provincias
  // Municipios: https://www.el-tiempo.net/api/json/v2/provincias/{$code/44}/municipios

  // Obtención de datos:
  // Base URL: https://opendata.aemet.es/opendata/
  // $baseUrl/api/prediccion/especifica/municipio/diaria/{$code/44001}/?api_key={eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c}
  // api_key = eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkaWVnb2JlYWdvbWV6MUBnbWFpbC5jb20iLCJqdGkiOiJhNzE2OTc1Ni04NmYyLTRkM2UtOTYyOS02MTgwNmRmOGYzZTMiLCJpc3MiOiJBRU1FVCIsImlhdCI6MTY1OTM4MDc4MSwidXNlcklkIjoiYTcxNjk3NTYtODZmMi00ZDNlLTk2MjktNjE4MDZkZjhmM2UzIiwicm9sZSI6IiJ9.tLTSwVvXaY1pn6raX9FA8H72dKvMUMTlk536Yevqz4c
}
