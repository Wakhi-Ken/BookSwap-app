import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'storage_service.dart';

class BookService {
  final StorageService _storage = StorageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveBook({required String title, File? coverFile}) async {
    final bookId = _firestore.collection('books').doc().id;

    String? coverUrl;
    if (coverFile != null) {
      coverUrl = await _storage.uploadBookImage(coverFile, bookId);
    }

    await _firestore.collection('books').doc(bookId).set({
      'title': title,
      'coverUrl': coverUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    print('✅ Book saved with ID $bookId, cover URL: $coverUrl');
  }
}
