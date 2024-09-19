import 'package:bookstore_app_web/src/models/book.dart';
import 'package:bookstore_app_web/src/repository/user_repository.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/author.dart';
import '../models/genre.dart';
import '../models/language.dart';
import '../models/user.dart';

// Fetch books with pagination and optional search query
Future<ResponseBooks> getBooks(int limit, int offset, query) async {
  User? user = await getCurrentUser();  // Get the current user with the token
  final String apiToken = user?.apiToken ?? '';  // Retrieve the user's token
  final String url = '${GlobalConfiguration().getValue('api_base_url')}get_books_with_pagination?limit=$limit&offset=$offset&search=$query';
  final client = http.Client();

  // Send GET request with Bearer token for authorization
  final response = await client.get(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
  );

  // If successful, parse the response into ResponseBooks object
  if (response.statusCode == 200) {
    return ResponseBooks.fromJson(json.decode(response.body));
  } else {
    throw Exception('Error al cargar los libros');  // Error handling
  }
}

// Delete a book by its ID
Future<String> deleteBookRepo(int id) async {
  User? user = await getCurrentUser();  // Get current user and token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}books/$id';  // API URL for deleting a book
  final client =  http.Client();
  // Send DELETE request with Bearer token
  final response = await client.delete(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
  );

  // Return success message if book is deleted
  if (response.statusCode == 200) {
    return 'Libro eliminado';
  } else {
    throw Exception('Error al eliminar el libro');  // Error handling
  }
}

// Create a  book
Future<String> createBookRepo(Book book) async {
  User? user = await getCurrentUser();  // Get user token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}books';  // API endpoint to create a book
  final client =  http.Client();
  // Send POST request to create the book with JSON data
  final response = await client.post(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
    body: json.encode(book.toJson()),  // Encode book data into JSON
  );

  // Return success message if the book is created
  if (response.statusCode == 200) {
    return 'Libro creado';
  } else {
    throw Exception('Error al crear el libro');  // Error handling
  }
}

// Update an existing book by its ID
Future<String> updateBookRepo(Book book) async {
  User? user = await getCurrentUser();  // Get user token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}books/${book.id}';  // API endpoint to update the book

  final client =  http.Client();
  // Send PUT request to update the book
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
    body: json.encode(book.toJson()),  // Encode updated book data into JSON
  );

  // Return success message if the book is updated
  if (response.statusCode == 200) {
    return 'Libro actualizado';
  } else {
    throw Exception('Error al actualizar el libro');  // Error handling
  }
}

// Fetch a list of authors from the API
Future<List<Author>> getAuthorsRepo() async {
  User? user = await getCurrentUser();  // Get current user and token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}get_authors';  // API endpoint to get authors
  final client =  http.Client();
  // Send GET request with Bearer token for authorization
  final response = await client.get(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
  );

  // Parse and return the list of authors if successful
  if (response.statusCode == 200) {
    List<Author> authors = [];
    for (var author in json.decode(response.body)) {
      authors.add(Author.fromJson(author));  // Convert each author JSON object into an Author model
    }
    return authors;
  } else {
    throw Exception('Error al cargar los autores');  // Error handling
  }
}

Future<List<Genre>> getGenresRepo() async {
  User? user = await getCurrentUser();  // Get current user and token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}genres';  // API endpoint to get genres
  final client =  http.Client();
  // Send GET request with Bearer token for authorization
  final response = await client.get(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
  );

  // Parse and return the list of genres if successful
  if (response.statusCode == 200) {
    List<Genre> genres = [];
    for (var genre in json.decode(response.body)) {
      genres.add(Genre.fromJson(genre));  // Convert each genre JSON object into a Genre model
    }
    return genres;
  } else {
    throw Exception('Error al cargar los géneros');  // Error handling
  }
}

Future<List<Language>> getLanguagesRepo() async{
  User? user = await getCurrentUser();  // Get current user and token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}languages';  // API endpoint to get languages
  final client =  http.Client();
  // Send GET request with Bearer token for authorization
  final response = await client.get(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken',
    },
  );

  // Parse and return the list of languages if successful
  if (response.statusCode == 200) {
    List<Language> languages = [];
    for (var language in json.decode(response.body)) {
      languages.add(Language.fromJson(language));  // Convert each language JSON object into a Language model
    }
    return languages;
  } else {
    throw Exception('Error al cargar los idiomas');  // Error handling
  }
}

// Fetch life expectancy data from the World Bank API
Future<List<dynamic>> fetchLifeExpectancyDataRepo()async{
  User? user = await getCurrentUser();  // Get current user and token
  final String apiToken = user?.apiToken ?? '';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}life_expectancy';  // API endpoint to get languages
  final client =  http.Client();

  final response = await client.get(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $apiToken'
    }
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body)['data'];
    return data;
  } else {
    return [jsonDecode(response.body)];
  }
}