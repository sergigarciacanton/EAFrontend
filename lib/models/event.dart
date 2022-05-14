import 'location.dart';
import 'user.dart';
import 'category.dart';
import 'chat.dart';

class Event {
  String name;
  String description;
  Location location;
  User admin;
  Chat chat;
  DateTime eventDate;
  List<User> usersList;
  List<Category> category;

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
        admin: User.fromJson(json['user']),
        chat: Chat.fromJson(json['chat']),
        eventDate: DateTime.parse(['eventDate'] as String),
        usersList: User.usersFromSnapshot(json['usersList']),
        category: Category.categoriesFromSnapshot(json['category']));
  }

  static List<Event> eventsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Event.fromJson(data);
    }).toList();
  }
}
