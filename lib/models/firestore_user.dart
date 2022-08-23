import 'dart:convert';

class FirestoreUser {
  FirestoreUser(
      {this.uid,
      required this.name,
      required this.email,
      this.photoURL});

  // TODO: Cambiar register para añadir name
  String? uid;
  String name;
  String email;
  String? photoURL;

  factory FirestoreUser.fromJson(String str) => FirestoreUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FirestoreUser.fromMap(Map<String, dynamic> json) => FirestoreUser(
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
        photoURL: json["photoUrl"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "photoURL": photoURL,
      };

  FirestoreUser copy() => FirestoreUser(
      uid: uid,
      name: name,
      email: email,
      photoURL: photoURL);
}
