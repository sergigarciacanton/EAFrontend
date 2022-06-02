import 'package:ea_frontend/models/userPopulate.dart';

import 'book.dart';
import 'user.dart';
import 'category.dart' as myCategory;
import 'dart:developer';

class Author {
  String id;
  String name;
  DateTime birthDate;
  DateTime deathDate;
  String biography;
  List<dynamic> books;
  List<dynamic> categories;
  String photoURL;
  UserPopulate user;

  Author(
      {required this.id,
      required this.name,
      required this.birthDate,
      required this.deathDate,
      required this.biography,
      required this.books,
      required this.categories,
      required this.photoURL,
      required this.user});

  factory Author.fromJson(dynamic json) {
    print("_id " + json['_id'] as String);
    print("name " + json['name'] as String);
    print("birthDate " +
        DateTime.parse((json['birthDate'] as String).replaceAll("T", " "))
            .toString());
    print("deathDate " +
        DateTime.parse((json['deathDate'] as String).replaceAll("T", " "))
            .toString());
    print("biography " + json['biography'] as String);
    print("books " +
        (json['books'].toString().contains('{')
            ? Book.booksFromSnapshot(json['books'])
            : json['books']));
    print("categories " +
        myCategory.Category.categoriesFromSnapshot(json['categories'])
            .toString());
    print("photoURL " + json['photoURL'] as String);
    print("user " + User.fromJson(json['user']).toString());
    var id = json['_id'] as String;
    var name = json['name'] as String;
    var birthDate =
        DateTime.parse((json['birthDate'] as String).replaceAll("T", " "));
    var deathDate =
        DateTime.parse((json['deathDate'] as String).replaceAll("T", " "));
    var biography = json['biography'] as String;
    var books = json['books'].toString().contains('{')
        ? Book.booksFromSnapshot(json['books'])
        : json['books'];
    var categories =
        myCategory.Category.categoriesFromSnapshot(json['categories']);
    var photoURL = json['photoURL'] as String;
    var user = UserPopulate.fromJson(json['user']);

    var author = Author(
        id: id,
        name: name,
        deathDate: deathDate,
        birthDate: birthDate,
        biography: biography,
        books: books,
        categories: categories,
        photoURL: photoURL,
        user: user);
    return author;
  }

  static List<Author> authorsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Author.fromJson(data);
    }).toList();
  }
}
