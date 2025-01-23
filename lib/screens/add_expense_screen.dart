import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/outline_input.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  AddExpenseScreenState createState() => AddExpenseScreenState();
}

class AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _payeeController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  String? _selectedTagId;

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ExpenseProvider>(context).categories;
    final tags = Provider.of<ExpenseProvider>(context).tags;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Amount Input
              OutlineInput(
                labelText: 'Amount',
                controller: _amountController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Payee Input
              OutlineInput(
                labelText: 'Payee',
                controller: _payeeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a payee';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Note Input
              OutlineInput(
                labelText: 'Note',
                controller: _noteController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a note';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date Picker
              OutlineInput(
                labelText:
                    'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                readOnly: true,
                suffixIcon: const Icon(Icons.calendar_today),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              OutlineInput(
                labelText: 'Category',
                value: _selectedCategoryId,
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedCategoryId = value;
                }),
              ),
              const SizedBox(height: 16),

              // Tag Dropdown
              OutlineInput(
                labelText: 'Tag',
                value: _selectedTagId,
                items: tags.map((tag) {
                  return DropdownMenuItem<String>(
                    value: tag.id,
                    child: Text(tag.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() {
                  _selectedTagId = value;
                }),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade300,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16.0),
                ),
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategoryId == null || _selectedTagId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category and a tag')),
        );
        return;
      }

      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: double.parse(_amountController.text),
        categoryId: _selectedCategoryId!,
        payee: _payeeController.text,
        note: _noteController.text,
        date: _selectedDate,
        tag: _selectedTagId!,
      );

      Provider.of<ExpenseProvider>(context, listen: false).addExpense(expense);

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly.')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
