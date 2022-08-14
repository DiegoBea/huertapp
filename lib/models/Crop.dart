// To parse this JSON data, do
//
//     final crop = cropFromMap(jsonString);

import 'dart:convert';

class Crop {
  Crop({
    this.harvest,
    this.iconUrl,
    this.imageUrl,
    required this.name,
    required this.temperature,
    this.germination,
    this.sown,
    this.seedbed,
    required this.watered,
  });

  String? id;
  int? harvest;
  String? iconUrl;
  String? imageUrl;
  String name;
  Temperature temperature;
  Germination? germination;
  String? sown;
  Seedbed? seedbed;
  Watered watered;

  factory Crop.fromJson(String str) => Crop.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Crop.fromMap(Map<String, dynamic> json) => Crop(
        harvest: json["harvest"],
        iconUrl: json["icon_url"],
        imageUrl: json["image_url"],
        name: json["name"],
        temperature: Temperature.fromMap(json["temperature"]),
        germination: json["germination"] == null
            ? null
            : Germination.fromMap(json["germination"]),
        sown: json["sown"],
        seedbed:
            json["seedbed"] == null ? null : Seedbed.fromMap(json["seedbed"]),
        watered: Watered.fromMap(json["watered"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "harvest": harvest,
        "icon_url": iconUrl,
        "image_url": imageUrl,
        "name": name,
        "temperature": temperature.toMap(),
        "germination": germination == null ? null : germination!.toMap(),
        "sown": sown,
        "seedbed": seedbed == null ? null : seedbed!.toMap(),
        "watered": watered.toMap(),
      };
}

class Germination {
  Germination({
    this.max,
    this.min,
  });

  int? max;
  int? min;

  factory Germination.fromJson(String str) =>
      Germination.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Germination.fromMap(Map<String, dynamic> json) => Germination(
        max: json["max"],
        min: json["min"],
      );

  Map<String, dynamic> toMap() => {
        "max": max,
        "min": min,
      };
}

class Seedbed {
  Seedbed({
    this.depth,
    required this.seedsNumber,
    this.transplant,
  });

  int? depth;
  int seedsNumber;
  int? transplant;

  factory Seedbed.fromJson(String str) => Seedbed.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Seedbed.fromMap(Map<String, dynamic> json) => Seedbed(
        depth: json["depth"],
        seedsNumber: json["seeds_number"],
        transplant: json["transplant"],
      );

  Map<String, dynamic> toMap() => {
        "depth": depth,
        "seeds_number": seedsNumber,
        "transplant": transplant,
      };
}

class Temperature {
  Temperature({
    required this.max,
    required this.min,
    required this.optimal,
  });

  int max;
  int min;
  int optimal;

  factory Temperature.fromJson(String str) =>
      Temperature.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Temperature.fromMap(Map<String, dynamic> json) => Temperature(
        max: json["max"],
        min: json["min"],
        optimal: json["optimal"],
      );

  Map<String, dynamic> toMap() => {
        "max": max,
        "min": min,
        "optimal": optimal,
      };
}

class Watered {
  Watered({
    this.average,
    this.max,
    this.min,
  });

  int? average;
  int? max;
  int? min;

  factory Watered.fromJson(String str) => Watered.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Watered.fromMap(Map<String, dynamic> json) => Watered(
        average: json["average"],
        max: json["max"],
        min: json["min"],
      );

  Map<String, dynamic> toMap() => {
        "average": average,
        "max": max,
        "min": min,
      };
}
