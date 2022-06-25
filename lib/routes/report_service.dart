import 'dart:convert';
import 'package:ea_frontend/models/report.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:localstorage/localstorage.dart';

class ReportService {
  static Future<Report> getReport(String id) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/report/$id';
    Uri url = Uri.parse(baseUrl);
    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/report/$id');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    Object data = jsonDecode(response.body);

    return Report.fromJson(data);
  }

  static Future<List<Report>> getReportByUser(String user) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/report/user/$user';
    Uri url = Uri.parse(baseUrl);
    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/report/user/$user');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    print(data);
    return Report.reportsFromSnapshot(data);
  }

  static Future<List<Report>> getReportByType(String type) async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/report/type/$type';
    Uri url = Uri.parse(baseUrl);
    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/report/type/$type');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    print(data);
    return Report.reportsFromSnapshot(data);
  }

  static Future<List<Report>> getReports() async {
    String baseUrl = const String.fromEnvironment('API_URL',
            defaultValue: 'http://localhost:3000') +
        '/report/';
    Uri url = Uri.parse(baseUrl);

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/report/');
    }

    final response = await http.get(
      url,
      headers: {'authorization': LocalStorage('BookHub').getItem('token')},
    );
    List data = jsonDecode(response.body);
    print(data);
    return Report.reportsFromSnapshot(data);
  }

  static Future<String> addReport(Report values) async {
    Uri url = Uri.parse('http://localhost:3000/report/');

    if (!kIsWeb) {
      url = Uri.parse('http://10.0.2.2:3000/report/');
    }

    var response = await http.post(url,
        headers: {
          "Authorization": LocalStorage('BookHub').getItem('token'),
          "Content-Type": "application/json"
        },
        body: json.encode(Report.toJson(values)));
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
