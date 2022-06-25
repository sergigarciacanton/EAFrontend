import 'rating.dart';

class Rate {
  String id;
  String bookId;
  List<dynamic> rating;
  dynamic totalRate;

  Rate({
    required this.id,
    required this.bookId,
    required this.rating,
    required this.totalRate,
  });

  factory Rate.fromJson(dynamic json) {
    return Rate(
      id: json['_id'] as String,
      bookId: json['bookId'] as String,
      rating: json['rating'].toString().contains('{')
          ? Rating.ratingFromSnapshot(json['rating'])
          : json['rating'],
      totalRate: json['totalRate'],
    );
  }

  static List<Rate> ratesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Rate.fromJson(data);
    }).toList();
  }

  static Rate ratesFromJson(data) {
    return Rate.fromJson(data);
  }

  static Map<String, dynamic> toJson(Rate values) {
    return {
      'bookId': values.bookId.toString(),
      'rating': values.rating,
      'totalRate': values.totalRate,
    };
  }
}
