class Book {
  final String title;
  final String imageUrl;
  final int rate;

  Book({required this.title, required this.imageUrl, required this.rate});

  factory Book.fromJson(dynamic json) {
    return Book(
      title: json['title'] as String,
      imageUrl: json['photoURL'] as String,
      rate: json['rate'] as int);
  }

  static List<Book> booksFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Book.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Book {title: $title, imageURL: $imageUrl, rate: $rate}';
  }
}