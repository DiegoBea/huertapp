import 'dart:convert';

class FirestoreUser {
  FirestoreUser(
      {this.uid,
      required this.name,
      required this.email,
      this.devicesTokens,
      this.photoUrl,
      this.weatherLocations});

  // TODO: Cambiar register para añadir name
  String? uid;
  String name;
  String email;
  List<String?>? devicesTokens;
  String? photoUrl;
  List<String>? weatherLocations;

  factory FirestoreUser.fromJson(String str) =>
      FirestoreUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FirestoreUser.fromMap(Map<String, dynamic> json) => FirestoreUser(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        devicesTokens: json["devices_tokens"],
        photoUrl: json["photo_url"],
        weatherLocations: json["weather_locations"]
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "devices_tokens": devicesTokens,
        "photo_url": photoUrl,
        "weather_locations": weatherLocations,
      };

  FirestoreUser copy() => FirestoreUser(
      uid: uid,
      name: name,
      email: email,
      devicesTokens: devicesTokens,
      photoUrl: photoUrl,
      weatherLocations: weatherLocations);
}
