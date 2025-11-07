import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final Map<String, dynamic> notificationPrefs;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    Map<String, dynamic>? notificationPrefs,
  }) : notificationPrefs = notificationPrefs ?? {'newOffer': true};

  factory UserProfile.fromMap(String id, Map<String, dynamic> m) => UserProfile(
    uid: id,
    displayName: m['displayName'] ?? '',
    email: m['email'] ?? '',
    photoUrl: m['photoUrl'],
    notificationPrefs: m['notificationPrefs'] ?? {'newOffer': true},
  );

  Map<String, dynamic> toMap() => {
    'displayName': displayName,
    'email': email,
    'photoUrl': photoUrl,
    'notificationPrefs': notificationPrefs,
  };
}
