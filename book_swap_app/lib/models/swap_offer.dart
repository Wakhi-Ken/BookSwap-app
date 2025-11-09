import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_swap_app/providers/book_providers.dart';
import 'package:book_swap_app/widgets/book_card.dart';
import 'package:book_swap_app/theme/app_theme.dart';
import 'package:book_swap_app/screens/edit_book_screen.dart';

// Simple model for swap offers used by the UI and Firestore helpers.
class SwapOffer {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String bookId;
  final String? offeredBookId;

  /// Constructor, fromMap, and toMap methods for Firestore serialization.
  SwapOffer({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.bookId,
    this.offeredBookId,
  });

  /// Factory constructor to create a SwapOffer from Firestore data
  factory SwapOffer.fromMap(String id, Map<String, dynamic> data) {
    return SwapOffer(
      id: id,
      fromUserId: data['fromUserId'] as String? ?? '',
      toUserId: data['toUserId'] as String? ?? '',
      bookId: data['bookId'] as String? ?? '',
      offeredBookId: data['offeredBookId'] as String?,
    );
  }

  /// Convert SwapOffer to a map for Firestore storage
  Map<String, dynamic> toMap() => {
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'bookId': bookId,
    if (offeredBookId != null) 'offeredBookId': offeredBookId,
  };
}

// Screen displaying the user's book listings with edit and delete options
class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser!;
    final myBooksAsync = ref.watch(myBooksProvider(user.uid));
    final db = ref.read(firestoreServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text(
          'My Listings',
          style: TextStyle(color: AppColors.blue),
        ),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.blue),
      ),
      body: myBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const Center(
              child: Text(
                'No listings',
                style: TextStyle(color: AppColors.blue, fontSize: 16),
              ),
            );
          }
          // Display books in a grid with edit/delete and pending swaps
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

                return Column(
                  children: [
                    Stack(
                      children: [
                        BookCard(book: book, showOwner: true),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Column(
                            children: [
                              // Edit button
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.blue,
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditBookScreen(book: book),
                                  ),
                                ),
                              ),
                              // Delete button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Delete Book'),
                                      content: const Text(
                                        'Are you sure you want to delete this book?',
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
                                    await db.deleteBook(book.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Book deleted successfully',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Pending swaps section
                    StreamBuilder<List<SwapOffer>>(
                      stream: db.pendingSwapsForBook(book.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final swaps = snapshot.data!;
                        return Column(
                          children: swaps.map((swap) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Swap request from: ${swap.fromUserId}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                        tooltip: 'Approve Swap',
                                        onPressed: () async {
                                          await db.approveSwap(swap);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Swap approved!'),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                        ),
                                        tooltip: 'Reject Swap',
                                        onPressed: () async {
                                          await db.rejectSwap(swap);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Swap rejected!'),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
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
          child: Text('Error: $e', style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
