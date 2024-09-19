import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class CustomSearchField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? initialItem;
  final String Function(T) displayField; // Function to get display text from the item
  final Function(T) onItemSelected;
  final String? Function(String?)? validator;

  const CustomSearchField({
    Key? key,
    required this.label,
    required this.items,
    required this.displayField,
    required this.onItemSelected,
    this.initialItem,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.black54, fontSize: 14),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchField<T>(
              initialValue: initialItem != null && items.contains(initialItem)
                  ? SearchFieldListItem<T>(
                displayField(initialItem!),
                item: initialItem,
                child: Text(
                  displayField(initialItem!),
                  style: const TextStyle(color: Colors.black),
                ),
              )
                  : null,
              suggestions: items
                  .map(
                    (T item) => SearchFieldListItem<T>(
                  displayField(item),
                  item: item,
                  child: Text(
                    displayField(item), // Display the name or label
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
                  .toList(),
              searchInputDecoration: const InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.black),

              ),
              searchStyle: const TextStyle(color: Colors.black),
              onSuggestionTap: (selected) {
                onItemSelected(selected.item!);
              },
              onSubmit: (value) {
                var selectedItem =
                items.firstWhere((item) => displayField(item) == value);
                onItemSelected(selectedItem);
              },
              validator: validator,
            ),
          ),
        ),
      ],
    );
  }
}
