import 'package:bookstore_app_web/src/models/book.dart';
import 'package:bookstore_app_web/src/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/author.dart';
import '../models/genre.dart';
import '../models/language.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

class HomeController extends ControllerMVC {
  late GlobalKey<ScaffoldState> scaffoldKey;
  User? user;

  List<Author> authors = [];
  List<Genre> genres = [];
  List<Language> languages = [];

  HomeController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }

  Future<void> getUser() async {
    user = userRepo.currentUser;
    setState(() {});
  }

  logout() async {
    userRepo.logout().then((value) {
      Navigator.of(scaffoldKey.currentContext!)
          .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
    });
  }

  Future<ResponseBooks> fetchBooks(limit, offset, query) async {
    return getBooks(limit, offset, query);
  }

  Future<String> deleteBook(int id) async {
    return deleteBookRepo(id);
  }

  Future<String> createBook(Book book) async {
    return createBookRepo(book);
  }

  Future<String> updateBook(Book book) async {
    return updateBookRepo(book);
  }

  Future<void> getAuthors() async {
    authors = await getAuthorsRepo();
    setState(() {});
  }

  Future<void> getGenres() async {
    genres = await getGenresRepo();
    setState(() {});
  }

  Future<void> getLanguages() async {
    languages = await getLanguagesRepo();
    setState(() {});
  }

  Future<List<dynamic>> fetchLifeExpectancyData() async {
    return await fetchLifeExpectancyDataRepo();
  }
}
