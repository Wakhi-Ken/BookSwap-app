import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/services/firestore_service.dart';
import 'package:book_swap_app/models/book.dart';

// Firestore service provider
final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);

// Stream of all books (for Browse screen)
final browseBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(firestoreServiceProvider);
  return db.browseBooksStream();
});

// Stream of user-specific books (for My Books)
final myBooksProvider = StreamProvider.family<List<Book>, String>((ref, uid) {
  final db = ref.watch(firestoreServiceProvider);
  return db.myBooksStream(uid);
});
