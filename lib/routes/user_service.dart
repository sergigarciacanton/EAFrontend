import 'dart:convert';
import 'package:ea_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class UserService {
  static Future<User> getUser(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/user/$id';
    Uri url = Uri.parse(baseUrl);
    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/user/$id');
    }
    print(url);

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    print(data);
    return User.fromJson(data);
  }

  static Future<List<User>> getUsers() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/';
    Uri url = Uri.parse(baseUrl);

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/user/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    print(data);
    return User.usersFromSnapshot(data);
  }
}
