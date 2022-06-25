import 'dart:convert';
import 'package:ea_frontend/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';
import 'dart:io' show Platform;

class BookService {
  static Future<List<Book>> getBooks() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/book/';
    Uri url = Uri.parse(baseUrl);

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/book/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    return Book.booksFromSnapshot(data);
  }

  static Future<Book> getBook(String id) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/book/$id');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/book/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);
    return Book.fromJson(data);
  }

  static Future<String> newBook(
    String title,
    List<dynamic> category,
    String ISBN,
    String photoURL,
    String publishedDate,
    String description,
    String editorial,
    String writer,
  ) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/book/');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/book/');
    }
    String categoryList = "[";
    category.forEach((element) {
      categoryList = categoryList + "," + element.name;
    });
    categoryList = categoryList + "]";

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'title': title,
          'category': categoryList,
          'ISBN': ISBN,
          'photoURL': photoURL,
          'publishedDate': publishedDate,
          'description': description,
          'rate': '0',
          'editorial': editorial,
          'writer': writer,
        }));
    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<String> editBook(
    String id,
    String title,
    List<dynamic> category,
    String ISBN,
    String photoURL,
    String publishedDate,
    String description,
    String editorial,
    String writer,
  ) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/book/$id');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/book/$id');
    }
    String categoryList = "[";
    category.forEach((element) {
      categoryList = categoryList + "," + element.name;
    });
    categoryList = categoryList + "]";

    var response = await http.put(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'title': title,
          'category': categoryList,
          'ISBN': ISBN,
          'photoURL': photoURL,
          'publishedDate': publishedDate,
          'description': description,
          'editorial': editorial,
        }));
    if (response.statusCode == 200) {
      return "200";
    } else {
      return Message.fromJson(await jsonDecode(response.body)).message;
    }
  }

  static Future<bool> deleteBook(String id) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/book/$id');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/book/$id');
    }

    var response = await http.delete(
      url,
      headers: {
        "Authorization": LocalStorage('BookHub').getItem('token'),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateBookRate(String bookId, dynamic rate) async {
    Uri url = Uri.parse(const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/book/$bookId');

    if (!(kIsWeb || Platform.isWindows)) {
      url = Uri.parse('http://10.0.2.2:3000/book/$bookId');
    }

    final response = await http.put(url,
        headers: {
          'authorization': LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode({
          'rate': rate,
        }));
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
