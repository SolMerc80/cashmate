import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/app_database.dart';
import 'core/database/category_dao.dart';
import 'core/database/transaction_dao.dart';

// ---------------------------------------------------------------------------
// Riverpod providers – expose the database and the two DAOs to the UI
// ---------------------------------------------------------------------------
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  final db = ref.read(databaseProvider);
  return CategoryDao(db);
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  final db = ref.read(databaseProvider);
  return TransactionDao(db);
});

// ---------------------------------------------------------------------------
// App entry point
// ---------------------------------------------------------------------------
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashMate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 14, 105, 17)),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('Home Page')),
    Center(child: Text('Search Page')),
    Center(child: Text('Settings Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CashMate'),
        backgroundColor: const Color.fromARGB(255, 14, 105, 17),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class AppBottomNavBar extends StatelessWidget{
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
     
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: "Home",
          ),
        
        NavigationDestination(
          icon: Icon(Icons.search),
          label: "Search",
        ),

        NavigationDestination(
          icon: Icon(Icons.settings),
          label: "Settings",
        )
      ]
    );
  }
}
