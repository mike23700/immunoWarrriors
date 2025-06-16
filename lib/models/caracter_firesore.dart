import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immuno_warriors/models/caracter_model.dart';
import 'package:immuno_warriors/models/user_model.dart'; // Assurez-vous d'avoir votre modèle AppUser

class UserDocumentListener {
  late final String? userId;
  late final DocumentReference<Map<String, dynamic>> docRef;
  bool _exit = false;
  AppUser? _userData;
  DocumentSnapshot get docSnapshot => docRef.get() as DocumentSnapshot<Object?>;

  //getters
  bool get exit => _exit;
  AppUser? get userData => _userData;

  UserDocumentListener(String? id) {
    // Récupérer l'ID d'un l'utilisateur
    userId = id ?? FirebaseAuth.instance.currentUser?.uid ?? '';
    // Récupérer la reference d'un l'utilisateur
    docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    //verifier l'existance de ce document
    try {
      _exit = (docSnapshot.exists) ? true : false;
    } catch (e) {
      _exit = false;
    }
  }

  Future<List<ProgressAppCharacter>> getProgessAppCharacters() async {
    List<ProgressAppCharacter> progressChars = [];
    List<Map<String, int>> list = userData?.gameData?['protectors'];
    AppCharacter char;
    int id, progress;

    for (var map in list) {
      id = map['id'] ?? -1;
      progress = map['progress'] ?? -1;

      if (id != -1 && progress != -1) {
        char = AppCharacter.fromMap(
          (await FirebaseFirestore.instance
                  .collection('agents_protecteurs')
                  .doc('$id')
                  .get())
              as Map<String, dynamic>,
        );

        progressChars.add(ProgressAppCharacter(char, progress));
      }
    }

    return progressChars;
  }
}
