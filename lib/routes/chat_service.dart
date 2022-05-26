import 'dart:convert';
import 'package:ea_frontend/models/chat.dart';
import 'package:ea_frontend/models/newchat.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/chat/';
    Uri url = Uri.parse(baseUrl);

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/chat/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Chat.chatsFromSnapshot(data);
  }

  static Future<String> newChat(NewChatModel values) async {
    Uri url = Uri.parse('http://localhost:3000/chat/');

    if (!kIsWeb) {
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
