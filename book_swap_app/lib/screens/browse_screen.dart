import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';
import 'package:book_swap_app/theme/app_theme.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to Firestore books stream
    final booksAsync = ref.watch(browseBooksProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // universal black
      appBar: AppBar(
        title: const Text(
          'Browse Listings',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 5, 54),
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: booksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text(
                'No books found 😔',
                style: TextStyle(color: Color.fromARGB(255, 229, 255, 0)),
              ),
            );
          }
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, i) => BookCard(book: books[i]),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        ),
        error: (e, s) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 25, 92),
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
