import 'package:flutter/material.dart';

class ChipSelector<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T Function(T item) idExtractor;
  final String Function(T item) labelExtractor;
  final List<T> selectedItems;
  final ValueChanged<T> onItemSelected;

  const ChipSelector({
    super.key,
    required this.label,
    required this.items,
    required this.idExtractor,
    required this.labelExtractor,
    required this.selectedItems,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.deepPurple.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: items.map((item) {
                final isSelected = selectedItems.contains(idExtractor(item));
                return GestureDetector(
                  onTap: () => onItemSelected(item),
                  child: Chip(
                    padding: EdgeInsets.zero,
                    label: Text(
                      labelExtractor(item),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    backgroundColor: isSelected
                        ? Colors.deepPurple
                        : Colors.deepPurple.shade50,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
