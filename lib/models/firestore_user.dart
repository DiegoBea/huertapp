import 'dart:convert';

class FirestoreUser {
  FirestoreUser(
      {this.uid,
      required this.name,
      required this.email,
      this.devicesTokens,
      this.photoUrl});

  // TODO: Cambiar register para añadir name
  String? uid;
  String name;
  String email;
  List<String?>? devicesTokens;
  String? photoUrl;

  factory FirestoreUser.fromJson(String str) => FirestoreUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FirestoreUser.fromMap(Map<String, dynamic> json) => FirestoreUser(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        devicesTokens: json["devices_tokens"],
        photoUrl: json["photo_url"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "devices_tokens": devicesTokens,
        "photo_url": photoUrl,
      };

  FirestoreUser copy() => FirestoreUser(
      uid: uid,
      name: name,
      email: email,
      devicesTokens: devicesTokens,
      photoUrl: photoUrl);
}
