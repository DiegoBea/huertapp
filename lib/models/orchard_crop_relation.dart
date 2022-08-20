import 'dart:convert';

class OrchardCropRelation {
  OrchardCropRelation({
    required this.cropUid,
    required this.orchardUid,
    required this.dateSown,
    required this.wateringIntervalDays,
    required this.seedbed,
    this.transplantDays,
    required this.germiantionDays,
    required this.harvestDays,
  });

  String cropUid;
  String orchardUid;
  DateTime dateSown;

  int wateringIntervalDays;

  bool seedbed;

  // TODO: Utilizar días o datetime?
  int? transplantDays;

  int germiantionDays;
  int harvestDays;

  factory OrchardCropRelation.fromJson(String str) =>
      OrchardCropRelation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrchardCropRelation.fromMap(Map<String, dynamic> json) =>
      OrchardCropRelation(
        cropUid: json["crop_uid"],
        orchardUid: json["orchard_uid"],
        dateSown: json["date_sown"],
        wateringIntervalDays: json["watering_interval_days"],
        seedbed: json["seedbed"],
        transplantDays: json["transplant_days"],
        germiantionDays: json["germiantion_days"],
        harvestDays: json["harvest_days"],
      );

  Map<String, dynamic> toMap() => {
        "crop_uid": cropUid,
        "orchard_uid": orchardUid,
        "date_sown": dateSown,
        "watering_interval_days": wateringIntervalDays,
        "seedbed": seedbed,
        "transplant_days": transplantDays,
        "germiantion_days": germiantionDays,
        "harvest_days": harvestDays,
      };
}
