import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tag.dart';
import '../providers/expense_provider.dart';

class TagManagementScreen extends StatelessWidget {
  const TagManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tags'),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.tags.length,
            itemBuilder: (context, index) {
              final tag = provider.tags[index];
              return ListTile(
                title: Text(tag.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteTag(tag.id);
                  },
                ),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _showAddTagDialog(context);
      },
      tooltip: 'Add Tag',
      child: Icon(Icons.add)),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    final TextEditingController tagNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Tag'),
          content: TextField(
            controller: tagNameController,
            decoration: InputDecoration(labelText: 'Tag Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final tag = Tag(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: tagNameController.text,
                );
                Provider.of<ExpenseProvider>(context, listen: false).addTag(tag);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}