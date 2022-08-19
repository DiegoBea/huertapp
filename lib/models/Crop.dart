// To parse this JSON data, do
//
//     final crop = cropFromJson(jsonString);

import 'dart:convert';

class Crop {
  Crop({
    this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.imageUrl,
    required this.germination,
    required this.harvest,
    required this.maxTemperature,
    required this.minTemperature,
    required this.optimalTemperature,
    this.maxWatering,
    this.minWatering,
    required this.notificationWatering,
    required this.seedbed,
    this.seedbedDepth,
    this.seedbedSeedsNumber,
    this.seedbedTransplant,
    this.sown,
    this.sownType,
  });

  String? id;

  String name;
  String description;

  String iconUrl;
  String imageUrl;

  int germination;
  int harvest;

  int maxTemperature;
  int minTemperature;
  int optimalTemperature;

  int? maxWatering;
  int? minWatering;
  int notificationWatering;

  bool seedbed;
  int? seedbedDepth;
  int? seedbedSeedsNumber;
  int? seedbedTransplant;

  String? sown;
  String? sownType;

  factory Crop.fromJson(String str) => Crop.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Crop.fromMap(Map<String, dynamic> json) => Crop(
        id: json["id"],

        name: json["name"],
        description: json["description"],

        iconUrl: json["icon_url"],
        imageUrl: json["image_url"],

        germination: json["germination"],

        harvest: json["harvest"],

        maxTemperature: json["max_temperature"],
        minTemperature: json["min_temperature"],
        optimalTemperature: json["optimal_temperature"],

        maxWatering: json["max_watering"],
        minWatering: json["min_watering"],
        notificationWatering: json["notification_watering"],

        seedbed: json["seedbed"],
        seedbedDepth: json["seedbed_depth"],
        seedbedSeedsNumber: json["seedbed_seeds_number"],
        seedbedTransplant: json["seedbed_transplant"],

        sown: json["sown"],
        sownType: json["sown_type"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,

        "name": name,
        "description": description,

        "iconUrl": iconUrl,
        "imageUrl": imageUrl,

        "germination": germination,
        
        "harvest": harvest,

        "maxTemperature": maxTemperature,
        "minTemperature": minTemperature,
        "optimalTemperature": optimalTemperature,

        "maxWatering": maxWatering,
        "minWatering": minWatering,
        "notificationWatering": notificationWatering,

        "seedbed": seedbed,
        "seedbedDepth": seedbedDepth,
        "seedbedSeedsNumber": seedbedSeedsNumber,
        "seedbedTransplant": seedbedTransplant,

        "sown": sown,
        "sownType": sownType,
    };
}
