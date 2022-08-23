import 'dart:convert';

class OrchardCropRelation {
  OrchardCropRelation({
    required this.cropUid,
    required this.orchardUid,
    required this.dateSown,
    required this.wateringIntervalDays,
    required this.seedbed,
    this.transplantDays,
    required this.transplantNotification,
    required this.germinationDays,
    required this.germiantionNotification,
    required this.harvestDays,
    required this.harvestNotification,
  });

  String cropUid;
  String orchardUid;
  DateTime dateSown;

  int wateringIntervalDays;

  bool seedbed;

  // TODO: Utilizar días o datetime?
  int? transplantDays;
  bool transplantNotification;

  int germinationDays;
  bool germiantionNotification;
  int harvestDays;
  bool harvestNotification;

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
          transplantNotification: json["transplant_notification"],
          germinationDays: json["germination_days"],
          germiantionNotification: json["germination_notification"],
          harvestDays: json["harvest_days"],
          harvestNotification: json["harvest_notification"]);

  Map<String, dynamic> toMap() => {
        "crop_uid": cropUid,
        "orchard_uid": orchardUid,
        "date_sown": dateSown,
        "watering_interval_days": wateringIntervalDays,
        "seedbed": seedbed,
        "transplant_days": transplantDays,
        "transplantNotification": transplantNotification,
        "germination_days": germinationDays,
        "germiantionNotification": germiantionNotification,
        "harvest_days": harvestDays,
        "harvestNotification": harvestNotification,
      };

  OrchardCropRelation copy() => OrchardCropRelation(
        cropUid: cropUid,
        orchardUid: orchardUid,
        dateSown: dateSown,
        wateringIntervalDays: wateringIntervalDays,
        seedbed: seedbed,
        transplantDays: transplantDays,
        transplantNotification: transplantNotification,
        germinationDays: germinationDays,
        germiantionNotification: germiantionNotification,
        harvestDays: harvestDays,
        harvestNotification: harvestNotification,
      );
}
