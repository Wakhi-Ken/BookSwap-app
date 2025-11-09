import 'dart:io';
import 'package:book_swap_app/services/firestore_service.dart';
import 'package:book_swap_app/services/storage_service.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookRepository {
  final FirestoreService _db;
  final StorageService _storage;

  BookRepository(this._db, this._storage);

  /// Create a new book with optional image upload
  Future<String> createBook({
    required String ownerId,
    required String title,
    required String author,
    required String condition,
    File? imageFile,
    String? imageUrl,
  }) async {
    // Generate unique ID
    final id = const Uuid().v4();

    // Upload image to Firebase Storage if provided
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _storage.uploadBookImage(imageFile, id);
    }

    // Create Book object
    final book = Book(
      id: id,
      ownerId: ownerId,
      title: title,
      author: author,
      condition: condition,
      imageUrl: imageUrl,
      status: 'available',
      currentSwapId: null,
      createdAt: Timestamp.now(),
    );

    // Save to Firestore
    await _db.createBook(book);

    return id;
  }

  /// Update an existing book
  Future<void> updateBook(String id, Map<String, dynamic> data) async =>
      await _db.updateBook(id, data);

  /// Delete a book
  Future<void> deleteBook(String id) async => await _db.deleteBook(id);
}
