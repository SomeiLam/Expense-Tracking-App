import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'providers/expense_provider.dart';
import 'screens/category_management_screen.dart';
import 'screens/home_screen.dart';
import 'screens/tag_management_screen.dart';

final LocalStorage localStorage = LocalStorage('expense_tracker_app');

Future<void> initLocalStorage() async {
  await localStorage.ready;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(ExpenseTrackerApp(localStorage: localStorage));
}

class ExpenseTrackerApp extends StatelessWidget {
  final LocalStorage localStorage;

  const ExpenseTrackerApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider(localStorage)),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple.shade200,
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            elevation: 4.0,
            shadowColor: Theme.of(context).colorScheme.shadow,
            backgroundColor: Colors.deepPurple.shade300, // Set the desired AppBar background color
            foregroundColor: Colors.white, // Optional: Set the text/icon color
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Main entry point, HomeScreen
          '/manage_categories': (context) =>
              CategoryManagementScreen(), // Route for managing categories
          '/manage_tags': (context) =>
              TagManagementScreen(), // Route for managing tags
        },
        // Removed 'home:' since 'initialRoute' is used to define the home route
      ),
    );
  }
}