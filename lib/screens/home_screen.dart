import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import 'category_management_screen.dart';
import 'tag_management_screen.dart';
import 'edit_expense_screen.dart';
import 'expense_details_screen.dart';
import '../utils/date_utils.dart';
import '../widgets/chip_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFilterOpen = false;
  List<DateTime> _selectedMonths = [];
  List<String> _selectedCategories = [];
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DateTime> _getExpenseMonths(List<Expense> expenses) {
    final monthsSet = expenses
        .map((expense) => DateTime(expense.date.year, expense.date.month))
        .toSet()
        .toList();
    monthsSet.sort((a, b) => a.compareTo(b)); // Sort by date
    return monthsSet;
  }

  List<String> _getExpenseCategories(List<Expense> expenses) {
    final categoriesSet =
        expenses.map((expense) => expense.categoryId).toSet().toList();
    categoriesSet.sort((a, b) => a.compareTo(b)); // Sort by date
    return categoriesSet;
  }

  List<String> _getExpenseTags(List<Expense> expenses) {
    final tagsSet = expenses.map((expense) => expense.tag).toSet().toList();
    tagsSet.sort((a, b) => a.compareTo(b)); // Sort by date
    return tagsSet;
  }

  List<Expense> _getFilteredExpenses(List<Expense> expenses) {
    if (_selectedMonths.isEmpty &&
        _selectedCategories.isEmpty &&
        _selectedTags.isEmpty) {
      return expenses; // If no month selected, return all expenses
    }

    return expenses.where((expense) {
      final expenseMonth = DateTime(expense.date.year, expense.date.month);

      final matchesMonth =
          _selectedMonths.isEmpty || _selectedMonths.contains(expenseMonth);
      final matchesCategory = _selectedCategories.isEmpty ||
          _selectedCategories.contains(expense.categoryId);
      final matchesTag =
          _selectedTags.isEmpty || _selectedTags.contains(expense.tag);

      return matchesMonth && matchesCategory && matchesTag;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
      ),
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Manage Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoryManagementScreen()));
            }),
        ListTile(
            leading: const Icon(Icons.tag),
            title: const Text('Manage Tags'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TagManagementScreen()));
            })
      ])),
      body: Column(
        children: [
          // Collapsible Month Selector Container
          GestureDetector(
            onTap: () {
              setState(() {
                _isFilterOpen = !_isFilterOpen;
              });
            },
            child: Container(
              color: Colors.deepPurple.shade100,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Icon(
                    _isFilterOpen ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),
          if (_isFilterOpen)
            SizedBox(
              width: double.infinity,
              child: Container(
                color: Colors.deepPurple.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<ExpenseProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ChipSelector<DateTime>(
                          label: 'Months:',
                          items: _getExpenseMonths(provider.expenses),
                          idExtractor: (month) => month,
                          labelExtractor: (month) => CustomDateUtils.formatDate(
                            '${month.year}-${month.month.toString().padLeft(2, '0')}-01',
                            'MMM yyyy',
                          ),
                          selectedItems: _selectedMonths,
                          onItemSelected: (month) {
                            setState(() {
                              if (_selectedMonths.contains(month)) {
                                _selectedMonths.remove(month);
                              } else {
                                _selectedMonths.add(month);
                              }
                            });
                          },
                        ),
                        ChipSelector<String>(
                          label: 'Categories:',
                          items: _getExpenseCategories(provider.expenses),
                          idExtractor: (categoryId) => categoryId,
                          labelExtractor: (categoryId) =>
                              Provider.of<ExpenseProvider>(context,
                                      listen: false)
                                  .getCategoryNameById(categoryId),
                          selectedItems: _selectedCategories,
                          onItemSelected: (categoryId) {
                            setState(() {
                              if (_selectedCategories.contains(categoryId)) {
                                _selectedCategories.remove(categoryId);
                              } else {
                                _selectedCategories.add(categoryId);
                              }
                              print(_selectedCategories);
                            });
                          },
                        ),
                        ChipSelector<String>(
                          label: 'Tags:',
                          items: _getExpenseTags(provider.expenses),
                          idExtractor: (tag) => tag,
                          labelExtractor: (tag) => Provider.of<ExpenseProvider>(
                                  context,
                                  listen: false)
                              .getTagNameById(tag),
                          selectedItems: _selectedTags,
                          onItemSelected: (tag) {
                            setState(() {
                              if (_selectedTags.contains(tag)) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

          // Placeholder for list
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, provider, child) {
                final expenses = _getFilteredExpenses(provider.expenses);
                if (provider.expenses.isEmpty) {
                  return const Center(
                    child: Text('Click the + button to record expenses.'),
                  );
                }
                if (expenses.isEmpty) {
                  return const Center(
                    child: Text('No matches.'),
                  );
                }

                final groupedExpenses = _groupExpensesByDate(expenses);

                return ListView.builder(
                  itemCount: groupedExpenses.keys.length,
                  itemBuilder: (context, index) {
                    final date = groupedExpenses.keys.elementAt(index);
                    final expenses = groupedExpenses[date]!;
                    final total = expenses.fold<double>(
                      0.0,
                      (sum, expense) => sum + expense.amount,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                          ),
                          // Date Title
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Date on the left
                              Text(
                                CustomDateUtils.formatDate(
                                    date, "MMM d, yyyy"), // Format the date
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              // Total expense amount on the right
                              Text(
                                '\$${total.toStringAsFixed(2)}', // Format the total amount
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors
                                      .purple, // Optional color for emphasis
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Expense Tiles
                        ...expenses.map((expense) {
                          return Dismissible(
                              key: Key(expense.id), // Unique key for each item
                              direction: DismissDirection
                                  .horizontal, // Allow swiping in both directions
                              background: Container(
                                color: Colors.blue,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: const [
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.delete, color: Colors.white),
                                  ],
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  // Navigate to edit screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditExpenseScreen(expense: expense),
                                    ),
                                  );
                                  return false; // Do not dismiss
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  // Show confirmation dialog for deletion
                                  return await _showDeleteConfirmation(
                                      context, expense.payee);
                                }
                                return false;
                              },
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  Provider.of<ExpenseProvider>(context,
                                          listen: false)
                                      .removeExpense(expense.id);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('${expense.payee} deleted')),
                                  );
                                }
                              },
                              child: GestureDetector(
                                onTap: () {
                                  // Handle onTap
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ExpenseDetailsScreen(
                                              expense: expense),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 1.0,
                                  color: Colors.purple.shade50,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Container(
                                    width: double
                                        .infinity, // Make the card take full width
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, // Minimal vertical padding
                                      horizontal:
                                          12.0, // Adjust horizontal padding
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${expense.payee} - \$${expense.amount.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                'Category: ${Provider.of<ExpenseProvider>(context, listen: false).getCategoryNameById(expense.categoryId)}',
                                                style: const TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // By Date Tab
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(
      BuildContext context, String payee) async {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$payee"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child:
                  const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Expense>> _groupExpensesByDate(List<Expense> expenses) {
    final Map<String, List<Expense>> grouped = {};

    for (var expense in expenses) {
      final dateKey = expense.date.toLocal().toString().split(' ')[0];
      if (grouped.containsKey(dateKey)) {
        grouped[dateKey]!.add(expense);
      } else {
        grouped[dateKey] = [expense];
      }
    }

    return grouped;
  }
}
