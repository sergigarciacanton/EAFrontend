class EditClubModel {
  String clubName;
  String description;
  String category;
  String photoURL;

  EditClubModel(
      {required this.clubName,
      required this.description,
      required this.category,
      required this.photoURL});

  factory EditClubModel.fromJson(Map<String, dynamic> json) {
    return EditClubModel(
        clubName: json['clubname'],
        description: json['description'],
        category: json['category'],
        photoURL: json['photoURL']);
  }

  static Map<String, dynamic> toJson(EditClubModel credentials) {
    return {
      'clubName': credentials.clubName,
      'description': credentials.description,
      'category': credentials.category,
      'photoURL': credentials.photoURL
    };
  }
}
