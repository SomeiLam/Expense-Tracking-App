import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/date_utils.dart';

class ByDateWidget extends StatefulWidget {
  final List<Expense> expenses;

  const ByDateWidget({super.key, required this.expenses});

  @override
  ByDateWidgetState createState() => ByDateWidgetState();
}

class ByDateWidgetState extends State<ByDateWidget> {
  List<DateTime> _months = [];
  DateTime? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _initializeMonths();
  }

  void _initializeMonths() {
    // Extract unique months from expenses
    final monthsSet = widget.expenses
        .map((expense) => DateTime(expense.date.year, expense.date.month))
        .toSet();

    _months = monthsSet.toList()..sort((a, b) => a.compareTo(b));
    if (_months.isNotEmpty) {
      _selectedMonth = _months.first; // Default to the first month
    }
  }

  List<Expense> _getExpensesForSelectedMonth() {
    if (_selectedMonth == null) return [];
    return widget.expenses
        .where((expense) =>
            expense.date.year == _selectedMonth!.year &&
            expense.date.month == _selectedMonth!.month)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final expensesForMonth = _getExpensesForSelectedMonth();

    return Column(
      children: [
        // Horizontal Month Carousel
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          height: 50.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _months.length,
            itemBuilder: (context, index) {
              final month = _months[index];
              final isSelected = _selectedMonth == month;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMonth = month;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.deepPurple.shade300
                        : Colors.deepPurple.shade100,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      CustomDateUtils.formatDate(
                        '${month.year}-${month.month.toString().padLeft(2, '0')}-01',
                        'MMM yyyy',
                      ),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),

        // Expenses for Selected Month
        Expanded(
          child: ListView.builder(
            itemCount: expensesForMonth.length,
            itemBuilder: (context, index) {
              final expense = expensesForMonth[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2.0,
                color: Colors.deepPurple.shade50,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(
                    '${expense.payee} - \$${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${CustomDateUtils.formatDate(expense.date.toString(), "MMM d, yyyy")}\nCategory: ${expense.categoryId}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                    ),
                  ),
                  onTap: () {
                    // Handle navigation to edit expense screen
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
