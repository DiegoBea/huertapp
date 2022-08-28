import 'dart:convert';

class OrchardNotification {
  OrchardNotification(
      {required this.uid,
      required this.relationUid,
      this.dateHarvest,
      this.dateGermination,
      this.dateTransplant,
      this.nextWatering});

  String uid;
  String relationUid;
  String? dateHarvest;
  String? dateGermination;
  String? dateTransplant;
  String? nextWatering;

  factory OrchardNotification.fromJson(String str) =>
      OrchardNotification.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrchardNotification.fromMap(Map<String, dynamic> json) =>
      OrchardNotification(
        uid: json["uid"],
        relationUid: json["relation_uid"],
        dateHarvest: json["date_harvest"],
        dateGermination: json["date_germination"],
        dateTransplant: json["date_transplant"],
        nextWatering: json["next_watering"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "relation_uid": relationUid,
        "date_harvest": dateHarvest,
        "date_germination": dateGermination,
        "date_transplant": dateTransplant,
        "next_watering": nextWatering,
      };
}
