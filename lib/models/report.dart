import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/models/userPopulate.dart';

class Report {
  dynamic user;
  String title;
  String text;

  Report({
    required this.user,
    required this.title,
    required this.text,
  });

  factory Report.fromJson(dynamic json) {
    return Report(
        user: json['user'].toString().contains('{')
            ? UserPopulate.fromJson(json['user'])
            : json['user'],
        title: json['title'] as String,
        text: json['text'] as String);
  }

  static Map<String, dynamic> toJson(Report values) {
    return {
      'user': values.user,
      'title': values.title,
      'text': values.text,
    };
  }

  static List<Report> reportsFromSnapshot(List snapshot) {
    var a = snapshot.map((data) {
      return Report.fromJson(data);
    }).toList();

    return a;
  }
}
