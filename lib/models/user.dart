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
  List<Book> books;
  List<Event> events;
  List<Club> clubs;
  List<Chat> chats;
  List<myCategory.Category> categories;
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
    log(json.toString());
    print(json);

    var name = json['name'] as String;
    var userName = json['userName'] as String;
    var birthDate = DateTime.parse(json['birthDate']);
    var mail = json['mail'] as String;
    var location =
        json['location'] == null ? null : Location.fromJson(json['location']);
    var books = Book.booksFromSnapshot(json['books']);
    var events = Event.eventsFromSnapshot(json['events']);
    log("AQUI");
    var clubs = Club.clubsFromSnapshot(json['clubs']);
    var chats = Chat.chatsFromSnapshot(json['chats']);
    var categories =
        myCategory.Category.categoriesFromSnapshot(json['categories']);
    var photoURL = json['photoURL'] as String;
    var roles = json['roles'] as List<String>;

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

    log("lets pring");
    return u;
  }

  static List<User> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return User.fromJson(data);
    }).toList();
  }
}
