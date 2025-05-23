import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show TaskState, FirebaseStorage;
import 'package:path/path.dart' as path;
import '../models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  
  // Clés pour le stockage local
  static const String _userProfileKey = 'user_profile';
  
  UserProfile? get userProfile => _userProfile;
  
  // Initialiser le profil utilisateur
  Future<void> initialize() async {
    if (_auth.currentUser != null) {
      await _loadUserProfile();
    }
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _loadUserProfile();
      } else {
        _userProfile = null;
        notifyListeners();
      }
    });
  }
  
  // Charger le profil utilisateur
  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userProfileKey);
      
      debugPrint('Données brutes du profil: $userData');
      
      if (userData != null && userData.isNotEmpty) {
        try {
          // Essayer de parser la chaîne JSON
          final Map<String, dynamic> userMap = jsonDecode(userData);
          _userProfile = UserProfile.fromMap(userMap);
          debugPrint('Profil chargé: ${_userProfile?.toMap()}');
        } catch (e) {
          debugPrint('Erreur lors du parsing du profil: $e');
          // En cas d'erreur, créer un nouveau profil
          _createNewProfileFromFirebaseUser();
        }
      } else if (_auth.currentUser != null) {
        _createNewProfileFromFirebaseUser();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors du chargement du profil: $e');
      rethrow;
    }
  }
  
  // Créer un nouveau profil à partir de l'utilisateur Firebase
  Future<void> _createNewProfileFromFirebaseUser() async {
    if (_auth.currentUser != null) {
      _userProfile = UserProfile.fromFirebaseUser(_auth.currentUser!);
      debugPrint('Nouveau profil créé: ${_userProfile?.toMap()}');
      await _saveUserProfile();
    }
  }
  
  // Sauvegarder le profil utilisateur
  Future<void> _saveUserProfile() async {
    if (_userProfile == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final userMap = _userProfile!.toMap();
      final userJson = jsonEncode(userMap);
      debugPrint('Sauvegarde du profil: $userJson');
      await prefs.setString(_userProfileKey, userJson);
      debugPrint('Profil sauvegardé avec succès');
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde du profil: $e');
      rethrow;
    }
  }
  
  // Mettre à jour le nom d'affichage
  Future<void> updateDisplayName(String newName) async {
    if (_userProfile == null || newName.isEmpty) return;
    
    _userProfile = _userProfile!.copyWith(displayName: newName);
    await _saveUserProfile();
    
    // Mettre à jour le profil Firebase si nécessaire
    await _auth.currentUser?.updateDisplayName(newName);
  }
  
  // Changer la photo de profil
  Future<void> changeProfileImage(ImageSource source) async {
    try {
      debugPrint('Début du changement de photo de profil');
      
      // Vérifier si l'utilisateur est connecté
      if (_userProfile == null) {
        debugPrint('Erreur: Aucun utilisateur connecté');
        return;
      }
      
      // Sélectionner une image
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );
      
      if (pickedFile == null) {
        debugPrint('Aucune image sélectionnée');
        return;
      }
      
      debugPrint('Image sélectionnée: ${pickedFile.path}');
      
      // Télécharger l'image vers Firebase Storage
      try {
        final file = File(pickedFile.path);
        final fileName = 'profile_${_userProfile!.uid}${path.extension(pickedFile.path)}';
        final ref = _storage.ref().child('profile_images/$fileName');
        
        debugPrint('Téléchargement de l\'image vers Firebase Storage...');
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() {});
        
        if (snapshot.state == TaskState.success) {
          debugPrint('Image téléchargée avec succès');
          final downloadUrl = await ref.getDownloadURL();
          debugPrint('URL de téléchargement: $downloadUrl');
          
          // Mettre à jour le profil
          _userProfile = _userProfile!.copyWith(
            photoUrl: downloadUrl,
            defaultAvatarIndex: -1, // -1 pour indiquer une photo personnalisée
          );
          
          debugPrint('Mise à jour du profil avec la nouvelle photo');
          await _saveUserProfile();
          debugPrint('Profil mis à jour avec succès');
        } else {
          debugPrint('Échec du téléchargement de l\'image: ${snapshot.state}');
        }
      } catch (e) {
        debugPrint('Erreur lors du téléchargement de l\'image: $e');
        rethrow;
      }
    } catch (e) {
      debugPrint('Erreur lors du changement de photo de profil: $e');
      rethrow;
    }
  }
  
  // Sélectionner un avatar par défaut
  Future<void> selectDefaultAvatar(int index) async {
    if (_userProfile == null || index < 0 || index > 2) return;
    
    _userProfile = _userProfile!.copyWith(
      defaultAvatarIndex: index,
      photoUrl: null, // Effacer l'URL de la photo personnalisée
    );
    
    await _saveUserProfile();
  }
  
  // Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userProfileKey);
    _userProfile = null;
    notifyListeners();
  }
}

// Extension pour faciliter la copie des objets UserProfile
extension UserProfileExtension on UserProfile {
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
