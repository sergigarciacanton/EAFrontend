import 'package:ea_frontend/models/location.dart';

class EditEventModel {
  String eventName;
  String description;
  DateTime eventDate;
  String category;
  Location location;
  String photoURL;

  EditEventModel(
      {required this.eventName,
      required this.description,
      required this.eventDate,
      required this.category,
      required this.location,
      required this.photoURL});

  factory EditEventModel.fromJson(Map<String, dynamic> json) {
    return EditEventModel(
        eventName: json['eventname'],
        description: json['description'],
        photoURL: json['photoURL'],
        eventDate:
            DateTime.parse((json['eventDate'] as String).replaceAll("T", " ")),
        category: json['category'],
        location: Location.fromJson(json['location']));
  }

  static Map<String, dynamic> toJson(EditEventModel credentials) {
    return {
      'eventName': credentials.eventName,
      'description': credentials.description,
      'eventDate': credentials.eventDate.toString(),
      'category': credentials.category,
      'location': Location.toJson(credentials.location),
      'photoURL': credentials.photoURL
    };
  }
}
