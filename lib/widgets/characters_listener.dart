import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:immuno_warriors/models/caracter_model.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class CharactersListener extends StatefulWidget {
  final bool protectors;
  final bool onlyComplete;
  final Widget Function(List<ProgressAppCharacter>) builder;

  late final String agentsType;
  late final String collectionPath;

  //constructeur
  CharactersListener(
    this.builder, {
    super.key,
    required this.protectors,
    this.onlyComplete = false,
  }) {
    if (protectors) {
      collectionPath = 'agents_protecteurs';
      agentsType = 'protectors';
    } else {
      collectionPath = 'agents_pathogenes';
      agentsType = 'pathogenes';
    }
  }

  @override
  State<CharactersListener> createState() => _CharactersListenerState();
}

class _CharactersListenerState extends State<CharactersListener> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid ?? ''; //'bobo'

  Future<List<ProgressAppCharacter>> getProgessAppCharacters(
    List<Map<String, dynamic>> list,
  ) async {
    List<ProgressAppCharacter> progressChars = [];
    AppCharacter char;
    int id, progress;

    for (var map in list) {
      id = map['id'] ?? -1;
      progress = map['progress'] ?? -1;

      if (id != -1 && progress != -1) {
        if ((widget.onlyComplete ? progress == 4 : true)) {
          char = AppCharacter.fromMap(
            (await FirebaseFirestore.instance
                        .collection(widget.collectionPath)
                        .doc('$id')
                        .get())
                    .data()
                as Map<String, dynamic>,
          );
          progressChars.add(ProgressAppCharacter(char, progress));
        }
      }
    }
    return progressChars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Stack(
        children: [
          // Fond avec effet de dégradé
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
          ),

          StreamBuilder<QuerySnapshot>(
            stream:
                _firestore
                    .collection('users')
                    .where('id', isEqualTo: userId)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Erreur: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              try {
                final users = snapshot.data!.docs;

                if (users.length != 1) {
                  return Center(child: Text('Aucune donnée trouvée !'));
                }

                final user = users[0].data() as Map<String, dynamic>;
                List<ProgressAppCharacter> appChars = [];
                List<Map<String, dynamic>> list = [];

                try {
                  // Vérification de la présence de gameData et de la bonne clé
                  if (user['gameData'] == null ||
                      user['gameData'][widget.agentsType] == null) {
                    return Center(
                      child: Text(
                        'Aucun ${widget.agentsType} trouvé.',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  list =
                      (user['gameData'][widget.agentsType] as List<dynamic>)
                          .map((e) => e as Map<String, dynamic>)
                          .toList();
                } catch (e) {
                  return Center(
                    child: Text(
                      'Erreur lors de la lecture des données : $e',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return FutureBuilder<List<ProgressAppCharacter>>(
                  future: getProgessAppCharacters(list),
                  builder: (context, futureSnapshot) {
                    if (futureSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (futureSnapshot.hasError) {
                      return Center(
                        child: Text(
                          'Erreur lors du chargement des caractères: ${futureSnapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    try {
                      // Les données sont prêtes, utilisez-les ici
                      appChars = futureSnapshot.data ?? [];

                      // Si la liste est vide, afficher un message
                      if (appChars.isEmpty) {
                        return Center(
                          child: Text(
                            'Aucun ${widget.agentsType} trouvé.',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      // Contenu principal
                      return widget.builder(appChars);
                    } catch (e) {
                      return Center(
                        child: Text(
                          'Erreur d\'affichage : $e',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                );
              } catch (e) {
                return Center(
                  child: Text(
                    'Erreur inattendue : $e',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
