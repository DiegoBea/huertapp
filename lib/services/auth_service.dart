import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAhy3yJYFfoqPO12n4QqN-fFyfNz7ytmLc';

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
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
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
      await storage.write(key: 'idToken', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logOut() async {
    storage.delete(key: 'idToken');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }
}
