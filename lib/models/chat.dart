import 'user.dart';
import 'chat_message.dart';

class Chat {
  String name;
  List<ChatMessage> messages;
  List<User> users;

  Chat({required this.name, required this.messages, required this.users});

  factory Chat.fromJson(dynamic json) {
    return Chat(
        name: json['name'] as String,
        messages: ChatMessage.chatMessageFromSnapshot(json['messages']),
        users: User.usersFromSnapshot(json['users']));
  }

  static List<Chat> chatsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Chat.fromJson(data);
    }).toList();
  }
}
