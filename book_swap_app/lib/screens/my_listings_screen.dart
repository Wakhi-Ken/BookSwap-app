import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';
import 'package:book_swap_app/theme/app_theme.dart'; // import universal colors

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;
    final myBooksAsync = ref.watch(myBooksProvider(user.uid));

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // universal black
      appBar: AppBar(
        title: const Text(
          'My Listings',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 3, 46),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: myBooksAsync.when(
        data: (books) => books.isEmpty
            ? const Center(
                child: Text(
                  'No listings',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: books.length,
                itemBuilder: (c, i) =>
                    BookCard(book: books[i], showOwner: true),
              ),
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
    );
  }
}
