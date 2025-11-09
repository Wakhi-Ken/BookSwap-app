import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';
import 'package:book_swap_app/theme/app_theme.dart';

/// Screen to browse all book listings
class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(browseBooksProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF00032E),
      appBar: AppBar(
        title: const Text(
          'Browse Listings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00032E),
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: booksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text(
                'No books found 😔',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }
          // Display books in a grid
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: books.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCard(book: book);
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        ),
        error: (e, s) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF04195C),
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
