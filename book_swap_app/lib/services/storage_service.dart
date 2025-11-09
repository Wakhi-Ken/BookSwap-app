import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadBookImage(File imageFile, String bookId) async {
    if (!imageFile.existsSync()) {
      throw Exception('File does not exist: ${imageFile.path}');
    }

    final fileName = path.basename(imageFile.path);
    final storageRef = _storage.ref().child('book_covers/$bookId/$fileName');

    // Await the upload properly
    final snapshot = await storageRef.putFile(imageFile);

    // Then get download URL
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('✅ File uploaded: $downloadUrl');
    return downloadUrl;
  }
}

Future<void> saveBook(File? coverFile, String title) async {
  final storage = StorageService();

  // Generate Firestore doc ID
  final bookId = FirebaseFirestore.instance.collection('books').doc().id;

  String? coverUrl;

  if (coverFile != null) {
    coverUrl = await storage.uploadBookImage(coverFile, bookId);
  }

  // Save to Firestore
  await FirebaseFirestore.instance.collection('books').doc(bookId).set({
    'title': title,
    'coverUrl': coverUrl ?? '',
    'createdAt': FieldValue.serverTimestamp(),
  });

  print('✅ Book saved with ID $bookId, cover URL: $coverUrl');
}
