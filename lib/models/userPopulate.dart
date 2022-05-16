class UserPopulate {
  String userName;
  String mail;

  UserPopulate({required this.userName, required this.mail});

  factory UserPopulate.fromJson(dynamic json) {
    var userName = json['userName'] as String;
    var mail = json['mail'] as String;

    var u = UserPopulate(
      userName: userName,
      mail: mail,
    );
    return u;
  }

  static List<UserPopulate> usersFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return UserPopulate.fromJson(data);
    }).toList();
  }
}
