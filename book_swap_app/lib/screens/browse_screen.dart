import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // import universal colors

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(browseBooksProvider);

    return Scaffold(
      backgroundColor: AppColors.black, // universal black
      appBar: AppBar(
        title: const Text(
          'Browse Listings',
          style: TextStyle(color: AppColors.blue),
        ),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: booksAsync.when(
        data: (books) => ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, i) => BookCard(book: books[i]),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        ),
        error: (e, s) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EditBookScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
