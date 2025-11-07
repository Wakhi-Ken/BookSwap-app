import 'package:flutter/material.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/repositories/swap_repository.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/services/firestore_service.dart';

class BookDetailScreen extends ConsumerWidget {
  final Book book;
  const BookDetailScreen({required this.book, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;
    final isOwner = user.uid == book.ownerId;
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          if (isOwner)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditBookScreen(book: book)),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (book.imageUrl != null) Image.network(book.imageUrl!),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('by ${book.author}'),
            Chip(label: Text(book.condition)),
            const SizedBox(height: 16),
            Text('Status: ${book.status}'),
            const SizedBox(height: 16),
            if (!isOwner)
              ElevatedButton(
                onPressed: book.status == 'available'
                    ? () async {
                        final repo = SwapRepository(
                          ref.read(firestoreServiceProvider),
                        );
                        await repo.createSwap(
                          bookId: book.id,
                          fromUserId: user.uid,
                          toUserId: book.ownerId,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Swap request sent')),
                        );
                      }
                    : null,
                child: const Text('Swap'),
              ),
          ],
        ),
      ),
    );
  }
}
