import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/outline_input.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  EditExpenseScreenState createState() => EditExpenseScreenState();
}

class EditExpenseScreenState extends State<EditExpenseScreen> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _payeeController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  String? _selectedTagId;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current values of the expense
    _amountController =
        TextEditingController(text: widget.expense.amount.toString());
    _selectedCategoryId = widget.expense.categoryId;
    _payeeController = TextEditingController(text: widget.expense.payee);
    _noteController = TextEditingController(text: widget.expense.note);
    _selectedDate = widget.expense.date;
    _selectedTagId = widget.expense.tag;
  }

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<ExpenseProvider>(context).categories;
    final tags = Provider.of<ExpenseProvider>(context).tags;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Amount Input
            OutlineInput(
              labelText: 'Amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Payee Input
            OutlineInput(
              labelText: 'Payee',
              controller: _payeeController,
            ),
            const SizedBox(height: 16),

            // Note Input
            OutlineInput(
              labelText: 'Note',
              controller: _noteController,
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
              onPressed: _updateExpense,
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

  void _updateExpense() {
    if (_selectedCategoryId == null || _selectedTagId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category and a tag')),
      );
      return;
    }

    final updatedExpense = Expense(
      id: widget.expense.id,
      amount: double.parse(_amountController.text),
      categoryId: _selectedCategoryId!,
      payee: _payeeController.text,
      note: _noteController.text,
      date: _selectedDate,
      tag: _selectedTagId!,
    );

    Provider.of<ExpenseProvider>(context, listen: false)
        .addOrUpdateExpense(updatedExpense);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
