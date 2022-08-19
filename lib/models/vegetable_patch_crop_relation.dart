import 'dart:convert';

import 'package:huertapp/models/models.dart';

class VegetablePatchCropRelation {
  VegetablePatchCropRelation({
    required this.cropUid,
    required this.vegetablePatchUid,
    required this.dateSown,
    required this.wateringIntervalDays,
    required this.seedbed,
    this.transplantDays,
    required this.germiantionDays,
    required this.harvestDays,
  });

  String cropUid;
  String vegetablePatchUid;
  DateTime dateSown;

  int wateringIntervalDays;

  bool seedbed;

  // TODO: Utilizar días o datetime?
  int? transplantDays;

  int germiantionDays;
  int harvestDays;

  factory VegetablePatchCropRelation.fromJson(String str) =>
      VegetablePatchCropRelation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory VegetablePatchCropRelation.fromMap(Map<String, dynamic> json) =>
      VegetablePatchCropRelation(
        cropUid: json["crop_uid"],
        vegetablePatchUid: json["vegetable_patch_uid"],
        dateSown: json["date_sown"],
        wateringIntervalDays: json["watering_interval_days"],
        seedbed: json["seedbed"],
        transplantDays: json["transplant_days"],
        germiantionDays: json["germiantion_days"],
        harvestDays: json["harvest_days"],
      );

  Map<String, dynamic> toMap() => {
        "crop_uid": cropUid,
        "vegetable_patch_uid": vegetablePatchUid,
        "date_sown": dateSown,
        "watering_interval_days": wateringIntervalDays,
        "seedbed": seedbed,
        "transplant_days": transplantDays,
        "germiantion_days": germiantionDays,
        "harvest_days": harvestDays,
      };
}
