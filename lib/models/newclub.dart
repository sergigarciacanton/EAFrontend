import 'package:ea_frontend/models/userPopulate.dart';

import 'category.dart';

class NewClubModel {
  String clubName;
  String description;
  String idAdmin;
  String categories;
  String photoURL;

  NewClubModel(
      {required this.clubName,
      required this.description,
      required this.idAdmin,
      required this.categories,
      required this.photoURL});

  factory NewClubModel.fromJson(Map<String, dynamic> json) {
    return NewClubModel(
        clubName: json['clubname'],
        description: json['description'],
        idAdmin: json['idAdmin'],
        photoURL: json['photoURL'],
        categories: json['categories'].toString().contains('{')
            ? Category.categoriesFromSnapshot(json['categories'])
            : json['categories']);
  }

  static Map<String, dynamic> toJson(NewClubModel credentials) {
    return {
      'clubName': credentials.clubName,
      'description': credentials.description,
      'idAdmin': credentials.idAdmin,
      'category': credentials.categories,
      'photoURL': credentials.photoURL
    };
  }
}
