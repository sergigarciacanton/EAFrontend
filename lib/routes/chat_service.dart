import 'dart:convert';
import 'package:ea_frontend/models/chat.dart';
import 'package:ea_frontend/models/newchat.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class ChatService {
  static Future<List<Chat>> getChats() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/chat/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Chat.chatsFromSnapshot(data);
  }

  static Future<Chat> getChat(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/';

    if (!(kIsWeb || Platform.isWindows)) {
      baseUrl = 'http://10.0.2.2:3000/chat/';
    }
    Uri url = Uri.parse(baseUrl + id + '/');

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Chat.fromJson(data);
  }

  static Future<String> newChat(NewChatModel values) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/chat/');
    }

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(NewChatModel.toJson(values)));
    if (response.statusCode == 201) {
      return "201";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<String> leaveChat(String chatId, String userId) async {
    String url = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/';

    if (!(kIsWeb || Platform.isWindows)) {
      url = 'http://10.0.2.2:3000/chat/';
    }

    var response =
        await http.delete(Uri.parse("${url}leave/$chatId/$userId"), headers: {
      "Authorization": LocalStorage('BookHub').getItem('token'),
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<String> joinChat(String chatId, String userId) async {
    String url = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/';

    if (!(kIsWeb || Platform.isWindows)) {
      url = 'http://10.0.2.2:3000/chat/';
    }

    var response =
        await http.post(Uri.parse("${url}join/$chatId/$userId"), headers: {
      "Authorization": LocalStorage('BookHub').getItem('token'),
      "Content-Type": "application/json"
    });

    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<Chat> getByName(String name) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/name/';

    if (!(kIsWeb || Platform.isWindows)) {
      baseUrl = 'http://10.0.2.2:3000/chat/name/';
    }
    Uri url = Uri.parse(baseUrl + name + '/');

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Chat.fromJson(data);
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
