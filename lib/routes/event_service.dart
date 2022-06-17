import 'dart:convert';
import 'package:ea_frontend/models/event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

import '../models/newevent.dart';

class EventService {
  static Future<List<Event>> getEvents() async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Event.eventsFromSnapshot(data);
  }

  static Future<Event> getEvent(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/$id/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Event.fromJson(data);
  }

  static Future<bool> joinEvent(String eventId) async {
    String userId = LocalStorage('BookHub').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/join/$userId/$eventId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/join/$userId/$eventId');
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> leaveEvent(String eventId) async {
    String userId = LocalStorage('BookHub').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/leave/$userId/$eventId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/leave/$userId/$eventId');
    }

    final response = await http.put(
      url,
      headers: {
        'authorization': LocalStorage('BookHub').getItem('token'),
      },
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<String> newEvent(NewEventModel values) async {
    String userId = LocalStorage('BookHub').getItem('userId');
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/event/$userId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/event/$userId');
    }

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(NewEventModel.toJson(values)));
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
