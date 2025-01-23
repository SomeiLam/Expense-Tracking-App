import 'package:expense_tracking_app/screens/edit_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/tag.dart';
import '../providers/expense_provider.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense;
  const ExpenseDetailsScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ExpenseProvider>(context).categories;
    final tags = Provider.of<ExpenseProvider>(context).tags;

    return Scaffold(
      appBar: AppBar(title: Text(expense.payee)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _detailCard(Icon(Icons.payment), 'Amount',
                '\$${expense.amount.toStringAsFixed(2)}',
                secondaryColor: true),
            _detailCard(Icon(Icons.store), 'Payee', expense.payee),
            _detailCard(Icon(Icons.event_note), 'Note', expense.note,
                secondaryColor: true),
            _detailCard(Icon(Icons.calendar_month), 'Date',
                expense.date.toLocal().toString().split(' ')[0],
                secondaryColor: true),
            _detailCard(Icon(Icons.category), 'Category',
                ExpenseCategory.getNameById(expense.categoryId, categories)),
            _detailCard(
                Icon(Icons.tag), 'Tag', Tag.getNameById(expense.tag, tags)),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditExpenseScreen(expense: expense)));
                },
                child: const Text('Edit')),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Text(
                            'Are you sure you want to delete ${expense.payee}?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Close dialog and return false
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              Provider.of<ExpenseProvider>(context,
                                      listen: false)
                                  .removeExpense(expense.id);
                              Navigator.of(dialogContext)
                                  .pop(); // Close dialog and return true
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('${expense.payee} deleted')));
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Delete')),
          ],
        ),
      ),
    );
  }

  Widget _detailCard(Icon icon, String title, String value,
      {bool secondaryColor = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 1.0,
      color: secondaryColor ? Colors.purple.shade50 : Colors.deepPurple.shade50,
      child: Container(
        width: double.infinity, // Make the card take full width
        padding: const EdgeInsets.symmetric(
          vertical: 16.0, // Minimal vertical padding
          horizontal: 12.0, // Adjust horizontal padding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: <Widget>[
                  icon,
                  Text(title, style: const TextStyle(fontSize: 16.0))
                ]),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
