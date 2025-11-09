import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'storage_service.dart';

class BookService {
  final StorageService _storage = StorageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save a new book entry into Firestore and upload its image (if provided)
  Future<String> saveBook({
    required String title,
    required String author,
    required String condition,
    required String ownerId,
    required String currentSwapId,
    String status = 'pending',
    File? coverFile,
  }) async {
    final bookDoc = _firestore.collection('books').doc();
    String? coverUrl;

    // Upload image if file exists
    if (coverFile != null && coverFile.existsSync()) {
      coverUrl = await _storage.uploadBookImage(coverFile, bookDoc.id);
    } else if (coverFile != null && !coverFile.existsSync()) {
      print('⚠️ Provided image file does not exist: ${coverFile.path}');
    }

    // Save book details to Firestore
    await bookDoc.set({
      'title': title,
      'author': author,
      'condition': condition,
      'ownerId': ownerId,
      'currentSwapId': currentSwapId,
      'status': status,
      'imageUrl': coverUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('✅ Book saved with ID: ${bookDoc.id}');
    if (coverUrl != null && coverUrl.isNotEmpty) {
      print('📸 Image uploaded: $coverUrl');
    }

    return bookDoc.id;
  }
}
