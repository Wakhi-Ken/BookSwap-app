import 'package:book_swap_app/providers/book_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/models/swap_offer.dart';
import 'package:book_swap_app/screens/book_detail_screen.dart';

/// Widget to display a book card with image, title, author, condition, status, and swap requests.
class BookCard extends ConsumerStatefulWidget {
  final Book book;
  final bool showOwner;

  /// Constructor for BookCard
  const BookCard({required this.book, this.showOwner = false, super.key});

  @override
  ConsumerState<BookCard> createState() => _BookCardState();
}

/// State class for BookCard
class _BookCardState extends ConsumerState<BookCard> {
  bool _swapsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final db = ref.read(firestoreServiceProvider);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BookDetailScreen(book: widget.book)),
      ),
      child: Card(
        color: Colors.white24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child:
                        widget.book.imageUrl != null &&
                            widget.book.imageUrl!.isNotEmpty
                        ? Image.network(
                            widget.book.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) =>
                                progress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
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
                        widget.book.title,
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
            // Book info & swaps toggle
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'by ${widget.book.author}',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.book.condition,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Status: ${widget.book.status}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                  if (widget.showOwner)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Owner ID: ${widget.book.ownerId}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  // Swap requests
                  StreamBuilder<List<SwapOffer>>(
                    stream: db.pendingSwapsForBook(widget.book.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty)
                        return const SizedBox.shrink();

                      final swaps = snapshot.data!;
                      print(
                        'Pending swaps count: ${swaps.length}',
                      ); // Debugging line

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => setState(
                              () => _swapsExpanded = !_swapsExpanded,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pending swaps (${swaps.length})',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  _swapsExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          if (_swapsExpanded)
                            ...swaps.map((swap) {
                              return Card(
                                color: Colors.white10,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                child: ListTile(
                                  title: Text(
                                    'Swap from ${swap.fromUserId}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Offered Book ID: ${swap.offeredBookId}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await db.approveSwap(swap);
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Swap approved',
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text('Failed: $e'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          try {
                                            await db.rejectSwap(swap);
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Swap rejected',
                                                  ),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text('Failed: $e'),
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
                              );
                            }).toList(),
                        ],
                      );
                    },
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
