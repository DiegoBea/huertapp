// To parse this JSON data, do
//
//     final crop = cropFromJson(jsonString);

import 'dart:convert';

class Crop {
  Crop({
    required this.uid,
    required this.name,
    required this.notificationName,
    required this.description,
    required this.iconUrl,
    required this.imageUrl,
    required this.germination,
    this.harvest,
    required this.harvestNotification,
    required this.maxTemperature,
    required this.minTemperature,
    required this.optimalTemperature,
    this.maxWatering,
    this.minWatering,
    this.wateringNotification,
    required this.watering,
    this.container,
    this.plantingFrame,
    required this.seedbed,
    this.depth,
    this.seedsNumber,
    this.transplantNotification,
    this.transplant,
    this.sown,
    this.sownType,
  });

  late String uid;

  Map<String, String> name;
  String notificationName;
  Map<String, String> description;

  String iconUrl;
  String imageUrl;

  int germination;

  Map<String, String>? harvest;
  int harvestNotification;

  int maxTemperature;
  int minTemperature;
  int optimalTemperature;

  int? maxWatering;
  int? minWatering;
  int? wateringNotification;
  Map<String, String> watering;

  int? container;
  Map<String, String>? plantingFrame;
  int? depth;
  bool seedbed;
  int? seedsNumber;
  int? transplantNotification;
  Map<String, String>? transplant;

  Map<String, String>? sown;
  Map<String, String>? sownType;

  factory Crop.fromJson(String str) => Crop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Crop.fromMap(Map<String, dynamic> json) => Crop(
        uid: json["uid"] ?? '',
        notificationName: json["notification_name"],
        name: Map<String, String>.from(json["name"]),
        description: Map<String, String>.from(json["description"]),
        iconUrl: json["icon_url"],
        imageUrl: json["image_url"],
        germination: json["germination"],
        harvest: json["harvest"] != null ? Map<String, String>.from(json["harvest"]) : null,
        harvestNotification: json["harvest_notification"],
        maxTemperature: json["max_temperature"],
        minTemperature: json["min_temperature"],
        optimalTemperature: json["optimal_temperature"],
        maxWatering: json["max_watering"],
        minWatering: json["min_watering"],
        wateringNotification: json["watering_notification"],
        watering: Map<String, String>.from(json["watering"]),
        container: json["container"],
        plantingFrame: Map<String, String>.from(json["planting_frame"]),
        seedbed: json["seedbed"],
        depth: json["depth"],
        seedsNumber: json["seeds_number"],
        transplantNotification: json["transplant_notification"],
        transplant: json["transplant"] != null ? Map<String, String>.from(json["transplant"]) : null,
        sown: json["sown"] != null ? Map<String, String>.from((json["sown"])) : null,
        sownType: Map<String, String>.from(json["sown_type"]),
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "notification_name": notificationName,
        "description": description,
        "icon_url": iconUrl,
        "image_url": imageUrl,
        "germination": germination,
        "harvest": harvest,
        "harvest_notification": harvestNotification,
        "max_temperature": maxTemperature,
        "min_temperature": minTemperature,
        "optimal_temperature": optimalTemperature,
        "max_watering": maxWatering,
        "min_watering": minWatering,
        "watering_notification": wateringNotification,
        "watering": watering,
        "container": container,
        "planting_frame": plantingFrame,
        "seedbed": seedbed,
        "depth": depth,
        "seeds_number": seedsNumber,
        "transplant_notification": transplantNotification,
        "transplant": transplant,
        "sown": sown,
        "sown_type": sownType,
      };
}
