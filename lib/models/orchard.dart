// To parse this JSON data, do
//
//     final vegetablePatch = vegetablePatchFromMap(jsonString);

import 'dart:convert';

class Orchard {
  Orchard({
    this.uid,
    required this.name,
    this.description,
    required this.owners,
    required this.onwer,
    this.guests,
    this.imageUrl,
  });

  String? uid;
  String name;
  String? description;
  List<String> owners;
  bool onwer;
  List<String>? guests;
  String? imageUrl;

  factory Orchard.fromJson(String str) => Orchard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Orchard.fromMap(Map<String, dynamic> json) => Orchard(
        uid: json["uid"],
        name: json["name"],
        description: json["description"],
        owners: json["owners"],
        onwer: json["owner"],
        guests: json["guests"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "description": description,
        "owners": owners,
        "owner": onwer,
        "guests": guests,
        "image_url": imageUrl,
      };

  Orchard copy() => Orchard(
      owners: owners,
      name: name,
      onwer: onwer,
      description: description,
      guests: guests,
      imageUrl: imageUrl,
      uid: uid);
}
