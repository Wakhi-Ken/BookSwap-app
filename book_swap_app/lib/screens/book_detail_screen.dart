import 'package:flutter/material.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/repositories/swap_repository.dart';
import 'package:book_swap_app/providers/book_providers.dart';

class BookDetailScreen extends ConsumerWidget {
  final Book book;
  const BookDetailScreen({required this.book, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;
    final isOwner = user.uid == book.ownerId;

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // universal black
      appBar: AppBar(
        title: Text(
          book.title,
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(255, 14, 3, 71),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 251, 255, 0)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(book.imageUrl!),
              ),
            const SizedBox(height: 8),
            Text(
              book.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'by ${book.author}',
              style: const TextStyle(
                color: Color.fromARGB(255, 22, 0, 0),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                book.condition,
                style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color.fromARGB(255, 8, 7, 0)),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${book.status}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            if (!isOwner)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 213, 228, 5),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                  child: const Text('Swap', style: TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
