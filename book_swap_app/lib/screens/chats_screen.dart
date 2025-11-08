import 'package:flutter/material.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // import colors

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black, // universal black
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(color: AppColors.blue)),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: const Center(
        child: Text(
          'Chats (bonus)',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
