import 'package:ea_frontend/models/category.dart';

class Book {
  String id;
  String title;
  String ISBN;
  String photoURL;
  String description;
  DateTime publishedDate;
  String editorial;
  dynamic rate;
  List<dynamic> category;
  String writer;

  Book({
    required this.id,
    required this.title,
    required this.ISBN,
    required this.photoURL,
    required this.description,
    required this.publishedDate,
    required this.editorial,
    required this.rate,
    required this.category,
    required this.writer
  });

  factory Book.fromJson(dynamic json) {
    return Book(
      id: json['_id'] as String,
      title: json['title'] as String,
      ISBN: json['ISBN'] as String,
      photoURL: json['photoURL'] as String,
      description: json['description'] as String,
      publishedDate: DateTime.parse(
          (json['publishedDate'] as String).replaceAll("T", " ")),
      editorial: json['editorial'] as String,
      rate: json['rate'],
      category: json['category'].toString().contains('{')
          ? Category.categoriesFromSnapshot(json['category'])
          : json['category'],
      writer: json['writer'] as String,
    );

  }

  static List<Book> booksFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Book.fromJson(data);
    }).toList();
  }

  static Book booksFromJson(data) {
    return Book.fromJson(data);
  }

  // @override
  // String toString() {
  //   return 'Book {title: $title, imageURL: $photoURL, rate: $rate}';
  // }
}
