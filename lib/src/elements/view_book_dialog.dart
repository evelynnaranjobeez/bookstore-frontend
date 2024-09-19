import 'package:flutter/material.dart';
import '../models/book.dart';

class ViewBookDialog extends StatelessWidget {
  final Book book;

  const ViewBookDialog({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalles del Libro',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.black45,
              fontSize: 20,
              letterSpacing: 1.3)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Título', book.title!),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              _buildDetailItem('Año', book.year.toString()),
              const SizedBox(height: 10),
              _buildDetailItem('Género', book.genre!.name!),
              const SizedBox(height: 10),
              _buildDetailItem('Idioma', book.language!.name!),
              const SizedBox(height: 10),
              _buildDetailItem('Descripción', book.description!),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Autor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      book.author!.name!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      book.author!.booksCount.toString() + ' libros',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  // Helper method to create styled book detail items
  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
