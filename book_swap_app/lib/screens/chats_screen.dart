import 'package:flutter/material.dart';
import 'package:book_swap_app/theme/app_theme.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // universal black
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 5, 4, 53),
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: const Center(
        child: Text(
          'Chats (bonus)',
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16),
        ),
      ),
    );
  }
}
