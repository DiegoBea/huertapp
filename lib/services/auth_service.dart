import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:huertapp/helpers/helpers.dart';
import 'package:huertapp/models/models.dart';
import 'package:huertapp/services/services.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAhy3yJYFfoqPO12n4QqN-fFyfNz7ytmLc';

  final storage = const FlutterSecureStorage();

  AuthService() {
    PrintHelper.printInfo('Instanciando authService');
    // readMessagingToken();
  }

  readMessagingToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    PrintHelper.printValue("Token: $token");
  }

  Future<String?> signUp(
      {required String email, required String password, String? name}) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    PrintHelper.printValue(decodedResp.toString());

    if (decodedResp.containsKey('localId')) {
      PrintHelper.printInfo("Token: ${decodedResp['localId']}");
      await checkUser(FirestoreUser(
          email: email, name: name ?? email, uid: decodedResp['localId']));
      await storage.write(key: 'token', value: decodedResp['localId']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> signIn(
      {required String email, required String password, String? name}) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(response.body);

    if (decodedResp.containsKey('localId')) {
      PrintHelper.printInfo("Token: ${decodedResp['localId']}");
      await checkUser(FirestoreUser(
          email: email, name: name ?? email, uid: decodedResp['localId']));
      await storage.write(key: 'token', value: decodedResp['localId']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
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
            ToastHelper.showToast('La cuenta ya existe');
          } else if (e.code == 'invalid-credential') {
            print(e.code);
            ToastHelper.showToast('Datos de inicio de sesión inválidos');
          }
        } catch (e) {
          print(e);
          ToastHelper.showToast('Ha ocurrido un error desconocido');
        }
      }

      if (user != null && user.email != null) {
        PrintHelper.printInfo("Token: ${user.uid}");
        await checkUser(FirestoreUser(
            uid: user.uid,
            email: user.email!,
            name: user.displayName ?? user.email!,
            photoUrl: user.photoURL));
        await storage.write(key: 'token', value: user.uid);
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

  Future logOut() async {
    // Obtener el uid del usuario para eliminar la relación con el dispositivo
    String? uid = await storage.read(key: 'token');
    if (uid != null) {
      UserService userService = UserService();
      userService.getUser(uid).then((value) {
        if (value == null) return;
        if (value.devicesTokens == null) return;

        // Si se ha obtenido un usuario, se elimina y actualiza sus dispositivos
        value.devicesTokens!.removeWhere((element) {
          return element == NotificationService.token;
        });

        userService.updateUser(value);
      });
    }

    storage.delete(key: 'token');
    await signOut();
  }

  Future<String> readToken() async {
    PrintHelper.printInfo('Leyendo token...');
    storage.readAll().then((value) => PrintHelper.printValue(value.toString()));
    return await storage.read(key: 'token') ?? '';
  }

  Future checkUser(FirestoreUser user) async {
    PrintHelper.printInfo('Leyendo datos de ${user.name}');
    UserService userService = UserService();

    await userService.getUser(user.uid).then((value) {
      // Obtener si el usuario ya existe, si no existe se añade a la BBDD
      if (value == null) {
        user.devicesTokens = [NotificationService.token];
        userService.setUser(user);
        return;
      }

      if (value.devicesTokens == null) {
        user.devicesTokens = [NotificationService.token];
        userService.updateUser(value);
        return;
      }

      if (!value.devicesTokens!.contains(NotificationService.token)) {
        value.devicesTokens!.add(NotificationService.token);
        userService.updateUser(value);
        return;
      }
    });

    PrintHelper.printInfo('Token de ${user.name}: ${user.devicesTokens}');
    PrintHelper.printInfo("User_uid: ${user.uid}");
  }
}
