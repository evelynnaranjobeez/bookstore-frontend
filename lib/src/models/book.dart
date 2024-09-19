import 'author.dart';
import 'genre.dart';
import 'language.dart';

class ResponseBooks {
  int? total;
  String? limit;
  String? offset;
  List<Book>? data;

  ResponseBooks({this.total, this.limit, this.offset, this.data});

  ResponseBooks.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    offset = json['offset'];
    if (json['data'] != null) {
      data = <Book>[];
      json['data'].forEach((v) {
        data!.add(new Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['limit'] = this.limit;
    data['offset'] = this.offset;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Book {
  int? id;
  String? title;
  int? authorId;
  int? year;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? genreId;
  int? languageId;
  Author? author;
  Genre? genre;
  Language? language;

  Book(
      {this.id,
        this.title,
        this.authorId,
        this.year,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.genreId,
        this.languageId,
        this.author,
        this.genre,
        this.language});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    authorId = json['author_id'];
    year = json['year'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    genreId = json['genre_id'];
    languageId = json['language_id'];
    author = json['author'] != null ? new Author.fromJson(json['author']) : null;
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
    language = json['language'] != null ? new Language.fromJson(json['language']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author_id'] = this.authorId;
    data['year'] = this.year;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['genre_id'] = this.genreId;
    data['language_id'] = this.languageId;
    if (this.author != null) {
      data['author'] = this.author!.toJson();
    }
    if (this.genre != null) {
      data['genre'] = this.genre!.toJson();
    }
    if (this.language != null) {
      data['language'] = this.language!.toJson();
    }
    return data;
  }



  // Override hashCode to ensure objects are compared by id
  @override
  int get hashCode => id.hashCode;
}



