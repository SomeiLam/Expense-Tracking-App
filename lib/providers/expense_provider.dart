import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../models/tag.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'dart:developer';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
  // List of expenses
  List<Expense> _expenses = [];
  List<ExpenseCategory> _categories = [];
  List<Tag> _tags = [];

  ExpenseProvider(this.storage) {
    _initializeStorage();
  }

  void _initializeStorage() async {
    await storage.ready;

    // Check if the app is already initialized
    final isInitialized = storage.getItem('isInitialized') ?? false;

    if (!isInitialized) {
      // Initialize default categories and tags
      _categories = [
        ExpenseCategory(
          id: '1',
          name: 'Housing',
          subCategories: [
            SubCategory(id: '1-1', name: 'Mortgage or Rent'),
            SubCategory(id: '1-2', name: 'Property Taxes'),
            SubCategory(id: '1-3', name: 'Household Repairs'),
            SubCategory(id: '1-4', name: 'HOA Fees'),
          ],
        ),
        ExpenseCategory(
          id: '2',
          name: 'Transportation',
          subCategories: [
            SubCategory(id: '2-1', name: 'Fuel'),
            SubCategory(id: '2-2', name: 'Car Maintenance'),
            SubCategory(id: '2-3', name: 'Public Transportation'),
            SubCategory(id: '2-4', name: 'Car Insurance'),
          ],
        ),
        ExpenseCategory(
          id: '3',
          name: 'Food',
          subCategories: [
            SubCategory(id: '3-1', name: 'Groceries'),
            SubCategory(id: '3-2', name: 'Dining Out'),
            SubCategory(id: '3-3', name: 'Snacks & Drinks'),
          ],
        ),
        ExpenseCategory(
          id: '4',
          name: 'Utilities',
          subCategories: [
            SubCategory(id: '4-1', name: 'Electricity'),
            SubCategory(id: '4-2', name: 'Water & Sewer'),
            SubCategory(id: '4-3', name: 'Internet'),
            SubCategory(id: '4-4', name: 'Trash Collection'),
          ],
        ),
        ExpenseCategory(
          id: '5',
          name: 'Insurance',
          subCategories: [
            SubCategory(id: '5-1', name: 'Health Insurance'),
            SubCategory(id: '5-2', name: 'Life Insurance'),
            SubCategory(id: '5-3', name: 'Homeowners Insurance'),
            SubCategory(id: '5-4', name: 'Car Insurance'),
          ],
        ),
        ExpenseCategory(
          id: '6',
          name: 'Medical & Healthcare',
          subCategories: [
            SubCategory(id: '6-1', name: 'Doctor Visits'),
            SubCategory(id: '6-2', name: 'Prescription Medicine'),
            SubCategory(id: '6-3', name: 'Dental Care'),
            SubCategory(id: '6-4', name: 'Vision Care'),
          ],
        ),
        ExpenseCategory(
          id: '7',
          name: 'Saving & Investment',
          subCategories: [
            SubCategory(id: '7-1', name: 'Emergency Fund'),
            SubCategory(id: '7-2', name: 'Retirement Savings'),
            SubCategory(id: '7-3', name: 'Stocks & Mutual Funds'),
          ],
        ),
        ExpenseCategory(
          id: '8',
          name: 'Personal Spending',
          subCategories: [
            SubCategory(id: '8-1', name: 'Clothing'),
            SubCategory(id: '8-2', name: 'Salon & Spa'),
            SubCategory(id: '8-3', name: 'Subscriptions'),
          ],
        ),
        ExpenseCategory(
          id: '9',
          name: 'Entertainment',
          subCategories: [
            SubCategory(id: '9-1', name: 'Movies'),
            SubCategory(id: '9-2', name: 'Concerts'),
            SubCategory(id: '9-3', name: 'Streaming Services'),
            SubCategory(id: '9-4', name: 'Gaming'),
          ],
        ),
        ExpenseCategory(
          id: '10',
          name: 'Gifts & Donations',
          subCategories: [
            SubCategory(id: '10-1', name: 'Charity Donations'),
            SubCategory(id: '10-2', name: 'Birthday Gifts'),
            SubCategory(id: '10-3', name: 'Holiday Gifts'),
          ],
        ),
        ExpenseCategory(
          id: '11',
          name: 'Kids',
          subCategories: [
            SubCategory(id: '11-1', name: 'School Supplies'),
            SubCategory(id: '11-2', name: 'Childcare'),
            SubCategory(id: '11-3', name: 'Toys'),
          ],
        ),
        ExpenseCategory(
          id: '12',
          name: 'Pets',
          subCategories: [
            SubCategory(id: '12-1', name: 'Food & Treats'),
            SubCategory(id: '12-2', name: 'Vet Visits'),
            SubCategory(id: '12-3', name: 'Toys & Accessories'),
          ],
        ),
        ExpenseCategory(
          id: '13',
          name: 'Travel',
          subCategories: [
            SubCategory(id: '13-1', name: 'Flights'),
            SubCategory(id: '13-2', name: 'Accommodation'),
            SubCategory(id: '13-3', name: 'Local Transport'),
            SubCategory(id: '13-4', name: 'Tourist Attractions'),
          ],
        ),
        ExpenseCategory(
          id: '14',
          name: 'Education',
          subCategories: [
            SubCategory(id: '14-1', name: 'Tuition'),
            SubCategory(id: '14-2', name: 'Books'),
            SubCategory(id: '14-3', name: 'Online Courses'),
          ],
        ),
        ExpenseCategory(
          id: '15',
          name: 'Taxes',
          subCategories: [
            SubCategory(id: '15-1', name: 'Income Tax'),
            SubCategory(id: '15-2', name: 'Property Tax'),
          ],
        ),
        ExpenseCategory(
          id: '16',
          name: 'Business Services',
          subCategories: [
            SubCategory(id: '16-1', name: 'Software Subscriptions'),
            SubCategory(id: '16-2', name: 'Office Supplies'),
            SubCategory(id: '16-3', name: 'Freelance Work'),
          ],
        ),
      ];

      _tags = [
        Tag(id: '1', name: 'Breakfast'),
        Tag(id: '2', name: 'Lunch'),
        Tag(id: '3', name: 'Dinner'),
        Tag(id: '4', name: 'Treat'),
        Tag(id: '5', name: 'Cafe'),
        Tag(id: '6', name: 'Restaurant'),
        Tag(id: '7', name: 'Train'),
        Tag(id: '8', name: 'Vacation'),
        Tag(id: '9', name: 'Birthday'),
        Tag(id: '10', name: 'Diet'),
        Tag(id: '11', name: 'MovieNight'),
        Tag(id: '12', name: 'Tech'),
        Tag(id: '13', name: 'CarStuff'),
        Tag(id: '14', name: 'SelfCare'),
        Tag(id: '15', name: 'Streaming'),
      ];

      _saveToStorage();
      storage.setItem('isInitialized', true); // Set the flag
    } else {
      // Load existing data
      _loadFromStorage();
    }
  }

  // Getters
  List<Expense> get expenses => _expenses;
  List<ExpenseCategory> get categories => _categories;
  List<Tag> get tags => _tags;

  void _loadFromStorage() async {
    await storage.ready;
    final storedData = storage.getItem('appData');
    log('Loaded from local storage: $storedData');

    if (storedData != null) {
      try {
        final jsonData = jsonDecode(storedData);
        _expenses = (jsonData['expenses'] as List)
            .map((e) => Expense.fromJson(e))
            .toList();
        _categories = (jsonData['categories'] as List)
            .map((c) => ExpenseCategory.fromJson(c))
            .toList();
        _tags = (jsonData['tags'] as List).map((t) => Tag.fromJson(t)).toList();
        notifyListeners();
      } catch (e) {
        log('Error deserializing data: $e');
      }
    }
  }

  // Add an expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveToStorage();
    notifyListeners();
  }

  void _saveToStorage() {
    final data = {
      'expenses': _expenses.map((e) => e.toJson()).toList(),
      'categories': _categories.map((c) => c.toJson()).toList(),
      'tags': _tags.map((t) => t.toJson()).toList(),
    };

    final jsonData = jsonEncode(data);
    log('Saving to local storage: $jsonData');
    storage.setItem('appData', jsonData);
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      // Update existing expense
      _expenses[index] = expense;
    } else {
      // Add new expense
      _expenses.add(expense);
    }
    _saveToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Delete an expense
  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveToStorage(); // Save the updated list to local storage
    notifyListeners();
  }

  // Add a category
  void addCategory(ExpenseCategory category) {
    if (!_categories.any((cat) => cat.name == category.name)) {
      _categories.add(category);
      _saveToStorage();
      notifyListeners();
    }
  }

  // Delete a category
  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    _saveToStorage();
    notifyListeners();
  }

  // Add a tag
  void addTag(Tag tag) {
    if (!_tags.any((t) => t.name == tag.name)) {
      _tags.add(tag);
      _saveToStorage();
      notifyListeners();
    }
  }

  // Delete a tag
  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    _saveToStorage();
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveToStorage();
    notifyListeners();
  }

  String getCategoryNameById(String categoryId) {
    final category = _categories.firstWhere((cat) => cat.id == categoryId,
        orElse: () => ExpenseCategory(id: '', name: 'Unknown'));
    return category.name;
  }

  String getTagNameById(String tagId) {
    final tag = _tags.firstWhere((tag) => tag.id == tagId,
        orElse: () => Tag(id: '', name: 'Unknown'));
    return tag.name;
  }
}
