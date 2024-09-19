class Author {
  int? id;
  String? name;
  String? birthDate;
  int? booksCount;

  Author({this.id, this.name, this.birthDate});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    birthDate = json['birth_date'];
    booksCount = json['books_count'] ?? 0;
  }

  // Override equality operator to compare books by their id
  @override
  bool operator == (Object other) {
    if (identical(this, other)) return true;
    return other is Author && other.id == id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['birth_date'] = this.birthDate;
    return data;
  }
}