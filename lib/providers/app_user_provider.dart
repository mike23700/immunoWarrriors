import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:immuno_warriors/models/caracter_model.dart';
import 'package:immuno_warriors/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDocumentProvider = StreamProvider.family<AppUser, String>((
  ref,
  userId,
) {
  // `ref.onDispose` est appelé lorsque le provider n'est plus écouté
  // ce qui ferme automatiquement le stream Firestore
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots() // Écoute les changements en temps réel
      .map((snapshot) {
        // Traitez le snapshot pour créer votre modèle de données
        if (!snapshot.exists) {
          // Gérer le cas où le document n'existe pas
          // Vous pouvez lancer une exception ou retourner un UserModel par défaut
          throw Exception('Document utilisateur avec ID $userId non trouvé.');
        }
        return AppUser.fromMap(snapshot.data() as Map<String, dynamic>);
      });
});

List<UserAppCharacter> getUserAppCharacters(
  AppUser user,
  bool areProtectors,
  bool onlyComplete,
) {
  late final List<AppCharacter> agents;
  late final String agentsType;
  if (areProtectors) {
    agents = FirestoreInitializer().protectors;
    agentsType = 'protectors';
  } else {
    agents = FirestoreInitializer().pathogens;
    agentsType = 'pathogenes';
  }
  final maps = user.gameData?[agentsType];
  List<UserAppCharacter> progressChars = [];
  AppCharacter char;
  int id, progression, quantity;

  for (var map in maps) {
    id = map['id'] ?? -1;
    progression = map['progression'] ?? -1;
    quantity = map['quantity'] ?? -1;

    if (id != -1 && progression != -1 && quantity != -1) {
      if ((onlyComplete ? progression == 4 : true)) {
        char = agents[id];
        progressChars.add(
          UserAppCharacter(char, progression: progression, quantity: quantity),
        );
      }
    }
  }
  return progressChars;
}
