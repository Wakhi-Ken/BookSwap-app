import 'package:flutter/material.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool showOwner;

  const BookCard({required this.book, this.showOwner = false, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
      ),
      child: Card(
        color: Colors.white24, // semi-transparent card for dark theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with title overlay
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: book.imageUrl != null && book.imageUrl!.isNotEmpty
                        ? Image.network(
                            book.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                Icons.book,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  // Title overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      child: Text(
                        book.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'by ${book.author}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.condition,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Status: ${book.status}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  if (showOwner)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Owner ID: ${book.ownerId}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
