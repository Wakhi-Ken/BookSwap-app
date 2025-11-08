import 'package:flutter/material.dart';
import 'package:book_swap_app/screens/browse_screen.dart';
import 'package:book_swap_app/screens/my_listings_screen.dart';
import 'package:book_swap_app/screens/chats_screen.dart';
import 'package:book_swap_app/screens/settings_screen.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // import universal colors

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.black,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: AppColors.blue,
        unselectedItemColor: Colors.white,
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
