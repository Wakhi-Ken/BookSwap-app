import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a book image to Firebase Storage and return its download URL.
  Future<String?> uploadBookImage(File? imageFile, String bookId) async {
    if (imageFile == null) {
      print('⚠️ No image selected — skipping upload.');
      return null;
    }

    if (!imageFile.existsSync()) {
      print('⚠️ File does not exist: ${imageFile.path}');
      return null;
    }

    try {
      final fileName = path.basename(imageFile.path);
      final storageRef = _storage.ref().child('book_covers/$bookId/$fileName');

      final uploadTask = await storageRef.putFile(imageFile);

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      print('✅ Image uploaded successfully: $downloadUrl');

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
