import 'dart:convert';
import 'package:ea_frontend/models/chat.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class ChatService {
  static Future<List<Chat>> getChats() async {
    Uri url = Uri.parse('http://localhost:3000/chat/');

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
}
