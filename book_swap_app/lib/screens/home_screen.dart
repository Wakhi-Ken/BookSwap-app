import 'package:flutter/material.dart';
import 'package:book_swap_app/screens/browse_screen.dart';
import 'package:book_swap_app/screens/my_listings_screen.dart';
import 'package:book_swap_app/screens/chats_screen.dart';
import 'package:book_swap_app/screens/settings_screen.dart';

/// Home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  final _pages = const [
    BrowseScreen(),
    MyListingsScreen(),
    ChatsScreen(),
    SettingsScreen(),
  ];

  /// Builds the HomeScreen UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 6, 8, 77),
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: const Color.fromARGB(255, 206, 206, 7),
        unselectedItemColor: const Color.fromARGB(255, 95, 91, 91),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Listings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
