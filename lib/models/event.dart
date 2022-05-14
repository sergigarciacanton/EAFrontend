import 'location.dart';
import 'user.dart';
import 'category.dart';
import 'chat.dart';

class Event {
  String name;
  String description;
  Location location;
  dynamic admin;
  dynamic chat;
  DateTime eventDate;
  List<dynamic> usersList;
  List<dynamic> category;

  Event(
      {required this.name,
      required this.description,
      required this.location,
      required this.admin,
      required this.chat,
      required this.eventDate,
      required this.usersList,
      required this.category});

  factory Event.fromJson(dynamic json) {
    return Event(
        name: json['name'] as String,
        description: json['description'] as String,
        location: Location.fromJson(json['location']),
        admin: json['user'].toString().contains('{')
            ? User.fromJson(json['user'])
            : json['user'],
        chat: json['chat'].toString().contains('{')
            ? Chat.fromJson(json['chat'])
            : json['chat'],
        eventDate: DateTime.parse(['eventDate'] as String),
        usersList: json['users'].toString().contains('{')
            ? User.usersFromSnapshot(json['users'])
            : json['users'],
        category: json['category'].toString().contains('{')
            ? Category.categoriesFromSnapshot(json['category'])
            : json['category']);
  }

  static List<Event> eventsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Event.fromJson(data);
    }).toList();
  }
}
