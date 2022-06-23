class Rating {
  String userId;
  String rate;
  Rating({required this.userId, required this.rate});

  factory Rating.fromJson(dynamic json) {
    return Rating(
      userId: json['userId'] as String,
      rate: json['rate'] as String,
    );
  }
  static Map<String, dynamic> toJson(Rating values) {
    return {'userId': values.userId, 'rate': values.rate};
  }
}
