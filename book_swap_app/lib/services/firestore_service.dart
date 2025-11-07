import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/models/swap_offer.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Books
  Stream<List<Book>> browseBooksStream() => _db
      .collection('books')
      .where('status', isEqualTo: 'available')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snap) => snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList(),
      );

  Stream<List<Book>> myBooksStream(String uid) => _db
      .collection('books')
      .where('ownerId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snap) => snap.docs.map((d) => Book.fromMap(d.id, d.data())).toList(),
      );

  Future<void> createBook(String id, Map<String, dynamic> data) async =>
      await _db.collection('books').doc(id).set(data);

  Future<void> updateBook(String id, Map<String, dynamic> data) async =>
      await _db.collection('books').doc(id).update(data);

  Future<void> deleteBook(String id) async =>
      await _db.collection('books').doc(id).delete();

  // Swaps
  Stream<List<SwapOffer>> swapsForUser(String uid) => _db
      .collection('swaps')
      .where('toUserId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((d) => SwapOffer.fromMap(d.id, d.data())).toList(),
      );

  Stream<List<SwapOffer>> myOffersByUser(String uid) => _db
      .collection('swaps')
      .where('fromUserId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((d) => SwapOffer.fromMap(d.id, d.data())).toList(),
      );

  Future<void> createSwap(String id, Map<String, dynamic> data) async {
    final swapRef = _db.collection('swaps').doc(id);
    final bookRef = _db.collection('books').doc(data['bookId']);
    await _db.runTransaction((tx) async {
      tx.set(swapRef, data);
      tx.update(bookRef, {'status': 'pending', 'currentSwapId': id});
    });
  }

  Future<void> updateSwapStatus(String swapId, String status) async {
    final swapRef = _db.collection('swaps').doc(swapId);
    final snap = await swapRef.get();
    if (!snap.exists) return;
    final swap = SwapOffer.fromMap(snap.id, snap.data()!);
    final bookRef = _db.collection('books').doc(swap.bookId);
    await _db.runTransaction((tx) async {
      tx.update(swapRef, {'status': status});
      if (status == 'accepted') {
        tx.update(bookRef, {'status': 'swapped', 'currentSwapId': null});
      } else if (status == 'rejected' || status == 'cancelled') {
        tx.update(bookRef, {'status': 'available', 'currentSwapId': null});
      }
    });
  }
}
