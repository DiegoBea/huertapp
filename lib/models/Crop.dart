// To parse this JSON data, do
//
//     final crop = cropFromJson(jsonString);

import 'dart:convert';

class Crop {
  Crop({
    this.uid,
    required this.name,
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

  String? uid;

  String name;
  String description;

  String iconUrl;
  String imageUrl;

  int germination;

  String? harvest;
  int harvestNotification;

  int maxTemperature;
  int minTemperature;
  int optimalTemperature;

  int? maxWatering;
  int? minWatering;
  int? wateringNotification;
  String watering;

  int? container;
  String? plantingFrame;
  int? depth;
  bool seedbed;
  int? seedsNumber;
  int? transplantNotification;
  String? transplant;

  String? sown;
  String? sownType;

  factory Crop.fromJson(String str) => Crop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Crop.fromMap(Map<String, dynamic> json) => Crop(
        uid: json["uid"],
        name: json["name"],
        description: json["description"],
        iconUrl: json["icon_url"],
        imageUrl: json["image_url"],
        germination: json["germination"],
        harvest: json["harvest"],
        harvestNotification: json["harvest_notification"],
        maxTemperature: json["max_temperature"],
        minTemperature: json["min_temperature"],
        optimalTemperature: json["optimal_temperature"],
        maxWatering: json["max_watering"],
        minWatering: json["min_watering"],
        wateringNotification: json["watering_notification"],
        watering: json["watering"],
        container: json["container"],
        plantingFrame: json["planting_frame"],
        seedbed: json["seedbed"],
        depth: json["depth"],
        seedsNumber: json["seeds_number"],
        transplantNotification: json["transplant_notification"],
        transplant: json["transplant"],
        sown: json["sown"],
        sownType: json["sown_type"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
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
