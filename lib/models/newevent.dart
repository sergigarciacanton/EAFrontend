import 'package:ea_frontend/models/location.dart';
import 'package:ea_frontend/models/userPopulate.dart';

import 'category.dart';
import 'location.dart';

class NewEventModel {
  String name;
  String description;
  dynamic admin;
  DateTime eventDate;
  String categories;
  Location location;

  NewEventModel(
      {required this.name,
      required this.description,
      required this.admin,
      required this.eventDate,
      required this.categories,
      required this.location});

  factory NewEventModel.fromJson(dynamic json) {
    return NewEventModel(
        name: json['name'] as String,
        description: json['description'] as String,
        location: json['location'] as Location,
        admin: json['admin'].toString().contains('{')
            ? UserPopulate.fromJson(json['admin'])
            : json['admin'],
        eventDate:
            DateTime.parse((json['eventDate'] as String).replaceAll("T", " ")),
        categories: json['categories'].toString().contains('{')
            ? Category.categoriesFromSnapshot(json['categories'])
            : json['categories']);
  }

  static Map<String, dynamic> toJson(NewEventModel values) {
    return {
      'name': values.name,
      'description': values.description,
      'admin': values.admin,
      'eventDate': values.eventDate.toString(),
      'category': values.categories,
      'location': Location.toJson(values.location)
    };
  }

  static List<NewEventModel> eventsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return NewEventModel.fromJson(data);
    }).toList();
  }
}
