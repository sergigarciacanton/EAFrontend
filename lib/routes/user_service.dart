import 'dart:convert';
import 'package:ea_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class UserService {
  static Future<User> getUser(String id) async {
    Uri url = Uri.parse('http://localhost:3000/user/$id');

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
}
