import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProfile {
  final String uid;
  String displayName;
  String email;
  String? photoUrl;
  int defaultAvatarIndex; // Index de l'avatar par défaut (0-2) ou -1 si photo personnalisée

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.defaultAvatarIndex = 0, // Par défaut, utiliser le premier avatar
  });

  // Convertir l'objet en Map pour le stockage
  Map<String, dynamic> toMap() {
    try {
      final map = <String, dynamic>{
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'defaultAvatarIndex': defaultAvatarIndex,
      };
      
      // Ne pas ajouter photoUrl s'il est null
      if (photoUrl != null && photoUrl!.isNotEmpty) {
        map['photoUrl'] = photoUrl;
      }
      
      if (kDebugMode) {
        print('Conversion en Map réussie: $map');
      }
      return map;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la conversion en Map: $e');
      }
      rethrow;
    }
  }

  // Créer un objet UserProfile à partir d'une Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      defaultAvatarIndex: map['defaultAvatarIndex'] ?? 0,
    );
  }

  // Créer un utilisateur à partir des informations Firebase
  factory UserProfile.fromFirebaseUser(User user) {
    return UserProfile(
      uid: user.uid,
      displayName: user.displayName ?? user.email?.split('@')[0] ?? 'Utilisateur',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  // Obtenir l'URL de la photo de profil
  String getProfileImageUrl() {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return photoUrl!;
    }
    // Retourner l'URL de l'avatar par défaut
    return 'assets/images/avatar_$defaultAvatarIndex.png';
  }

  // Créer une copie de l'objet avec des valeurs mises à jour
  UserProfile copyWith({
    String? displayName,
    String? email,
    String? photoUrl,
    int? defaultAvatarIndex,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      defaultAvatarIndex: defaultAvatarIndex ?? this.defaultAvatarIndex,
    );
  }

}
