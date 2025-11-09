import 'package:book_swap_app/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

/// Repository for managing book swaps
class SwapRepository {
  final FirestoreService _db;
  SwapRepository(this._db);

  /// Create a new swap request
  Future<String> createSwap({
    required String bookId,
    required String fromUserId,
    required String toUserId,
    String? message,
  }) async {
    final id = const Uuid().v4();
    final data = {
      'bookId': bookId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': 'pending',
      'message': message ?? '',
      'createdAt': DateTime.now(),
    };
    await _db.createSwap(id, data);
    return id;
  }

  /// Update the status of an existing swap
  Future<void> updateSwapStatus(String swapId, String status) async =>
      await _db.updateSwapStatus(swapId, status);
}
