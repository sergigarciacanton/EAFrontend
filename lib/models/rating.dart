class Rating {
  String userId;
  double rate;

  Rating({required this.userId, required this.rate});

  factory Rating.fromJson(dynamic json) {
    return Rating(
      userId: json['userId'] as String,
      rate: json['rate'] as double,
    );
  }
  static Map<String, dynamic> toJson(Rating values) {
    return {'userId': values.userId, 'rate': values.rate};
  }

  static List<Rating> ratingFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Rating.fromJson(data);
    }).toList();
  }
}
