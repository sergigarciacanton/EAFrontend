class NewClubModel {
  String clubname;
  String description;
  String idAdmin;
  String category;

  NewClubModel(
      {required this.clubname,
      required this.description,
      required this.idAdmin,
      required this.category});

  factory NewClubModel.fromJson(Map<String, dynamic> json) {
    return NewClubModel(
        clubname: json['clubname'],
        description: json['description'],
        idAdmin: json['idAdmin'],
        category: json['category']);
  }

  static Map<String, dynamic> toJson(NewClubModel credentials) {
    return {
      'clubname': credentials.clubname,
      'description': credentials.description,
      'idAdmin': credentials.idAdmin,
      'category': credentials.category
    };
  }
}
