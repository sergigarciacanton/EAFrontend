import 'user.dart';
import 'chat.dart';
import 'category.dart';

class Club {
  String name;
  String description;
  dynamic admin;
  Chat chat;
  List<dynamic> usersList;
  List<dynamic> category;

  Club(
      {required this.name,
      required this.description,
      required this.admin,
      required this.chat,
      required this.usersList,
      required this.category});

  factory Club.fromJson(dynamic json) {
    return Club(
        name: json['name'] as String,
        description: json['description'] as String,
        admin: json['admin'].toString().contains('{')
            ? User.fromJson(json['admin'])
            : json['admin'],
        chat: json['chat'].toString().contains('{')
            ? Chat.fromJson(json['chat'])
            : json['chat'],
        usersList: json['usersList'].toString().contains('{')
            ? User.usersFromSnapshot(json['usersList'])
            : json['usersList'],
        category: json['category'].toString().contains('{')
            ? Category.categoriesFromSnapshot(json['category'])
            : json['category']);
  }

  static List<Club> clubsFromSnapshot(List snapshot) {
    print(snapshot);
    var list = snapshot.map((data) {
      print(data);
      return Club.fromJson(data);
    }).toList();
    print("in CLUB ");
    return list;
  }
}
