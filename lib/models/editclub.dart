class EditClubModel {
  String clubName;
  String description;

  EditClubModel({
    required this.clubName,
    required this.description
  });

  factory EditClubModel.fromJson(Map<String, dynamic> json) {
    return EditClubModel(
      clubName: json['clubname'],
      description: json['description']
    );
  }

  static Map<String, dynamic> toJson(EditClubModel credentials) {
    return {
      'clubName': credentials.clubName,
      'description': credentials.description
    };
  }
}
