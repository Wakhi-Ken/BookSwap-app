import 'dart:io';
import 'package:book_swap_app/services/firestore_service.dart';
import 'package:book_swap_app/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class BookRepository {
  final FirestoreService _db;
  final StorageService _storage;

  BookRepository(this._db, this._storage);

  Future<String> createBook({
    required String ownerId,
    required String title,
    required String author,
    required String condition,
    File? imageFile,
  }) async {
    final id = const Uuid().v4();
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _storage.uploadBookImage(imageFile, id);
    }
    final data = {
      'ownerId': ownerId,
      'title': title,
      'author': author,
      'condition': condition,
      'imageUrl': imageUrl,
      'status': 'available',
      'currentSwapId': null,
      'createdAt': DateTime.now(),
    };
    await _db.createBook(id, data);
    return id;
  }

  Future<void> updateBook(String id, Map<String, dynamic> data) async =>
      await _db.updateBook(id, data);

  Future<void> deleteBook(String id) async => await _db.deleteBook(id);
}
