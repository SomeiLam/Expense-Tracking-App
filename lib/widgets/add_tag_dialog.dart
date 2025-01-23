import 'package:flutter/material.dart';

class AddTagDialog extends StatefulWidget {
  const AddTagDialog({super.key});

  @override
  AddTagDialogState createState() => AddTagDialogState();
}

class AddTagDialogState extends State<AddTagDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Tag'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Tag Name'),
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
            final tagName = _nameController.text;
            if (tagName.isNotEmpty) {
              // Add tag logic here
              Navigator.of(context).pop(tagName);
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