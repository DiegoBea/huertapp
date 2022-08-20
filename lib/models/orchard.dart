// To parse this JSON data, do
//
//     final vegetablePatch = vegetablePatchFromMap(jsonString);

import 'dart:convert';

class Orchard {
  Orchard({
    this.uid,
    required this.name,
    required this.lstOwners,
    required this.onwer,
    this.lstGuests,
  });

  String? uid;
  String name;
  List<String> lstOwners;
  bool onwer;
  List<String>? lstGuests;

  factory Orchard.fromJson(String str) => Orchard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Orchard.fromMap(Map<String, dynamic> json) => Orchard(
        uid: json["uid"],
        name: json["name"],
        lstOwners: json["owners"],
        onwer: json["owner"],
        lstGuests: json["guests"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "owners": lstOwners,
        "owner": onwer,
        "guests": lstGuests,
      };
}
