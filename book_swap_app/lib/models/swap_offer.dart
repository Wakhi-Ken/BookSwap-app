import 'package:cloud_firestore/cloud_firestore.dart';

class SwapOffer {
  final String id;
  final String bookId;
  final String fromUserId;
  final String toUserId;
  final String status; // pending, accepted, rejected, cancelled
  final Timestamp createdAt;

  SwapOffer({
    required this.id,
    required this.bookId,
    required this.fromUserId,
    required this.toUserId,
    this.status = 'pending',
    required this.createdAt,
  });

  factory SwapOffer.fromMap(String id, Map<String, dynamic> m) => SwapOffer(
    id: id,
    bookId: m['bookId'] ?? '',
    fromUserId: m['fromUserId'] ?? '',
    toUserId: m['toUserId'] ?? '',
    status: m['status'] ?? 'pending',
    createdAt: m['createdAt'] ?? Timestamp.now(),
  );

  Map<String, dynamic> toMap() => {
    'bookId': bookId,
    'fromUserId': fromUserId,
    'toUserId': toUserId,
    'status': status,
    'createdAt': createdAt,
  };
}
