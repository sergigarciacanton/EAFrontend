import 'package:ea_frontend/models/user.dart';
import 'package:ea_frontend/models/userPopulate.dart';

class Comment {
  String id;
  User user;
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
            ? User.fromJson(json['user'])
            : json['user'],
        title: json['title'] as String,
        text: json['text'] as String,
        type: json['type'] as String,
        users: json['users'],
        likes: json['likes'].toString());
  }

  static Map<String, dynamic> toJson(Comment values) {
    return {
      'user': User.toJson(values.user),
      'title': values.title,
      'text': values.text,
      'type': values.type,
      'users': values.users.toString(),
      'likes': values.likes.toString()
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

class NewCommentModel {
  String user;
  String title;
  String text;
  String type;
  List<dynamic> users;
  dynamic likes;

  NewCommentModel(
      {required this.user,
      required this.title,
      required this.text,
      required this.type,
      required this.users,
      required this.likes});

  factory NewCommentModel.fromJson(Map<String, dynamic> json) {
    return NewCommentModel(
        user: json['user'] as String,
        title: json['title'] as String,
        text: json['text'] as String,
        type: json['type'] as String,
        users: json['users'],
        likes: json['likes'].toString());
  }

  static Map<String, dynamic> toJson(NewCommentModel values) {
    return {
      'user': values.user,
      'title': values.title,
      'text': values.text,
      'type': values.type,
      'users': values.users.toString(),
      'likes': values.likes.toString()
    };
  }
}
