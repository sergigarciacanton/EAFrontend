class NewBookModel {
  String title;
  String ISBN;
  String photoURL;
  String description;
  DateTime publishedDate;
  String editorial;
  String rate;
  List<dynamic> category;
  String writer;

  NewBookModel(
      {required this.title,
      required this.ISBN,
      required this.photoURL,
      required this.description,
      required this.publishedDate,
      required this.editorial,
      required this.rate,
      required this.category,
      required this.writer});
  factory NewBookModel.fromJson(Map<String, dynamic> json) {
    return NewBookModel(
        title: json['title'],
        ISBN: json['ISBN'],
        photoURL: json['photoURL'],
        description: json['description'],
        publishedDate: json['publishedDate'],
        editorial: json['editorial'],
        rate: json['rate'],
        category: json['category'],
        writer: json['writer']);
  }

  static Map<String, dynamic> toJson(NewBookModel values) {
    return {
      'title': values.title,
      'ISBN': values.ISBN,
      'photoURL': values.photoURL,
      'description': values.description,
      'publishedDate': values.publishedDate.toString(),
      'editorial': values.editorial,
      'rate': values.rate.toString(),
      'category': values.category.toString(),
      'writer': values.writer
    };
  }
}
