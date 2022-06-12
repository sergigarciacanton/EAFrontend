class RegisterModel {
  String name;
  String username;
  DateTime birthDate;
  String mail;
  String? password;
  bool google;

  RegisterModel({
    required this.name,
    required this.username,
    required this.birthDate,
    required this.mail,
    this.password,
    required this.google,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
        name: json['name'],
        username: json['userName'],
        birthDate: json['birthDate'],
        mail: json['mail'],
        password: json['password'],
        google: json['google'],
    );
  }

  static Map<String, dynamic> toJson(RegisterModel credentials) {
    if(credentials.password != null) {
      return {
        'name': credentials.name,
        'userName': credentials.username,
        'birthDate': credentials.birthDate.toString(),
        'mail': credentials.mail,
        'password': credentials.password,
        'google': credentials.google,
      };
    }
    else {
      return {
        'name': credentials.name,
        'userName': credentials.username,
        'birthDate': credentials.birthDate.toString(),
        'mail': credentials.mail,
        'google': credentials.google,
      };
    }
  }
}
