import 'dart:developer';

class Category {
  String name;
  String id;
  String en;
  String es;
  String ca;

  Category(
      {required this.name,
      required this.id,
      required this.es,
      required this.en,
      required this.ca});

  factory Category.fromJson(dynamic json) {
    return Category(
        id: json['_id'] as String,
        name: json['name'] = json['name'] as String,
        en: json['name'] = json['en'] as String,
        es: json['name'] = json['es'] as String,
        ca: json['name'] = json['ca'] as String);
  }

  static List<Category> categoriesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Category.fromJson(data);
    }).toList();
  }
}

class CategoryList {
  String id;
  String name;
  bool isSlected;

  CategoryList(this.id, this.name, this.isSlected);
}
