import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadBookImage(File file, String id) async {
    final ref = _storage.ref().child('book_covers/$id.jpg');
    final task = await ref.putFile(file);
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<void> deleteBookImage(String storagePath) async {
    try {
      await _storage.refFromURL(storagePath).delete();
    } catch (_) {}
  }
}
