import 'dart:convert';
import 'package:ea_frontend/models/login.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final LocalStorage storage = LocalStorage('BookHub');
  static var baseUrl =
      'http://localhost:3000/auth/'; //10.0.2.2 (emulador Android)

  static Future<String> verifyToken(String token) async {
    baseUrl = checkPlatform();
    var res = await http.post(Uri.parse(baseUrl + 'verifyToken'),
        headers: {'content-type': 'application/json'},
        body: json.encode({'token': token}));
    if (res.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(res.body)).message;
    }
  }

  Future<String> login(LoginModel credentials) async {
    baseUrl = checkPlatform();
    var res = await http.post(Uri.parse(baseUrl + 'singin'),
        headers: {'content-type': 'application/json'},
        body: json.encode(LoginModel.toJson(credentials)));
    if (res.statusCode == 200) {
      var token = Token.fromJson(await jsonDecode(res.body));
      storage.setItem('token', token.toString());
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(res.body)).message;
    }
  }

  static String checkPlatform() {
    if (kIsWeb) {
      return 'http://localhost:3000/auth/';
    } else {
      return 'http://10.0.2.2:3000/auth/';
    }
  }
}

class Token {
  final String token;

  const Token({
    required this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'] as String,
    );
  }

  @override
  String toString() {
    return token;
  }
}

class Message {
  final String message;

  const Message({
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'] as String,
    );
  }

  @override
  String toString() {
    return message;
  }
}
