import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../elements/edit_book_dialog.dart';
import '../elements/view_book_dialog.dart';
import '../models/book.dart';
import '../controllers/home_controller.dart';

class BooksPage extends StatefulWidget {
  final HomeController controller;

  const BooksPage({required this.controller, super.key});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  double? _width;
  double? _height;
  int currentPage = 0;
  int rowsPerPage = 10;
  int totalBooks = 0;
  List<Book> books = [];
  bool loading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch authors on page load
    fetchBooks(); // Fetch books on page load
  }

  fetchData() async {
    await widget.controller.getAuthors();
    await widget.controller.getGenres();
    await widget.controller.getLanguages();
  }

  // Fetch books using HomeController
  Future<void> fetchBooks() async {
    setState(() {
      loading = true;
    });

    try {
      final response = await widget.controller
          .fetchBooks(rowsPerPage, currentPage * rowsPerPage, searchQuery);
      setState(() {
        books = response.data!;
        totalBooks = response.total!;
        if (currentPage >= (totalBooks / rowsPerPage).ceil()) {
          currentPage = 0;
        }
        loading = false;
      });
    } catch (error) {
      setState(() {
        loading = false;
      });
      print("Error fetching books: $error");
    }
  }

  void _viewBook(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ViewBookDialog(book: book);
      },
    );
  }

  void _editBook(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditBookDialog(
          book: book,
          controller: widget.controller,
          onSave: fetchBooks, // Callback to refresh the books list
        );
      },
    );
  }

  void _deleteBook(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Libro'),
          content: Text(
              '¿Estás seguro de que deseas eliminar el libro "${book.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Handle the delete logic
                String response = await widget.controller.deleteBook(book.id!);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(response),
                  duration: const Duration(seconds: 10),
                ));
                fetchBooks();
                Navigator.of(context).pop(); // Close the dialog
              },
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Function to create a new book
  void _createBook() {
    Book newBook = Book();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditBookDialog(
          book: newBook,
          controller: widget.controller,
          onSave: fetchBooks, // Callback to refresh the books list
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    var isMobile = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    var isTablet = ResponsiveWrapper.of(context).isSmallerThan(DESKTOP);
    int totalPages = (totalBooks / rowsPerPage).ceil();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 15, left: 30, right: 30, bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: isMobile ? _width! * 0.4 : _width! * 0.5,
                            height: _height! * 0.055,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: isMobile ? 5 : 20, top: 5),
                              child: TextField(
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (value) => EasyDebounce.debounce(
                                  'searchBooks',
                                  const Duration(milliseconds: 500),
                                  () {
                                    setState(() {
                                      searchQuery = value;
                                      currentPage =
                                          0; // Reset to the first page
                                      fetchBooks();
                                    });
                                  },
                                ),
                                decoration: const InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: InputBorder.none,
                                  label: Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Icon(Icons.search, color: Colors.black),
                                      SizedBox(width: 10),
                                      Text(
                                        'Buscar libros...',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          isMobile || isTablet
                              ? Container()
                              : Container(
                                  height: _height! * 0.03,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'MOSTRAR',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300,
                                            color: Color.fromARGB(
                                                255, 118, 117, 117)),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.transparent),
                                        ),
                                        width: _width! * 0.03,
                                        height: _height! * 0.03,
                                        child: DropdownButton<int>(
                                          focusColor: Colors.transparent,
                                          dropdownColor: Colors.white,
                                          underline: Container(),
                                          isExpanded: true,
                                          value: rowsPerPage,
                                          items: [10, 20, 30, 50].map((value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Center(
                                                  child: Text(value.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10))),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              rowsPerPage = value!;
                                              currentPage =
                                                  0; // Reset to the first page
                                              fetchBooks();
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'REGISTROS',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w300,
                                            color: Color.fromARGB(
                                                255, 118, 117, 117)),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                    isMobile ? const SizedBox(height: 20) : Container(),
                    !loading
                        ? Table(
                            border:
                                TableBorder.all(color: Colors.grey.shade300),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(40),
                              1: FlexColumnWidth(2),
                              2: FlexColumnWidth(2),
                              3: FixedColumnWidth(60),
                              4: FlexColumnWidth(1.5),
                              5: FixedColumnWidth(120),
                            },
                            children: [
                              buildTableHeader(context),
                              ...books.map((book) {
                                return TableRow(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  children: [
                                    buildTableCell(book.id.toString()),
                                    buildTableCell(book.title!),
                                    buildTableCell(book.author!.name!),
                                    buildTableCell(book.year.toString()),
                                    buildTableCell(book.genre!.name!),
                                    buildActionButtons(book),
                                  ],
                                );
                              }).toList(),
                            ],
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.4),
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                    if (!loading && totalPages > 0)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          width: 500,
                          height: 40,
                          child: NumberPaginator(
                            config: NumberPaginatorUIConfig(
                              buttonSelectedBackgroundColor:
                                  Colors.blue.shade700,
                              buttonUnselectedForegroundColor: Colors.black,
                            ),
                            initialPage: currentPage,
                            numberPages: totalPages,
                            onPageChange: (index) {
                              setState(() {
                                currentPage = index;
                                fetchBooks();
                              });
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Add floating action button for creating a book
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createBook, // Open dialog to create a book
        icon: const Icon(Icons.add),
        label: Text('Añadir Libro',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16)),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  TableRow buildTableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      children: [
        buildContainerTitle('ID'),
        buildContainerTitle('TÍTULO'),
        buildContainerTitle('AUTOR'),
        buildContainerTitle('AÑO'),
        buildContainerTitle('GÉNERO'),
        buildContainerTitle('ACCIONES'),
      ],
    );
  }

  Widget buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      child: Text(text, style: const TextStyle(color: Colors.black87)),
    );
  }

  Widget buildActionButtons(Book book) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.visibility, color: Colors.blue.shade700),
          onPressed: () => _viewBook(book),
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.green.shade700),
          onPressed: () => _editBook(book),
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red.shade700),
          onPressed: () => _deleteBook(book),
        ),
      ],
    );
  }

  Container buildContainerTitle(String text) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold)));
  }
}
