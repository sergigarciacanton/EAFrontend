import 'dart:convert';
import 'package:ea_frontend/models/rate.dart';
import 'package:ea_frontend/models/rating.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class RateService {
  static Future<List<Rate>> getRates() async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/rate/');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/rate/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Rate.ratesFromSnapshot(data);
  }

  static Future<Rate> getBookRate(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/rate/$id/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/rate/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);

    return Rate.fromJson(data);
  }

  static Future<bool> updateTotalRate(String bookId, dynamic totalRate) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/rate/$bookId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/rate/$bookId');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'totalRate': totalRate,
        }));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> rateBook(String bookId, Rating rating) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/rate/rating/$bookId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/rate/rating/$bookId');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'rating': Rating.toJson(rating),
        }));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> unrateBook(String bookId, Rating rating) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/rate/deleteUserRate/$bookId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/rate/deleteUserRate/$bookId');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'rating': Rating.toJson(rating),
        }));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<String> newRate(Rate values) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/rate/');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/rate/');
    }

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(Rate.toJson(values)));
    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
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
