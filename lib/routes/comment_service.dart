import 'dart:convert';
import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class CommentService {
  static Future<Comment> getComment(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/comment/$id';
    Uri url = Uri.parse(baseUrl);
    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/comment/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);

    return Comment.fromJson(data);
  }

  static Future<List<Comment>?> getCommentByType(String type) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/comment/type/$type';
    Uri url = Uri.parse(baseUrl);
    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/comment/type/$type');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );

    if (response.statusCode == 404) {
      return null;
    }

    List data = jsonDecode(response.body);

    return Comment.commentsFromSnapshot(data);
  }

  static Future<List<Comment>> getComments() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/comment/';
    Uri url = Uri.parse(baseUrl);

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/comment/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);

    return Comment.commentsFromSnapshot(data);
  }

  static Future<String> addComment(NewCommentModel values) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/comment/';
    Uri url = Uri.parse(baseUrl);

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/comment/');
    }

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(NewCommentModel.toJson(values)));
    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<bool> updateComment(String id, Comment values) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/comment/$id';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb)) {
      url = Uri.parse('http://10.0.2.2:3000/comment/$id');
    }

    final response = await http.put(url,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(Comment.toJson(values)));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
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
