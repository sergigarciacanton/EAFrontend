import 'dart:convert';
import 'package:ea_frontend/models/author.dart';
import 'package:ea_frontend/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class VideoService {
  static Future<String> getToken(String channelName) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/video/$channelName';
    Uri url = Uri.parse(baseUrl);
    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/video/$channelName');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    print("data");
    print(data);
    if (response.statusCode == 200) {
      return data as String;
    } else {
      return 'Failed to fetch the token';
    }
  }
}
