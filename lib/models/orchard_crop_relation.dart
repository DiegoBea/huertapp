import 'dart:convert';

class OrchardCropRelation {
  OrchardCropRelation({
    this.uid,
    required this.cropUid,
    this.orchardUid,
    required this.sownDate,
    required this.wateringNotification,
    required this.wateringIntervalDays,
    this.transplantDays,
    required this.transplantNotification,
    required this.germinationDays,
    required this.germinationNotification,
    required this.harvestDays,
    required this.harvestNotification,
  });

  String? uid;
  String cropUid;
  String? orchardUid;
  DateTime sownDate;

  bool wateringNotification;
  int? wateringIntervalDays;

  // TODO: Utilizar int o datetime?
  int? transplantDays;
  bool transplantNotification;

  int germinationDays;
  bool germinationNotification;
  int harvestDays;
  bool harvestNotification;

  factory OrchardCropRelation.fromJson(String str) =>
      OrchardCropRelation.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrchardCropRelation.fromMap(Map<String, dynamic> json) =>
      OrchardCropRelation(
          uid: json["uid"],
          cropUid: json["crop_uid"],
          orchardUid: json["orchard_uid"],
          sownDate: DateTime.parse(json["sown_date"]),
          wateringNotification: json["watering_notification"],
          wateringIntervalDays: json["watering_interval_days"],
          transplantDays: json["transplant_days"],
          transplantNotification: json["transplant_notification"],
          germinationDays: json["germination_days"],
          germinationNotification: json["germination_notification"],
          harvestDays: json["harvest_days"],
          harvestNotification: json["harvest_notification"]);

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "crop_uid": cropUid,
        "orchard_uid": orchardUid,
        "sown_date": sownDate.toString(),
        "watering_notification": wateringNotification,
        "watering_interval_days": wateringIntervalDays,
        "transplant_days": transplantDays,
        "transplant_notification": transplantNotification,
        "germination_days": germinationDays,
        "germination_notification": germinationNotification,
        "harvest_days": harvestDays,
        "harvest_notification": harvestNotification,
      };

  OrchardCropRelation copy() => OrchardCropRelation(
        uid: uid,
        cropUid: cropUid,
        orchardUid: orchardUid,
        sownDate: sownDate,
        wateringNotification: wateringNotification,
        wateringIntervalDays: wateringIntervalDays,
        transplantDays: transplantDays,
        transplantNotification: transplantNotification,
        germinationDays: germinationDays,
        germinationNotification: germinationNotification,
        harvestDays: harvestDays,
        harvestNotification: harvestNotification,
      );
}
