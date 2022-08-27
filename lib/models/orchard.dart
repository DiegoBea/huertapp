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
    this.guests,
    this.imageUrl,
  });

  String? uid;
  String name;
  String? description;
  List<String> owners;
  List<String>? guests;
  String? imageUrl;

  bool owner = true;

  factory Orchard.fromJson(String str) => Orchard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Orchard.fromMap(Map<String, dynamic> json) => Orchard(
        uid: json["uid"],
        name: json["name"],
        description: json["description"],
        owners: json["owners"],
        guests: json["guests"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "description": description,
        "owners": owners,
        "guests": guests,
        "image_url": imageUrl,
      };

  Orchard copy() => Orchard(
      owners: owners,
      name: name,
      description: description,
      guests: guests,
      imageUrl: imageUrl,
      uid: uid);
}
