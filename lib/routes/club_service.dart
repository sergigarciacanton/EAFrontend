import 'dart:convert';
import 'package:ea_frontend/models/club.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class ClubService {
  static Future<Club> getClub(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/club/$id/';
    Uri url = Uri.parse(baseUrl);

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/club/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    print(data);
    return Club.fromJson(data);
  }

  static Future<List<Club>> getClubs() async {
    Uri url = Uri.parse('http://localhost:3000/club/');

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/club/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Club.clubsFromSnapshot(data);
  }

  static Future<bool> subscribeClub(String idClub) async {
    Uri url = Uri.parse('http://localhost:3000/club/');

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/club/');
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
        "Content-Type": "application/json"
      },
      body: json.encode({
        'idUser': LocalStorage('BookHub').getItem('userId'),
        'idClub': idClub
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> unsubscribeClub(String idClub) async {
    Uri url = Uri.parse('http://localhost:3000/club/unsubscribe');

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/club/unsubscribe');
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
        "Content-Type": "application/json"
      },
      body: json.encode({
        'idUser': LocalStorage('BookHub').getItem('userId'),
        'idClub': idClub
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
