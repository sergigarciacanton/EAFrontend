import 'dart:developer';

class Category {
  String? name;

  Category({this.name});

  factory Category.fromJson(dynamic json) {
    if (json.runtimeType == String) {
      return Category(name: null);
    }
    return Category(name: json['name'] == null ? null : json['name'] as String);
  }

  static List<Category> categoriesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Category.fromJson(data);
    }).toList();
  }
}
