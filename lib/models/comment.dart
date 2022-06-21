import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/models/userPopulate.dart';

class Comment {
  String id;
  dynamic user;
  String title;
  String text;
  String type;
  List<dynamic> users;
  dynamic likes;

  Comment(
      {required this.id,
      required this.user,
      required this.title,
      required this.text,
      required this.type,
      required this.users,
      required this.likes});

  factory Comment.fromJson(dynamic json) {
    return Comment(
        id: json['_id'] as String,
        user: json['user'].toString().contains('{')
            ? UserPopulate.fromJson(json['user'])
            : json['user'],
        title: json['title'] as String,
        text: json['text'] as String,
        type: json['type'] as String,
        users: json['users'],
        likes: json['likes'].toString());
  }

  static Map<String, dynamic> toJson(Comment values) {
    return {
      'user': values.user,
      'title': values.title,
      'text': values.text,
      'type': values.type,
      'users': values.users,
      'likes': values.likes
    };
  }

  static List<Comment> commentsFromSnapshot(List snapshot) {
    var a = snapshot.map((data) {
      return Comment.fromJson(data);
    }).toList();

    return a;
  }
}

class CommentLike {
  Comment comment;
  bool isSlected;

  CommentLike(this.comment, this.isSlected);
}
