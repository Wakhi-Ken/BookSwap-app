import 'package:flutter/material.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool showOwner;
  const BookCard({required this.book, this.showOwner = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: book.imageUrl != null
            ? Image.network(book.imageUrl!, width: 56, fit: BoxFit.cover)
            : const Icon(Icons.book, size: 48),
        title: Text(book.title),
        subtitle: Text('${book.author} • ${book.condition}'),
        trailing: Text(book.status),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        ),
      ),
    );
  }
}
