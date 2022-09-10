// To parse this JSON data, do
//
//     final provincia = provinciaFromMap(jsonString);

import 'dart:convert';

import 'package:huertapp/models/models.dart';

class Province {
  Province({
    required this.provCod,
    required this.provinceName,
    required this.autonCod,
    required this.communityAutonomousCity,
    required this.capitalProvince,
  });

  String provCod;
  String provinceName;
  String autonCod;
  String communityAutonomousCity;
  String capitalProvince;

  factory Province.fromJson(String str) => Province.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Province.fromMap(Map<String, dynamic> json) => Province(
        provCod: json["CODPROV"],
        provinceName: json["NOMBRE_PROVINCIA"],
        autonCod: json["CODAUTON"],
        communityAutonomousCity: json["COMUNIDAD_CIUDAD_AUTONOMA"],
        capitalProvince: json["CAPITAL_PROVINCIA"],
      );

  Map<String, dynamic> toMap() => {
        "CODPROV": provCod,
        "NOMBRE_PROVINCIA": provinceName,
        "CODAUTON": autonCod,
        "COMUNIDAD_CIUDAD_AUTONOMA": communityAutonomousCity,
        "CAPITAL_PROVINCIA": capitalProvince,
      };
}
