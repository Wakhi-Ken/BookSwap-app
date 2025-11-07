import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';

class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;
    final myBooksAsync = ref.watch(myBooksProvider(user.uid));
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: myBooksAsync.when(
        data: (books) => books.isEmpty
            ? const Center(child: Text('No listings'))
            : ListView.builder(
                itemCount: books.length,
                itemBuilder: (c, i) =>
                    BookCard(book: books[i], showOwner: true),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
