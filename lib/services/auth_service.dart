import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:huertapp/helpers/helpers.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAhy3yJYFfoqPO12n4QqN-fFyfNz7ytmLc';
  // TODO: Mejorar
  static late String userToken;

  final storage = const FlutterSecureStorage();

  Future<String?> signUp(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      print("Token: ${decodedResp['idToken']}");
      checkUser(decodedResp['idToken'], email);
      await storage.write(key: 'userUid', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> signIn(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('idToken')) {
      print("Token: ${decodedResp['idToken']}");
      checkUser(decodedResp['idToken'], email);
      await storage.write(key: 'userUid', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logOut() async {
    storage.delete(key: 'userUid');
    await signOut();
  }

  Future<String> readToken() async {
    return await storage.read(key: 'userUid') ?? '';
  }

  Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            print(e.code);
          } else if (e.code == 'invalid-credential') {
            print(e.code);
          }
        } catch (e) {
          print(e);
        }
      }

      if (user != null) {
        print("Token: ${user.uid}");
        storage.write(key: 'userUid', value: user.uid);
        checkUser(user.uid, user.email ?? '');
      }
    } catch (e) {
      ToastHelper.showToast('No se ha podido iniciar con Google');
      print(e);
    }

    // User(displayName: Diego Bea, email: diegobeagomez1@gmail.com, emailVerified: true,
    // isAnonymous: false, metadata: UserMetadata(creationTime: 2022-08-13 08:36:56.050Z,
    // lastSignInTime: 2022-08-13 08:39:46.183Z), phoneNumber: null,
    // photoURL: https://lh3.googleusercontent.com/a/AItbvmkDr7Cl2ZC3avHwoO-VLf0N39_mJIqp80_m-nUa=s96-c,
    // providerData, [UserInfo(displayName: Diego Bea, email: diegobeagomez1@gmail.com, phoneNumber: null,
    // photoURL: https://lh3.googleusercontent.com/a/AItbvmkDr7Cl2ZC3avHwoO-VLf0N39_mJIqp80_m-nUa=s96-c,
    // providerId: google.com, uid: 104860667456916370509)], refreshToken: , tenantId: null, uid: QeII2HQW7xboszKNjxlYbMepXRd2)

    return user;
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  // TODO: Refactorizar
  void checkUser(String token, String email) async {
    userToken = token;

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'token',
          isEqualTo: token,
        )
        .get();

    if (result.docs.isEmpty) {
      setUser(token, email);
    }
  }

  void setUser(String token, String email) async {
    FirebaseFirestore.instance
        .collection("users")
        .add({"token": token, "email": email, "vegetable_patch": []});
  }
}
