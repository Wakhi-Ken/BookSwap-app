import 'package:cloud_firestore/cloud_firestore.dart';

/// UserProfile model representing a user's profile in the swap application
class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final Map<String, dynamic> notificationPrefs;
  final DateTime createdAt;

  /// Constructor for UserProfile model
  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    Map<String, dynamic>? notificationPrefs,
    DateTime? createdAt,
  }) : notificationPrefs = notificationPrefs ?? {'newOffer': true},
       createdAt = createdAt ?? DateTime.now();

  /// Factory constructor for creating from Firestore map
  factory UserProfile.fromMap(String id, Map<String, dynamic> map) {
    return UserProfile(
      uid: id,
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      notificationPrefs: map['notificationPrefs'] ?? {'newOffer': true},
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert object to Firestore-friendly map
  Map<String, dynamic> toMap() => {
    'displayName': displayName,
    'email': email,
    'photoUrl': photoUrl,
    'notificationPrefs': notificationPrefs,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
