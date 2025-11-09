import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String ownerId;
  final String title;
  final String author;
  final String condition; // New, Like New, Good, Used
  final String? imageUrl; // renamed for clarity
  final String status; // available, pending, swapped
  final String? currentSwapId;
  final Timestamp createdAt;

  Book({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    required this.condition,
    this.imageUrl,
    this.status = 'available',
    this.currentSwapId,
    required this.createdAt,
  });

  // Factory to create Book from Firestore document
  factory Book.fromMap(String id, Map<String, dynamic> m) => Book(
    id: id,
    ownerId: m['ownerId'] ?? '',
    title: m['title'] ?? '',
    author: m['author'] ?? '',
    condition: m['condition'] ?? 'Used',
    imageUrl: m['imageUrl'], // image from Storage
    status: m['status'] ?? 'available',
    currentSwapId: m['currentSwapId'],
    createdAt: m['createdAt'] ?? Timestamp.now(),
  );

  // Convert to Firestore map
  Map<String, dynamic> toMap() => {
    'ownerId': ownerId,
    'title': title,
    'author': author,
    'condition': condition,
    'imageUrl': imageUrl,
    'status': status,
    'currentSwapId': currentSwapId,
    'createdAt': createdAt,
  };
}
