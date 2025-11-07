import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_swap_app/services/firestore_service.dart';
import 'package:book_swap_app/models/book.dart';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(),
);
final browseBooksProvider = StreamProvider<List<Book>>((ref) {
  final db = ref.watch(firestoreServiceProvider);
  return db.browseBooksStream();
});

final myBooksProvider = StreamProvider.family<List<Book>, String>((ref, uid) {
  final db = ref.watch(firestoreServiceProvider);
  return db.myBooksStream(uid);
});
