import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_swap_app/models/book.dart';
import 'package:book_swap_app/models/swap_offer.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Service class for Firestore interactions
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  Future<void> createBook(Book book) async {
    try {
      await _db.collection('books').doc(book.id).set(book.toMap());
    } catch (e) {
      print('Error creating book: $e');
    }
  }

  Future<void> updateBook(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('books').doc(id).update(data);
    } catch (e) {
      print('Error updating book: $e');
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      await _db.collection('books').doc(id).delete();
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  // --------------------
  // Swaps
  // --------------------

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

  Stream<List<SwapOffer>> pendingSwapsForBook(String bookId) => _db
      .collection('swaps')
      .where('bookId', isEqualTo: bookId)
      .where('status', isEqualTo: 'pending')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((d) => SwapOffer.fromMap(d.id, d.data())).toList(),
      );

  Future<void> createSwap(String swapId, Map<String, dynamic> data) async {
    final swapRef = _db.collection('swaps').doc(swapId);
    final bookRef = _db.collection('books').doc(data['bookId']);

    await _db.runTransaction((tx) async {
      tx.set(swapRef, data);
      tx.update(bookRef, {'status': 'pending', 'currentSwapId': swapId});
    });
  }

  Future<void> approveSwap(SwapOffer swap) async {
    final swapRef = _db.collection('swaps').doc(swap.id);
    final bookRef = _db.collection('books').doc(swap.bookId);

    await _db.runTransaction((tx) async {
      tx.update(swapRef, {'status': 'accepted'});
      tx.update(bookRef, {'status': 'swapped', 'currentSwapId': null});
    });
  }

  Future<void> rejectSwap(SwapOffer swap) async {
    final swapRef = _db.collection('swaps').doc(swap.id);
    final bookRef = _db.collection('books').doc(swap.bookId);

    await _db.runTransaction((tx) async {
      tx.update(swapRef, {'status': 'rejected'});
      tx.update(bookRef, {'status': 'available', 'currentSwapId': null});
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

  Future<void> deleteBookWithSwaps(String bookId) async {
    final bookRef = _db.collection('books').doc(bookId);

    try {
      // Get the book document
      final bookSnapshot = await bookRef.get();
      if (!bookSnapshot.exists) {
        throw Exception('Book with ID $bookId does not exist.');
      }

      // Delete book image from Storage if exists
      final bookData = bookSnapshot.data();
      if (bookData != null && bookData['imageUrl'] != null) {
        try {
          await FirebaseStorage.instance
              .refFromURL(bookData['imageUrl'])
              .delete();
        } catch (e) {
          print('Failed to delete book image: $e');
        }
      }

      // Get all swaps related to this book
      final swapsSnapshot = await _db
          .collection('swaps')
          .where('bookId', isEqualTo: bookId)
          .get();

      // Use a batch to delete book + swaps atomically
      final batch = _db.batch();

      batch.delete(bookRef);

      for (final doc in swapsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('Book and related swaps successfully deleted.');
    } catch (e) {
      print('Error deleting book and swaps: $e');
      rethrow;
    }
  }
}
