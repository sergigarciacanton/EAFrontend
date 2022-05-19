import 'book.dart';
import 'chat.dart';
import 'location.dart';
import 'club.dart';
import 'category.dart' as myCategory;
import 'event.dart';
import 'dart:developer';

class User {
  String name;
  String userName;
  DateTime birthDate;
  String mail;
  Location? location;
  List<dynamic> books;
  List<dynamic> events;
  List<dynamic> clubs;
  List<dynamic> chats;
  List<dynamic> categories;
  String photoURL;
  List<String> roles;

  User(
      {required this.name,
      required this.userName,
      required this.birthDate,
      required this.mail,
      required this.location,
      required this.books,
      required this.events,
      required this.clubs,
      required this.chats,
      required this.categories,
      required this.photoURL,
      required this.roles});

  factory User.fromJson(dynamic json) {
    var name = json['name'] as String;
    var userName = json['userName'] as String;
    var birthDate = DateTime.parse((json['birthDate'] as String).replaceAll("T", " "));
    var mail = json['mail'] as String;
    var location =
        json['location'] == null ? null : Location.fromJson(json['location']);
    var books = json['books'].toString().contains('{')
        ? Book.booksFromSnapshot(json['books'])
        : json['books'];
    var events = json['events'].toString().contains('{')
        ? Event.eventsFromSnapshot(json['events'])
        : json['events'];

    var clubs = json['clubs'].toString().contains('{')
        ? Club.clubsFromSnapshot(json['clubs'])
        : json['clubs'];
    var chats = json['chats'].toString().contains('{')
        ? Chat.chatsFromSnapshot(json['chats'])
        : json['chats'];
    var categories =
        myCategory.Category.categoriesFromSnapshot(json['categories']);
    var photoURL = json['photoURL'] as String;
    var roles = json['role'].cast<String>() as List<String>;

    var u = User(
        name: name,
        userName: userName,
        birthDate: birthDate,
        mail: mail,
        location: location,
        books: books,
        events: events,
        clubs: clubs,
        chats: chats,
        categories: categories,
        photoURL: photoURL,
        roles: roles);
    return u;
  }

  static List<User> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return User.fromJson(data);
    }).toList();
  }
}
