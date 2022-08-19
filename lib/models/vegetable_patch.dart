// To parse this JSON data, do
//
//     final vegetablePatch = vegetablePatchFromMap(jsonString);

import 'dart:convert';

import 'package:huertapp/models/models.dart';

class VegetablePatch {
    VegetablePatch({
        this.crops,
        this.uid,
        required this.name,
    });

    List<String>? crops;
    String? uid;
    String name;

    factory VegetablePatch.fromJson(String str) => VegetablePatch.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory VegetablePatch.fromMap(Map<String, dynamic> json) => VegetablePatch(
        crops: json["crops"] == null ? null : List<String>.from(json["crops"].map((x) => x)),
        uid: json["uid"],
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "crops": crops == null ? null : List<Crop>.from(crops!.map((x) => x)),
        "uid": uid,
        "name": name,
    };
}
