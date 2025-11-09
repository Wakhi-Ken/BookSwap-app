import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';
import 'package:book_swap_app/theme/app_theme.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';

/// Screen to display user's book listings
class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;
    final myBooksAsync = ref.watch(myBooksProvider(user.uid));
    final db = ref.read(firestoreServiceProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 3, 46),
      appBar: AppBar(
        title: const Text('My Listings', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 3, 46),
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: myBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text(
                'No listings',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }

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

                return Stack(
                  children: [
                    BookCard(book: book, showOwner: true),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Column(
                        children: [
                          // Edit button
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.blue),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditBookScreen(book: book),
                              ),
                            ),
                          ),
                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Delete Book'),
                                  content: const Text(
                                    'Are you sure you want to delete this book and all related swaps?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed ?? false) {
                                // Show loading indicator
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.blue,
                                    ),
                                  ),
                                );

                                try {
                                  await db.deleteBookWithSwaps(book.id);

                                  Navigator.pop(context); // remove loader
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Book and related swaps deleted successfully',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  Navigator.pop(context); // remove loader
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Failed to delete book: $e',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.blue),
        ),
        error: (e, s) => Center(
          child: Text(
            'Error: $e',
            style: const TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
          ),
        ),
      ),
    );
  }
}
