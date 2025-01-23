import 'package:flutter/material.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  AddCategoryDialogState createState() => AddCategoryDialogState();
}

class AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Category'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Category Name'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final categoryName = _nameController.text;
            if (categoryName.isNotEmpty) {
              // Add category logic here
              Navigator.of(context).pop(categoryName);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}