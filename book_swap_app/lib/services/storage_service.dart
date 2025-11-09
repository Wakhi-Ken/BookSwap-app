import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadBookImage(File? imageFile, String bookId) async {
    // Handle null safely
    if (imageFile == null) {
      print('⚠️ No image selected — skipping upload.');
      return null;
    }

    // Ensure file exists before upload
    if (!imageFile.existsSync()) {
      print('⚠️ File does not exist: ${imageFile.path}');
      return null;
    }

    try {
      // Create proper storage path
      final fileName = path.basename(imageFile.path);
      final storageRef = _storage.ref().child('book_covers/$bookId/$fileName');

      // Upload file
      final uploadTask = await storageRef.putFile(imageFile);

      // Retrieve download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      print('✅ File uploaded successfully: $downloadUrl');

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('❌ Firebase upload error: ${e.code} — ${e.message}');
      return null;
    } catch (e) {
      print('❌ Unexpected upload error: $e');
      return null;
    }
  }
}

/// Save book details into Firestore
Future<void> saveBook({
  required String title,
  required String author,
  required String condition,
  required String ownerId,
  required String currentSwapId,
  String status = 'pending',
  File? imageFile,
}) async {
  final storage = StorageService();
  final booksCollection = FirebaseFirestore.instance.collection('books');
  final bookDoc = booksCollection.doc(); // Generate Firestore doc ID

  String? imageUrl;

  // Upload image if provided
  try {
    imageUrl = await storage.uploadBookImage(imageFile, bookDoc.id);
  } catch (e) {
    print('⚠️ Image upload failed: $e');
  }

  // Save to Firestore
  try {
    await bookDoc.set({
      'title': title,
      'author': author,
      'condition': condition,
      'ownerId': ownerId,
      'currentSwapId': currentSwapId,
      'status': status,
      'imageUrl': imageUrl, // might be null
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('✅ Book saved with ID: ${bookDoc.id}, imageUrl: $imageUrl');
  } on FirebaseException catch (e) {
    print('❌ Firestore save error: ${e.code} — ${e.message}');
  } catch (e) {
    print('❌ Unexpected Firestore error: $e');
  }
}
