import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/author.dart';
import '../models/book.dart';
import '../models/genre.dart';
import '../models/language.dart';
import 'custom_text_form_field.dart';
import 'custom_search_field.dart';

class EditBookDialog extends StatelessWidget {
  final Book book;
  final HomeController controller;
  final VoidCallback onSave; // Callback to refresh the list after saving

  EditBookDialog({
    required this.book,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController titleController =
        TextEditingController(text: book.title);
    TextEditingController yearController = TextEditingController(
        text: book.year != null ? book.year.toString() : '');
    TextEditingController descriptionController =
        TextEditingController(text: book.description);


    return AlertDialog(
      title: Text(book.id == null ? 'Nuevo Libro' : 'Editar Libro',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.black45, fontSize: 20, letterSpacing: 1.3)),
      content: (controller.authors.isEmpty ||
              controller.genres.isEmpty ||
              controller.languages.isEmpty)
          ? const CircularProgressIndicator() // Show loading until data is ready
          : Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Form(
                key: _formKey, // Use Form to enable validation
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextFormField(
                        controller: titleController,
                        labelText: 'Título',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El título es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        controller: yearController,
                        labelText: 'Año',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El año es requerido';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Por favor ingrese un año válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomTextFormField(
                        controller: descriptionController,
                        labelText: 'Descripción',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La descripción es requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      CustomSearchField<Author>(
                        label: 'Seleccione un autor',
                        items: controller.authors,  // List of authors
                        initialItem: book.author,   // Selected author
                        displayField: (author) => author.name!, // Display the author's name
                        onItemSelected: (selectedAuthor) {
                          book.authorId = selectedAuthor.id; // Handle author selection
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El autor es requerido';
                          }
                          if (controller.authors.where((author) => author.name == value).isEmpty) {
                            return 'Autor no encontrado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomSearchField<Genre>(
                        label: 'Seleccione un género',
                        items: controller.genres,  // List of genres
                        initialItem: book.genre,   // Selected genre
                        displayField: (genre) => genre.name!, // Display the genre name
                        onItemSelected: (selectedGenre) {
                          book.genreId = selectedGenre.id; // Handle genre selection
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El género es requerido';
                          }
                          if (controller.genres.where((genre) => genre.name == value).isEmpty) {
                            return 'Género no encontrado';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomSearchField<Language>(
                        label: 'Seleccione un idioma',
                        items: controller.languages,  // List of languages
                        initialItem: book.language,   // Selected language
                        displayField: (language) => language.name!, // Display the language name
                        onItemSelected: (selectedLanguage) {
                          book.languageId = selectedLanguage.id; // Handle language selection
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'El idioma es requerido';
                          }
                          if (controller.languages.where((language) => language.name == value).isEmpty) {
                            return 'Idioma no encontrado';
                          }
                          return null;
                        },
                      ),

                    ],
                  ),
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Update the book data
              book.title = titleController.text;
              book.year = int.parse(yearController.text);
              book.description = descriptionController.text;

              // Call the controller's update function
              String? response;
              if (book.id == null) {
                response = await controller.createBook(book);
              } else {
                response = await controller.updateBook(book);
              }

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(response),
                duration: const Duration(seconds: 2),
              ));

              // Refresh the list
              onSave();

              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
