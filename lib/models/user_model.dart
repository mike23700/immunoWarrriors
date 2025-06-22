import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  static const keyId = 'id';

  final bool isOnline;
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final Map<String, dynamic>? gameData;

  AppUser({
    required this.id,
    required this.email,
    required this.isOnline,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.lastLoginAt,
    this.gameData,
  });

  // Create AppUser from Firebase User
  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      isOnline: false,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      lastLoginAt: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastLoginAt': lastLoginAt.millisecondsSinceEpoch,
      'gameData': gameData ?? {},
    };
  }

  // Create AppUser from Firestore data
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] as String,
      isOnline: map['isOnline'],
      displayName: map['displayName'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      lastLoginAt: DateTime.fromMillisecondsSinceEpoch(
        map['lastLoginAt'] as int,
      ),
      gameData: map['gameData'] as Map<String, dynamic>?,
    );
  }
}
