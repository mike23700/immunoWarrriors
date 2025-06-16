import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/models/caracter_model.dart';
import 'package:immuno_warriors/models/user_model.dart';
import 'package:immuno_warriors/screens/home/home_screen.dart';
import 'package:immuno_warriors/widgets/characters_listener.dart';
import 'package:immuno_warriors/widgets/custom_button.dart';

class LaboScreen extends StatefulWidget {
  const LaboScreen({super.key});

  @override
  State<LaboScreen> createState() => _LaboScreen();
}

class _LaboScreen extends State<LaboScreen> {
  @override
  Widget build(BuildContext context) {
    return CharactersListener(
      (List<ProgressAppCharacter> pChars) {
        List<SearchCard> searchCards = [];

        for (var sChar in pChars) {
          searchCards.add(SearchCard(searchCharacter: sChar));
        }

        return SingleChildScrollView(
          child: SafeArea(child: Column(children: searchCards)),
        );
      },
      protectors: false,
      onlyComplete: false,
    );
  }
}

class SearchCard extends StatefulWidget {
  final ProgressAppCharacter searchCharacter;
  const SearchCard({super.key, required this.searchCharacter});

  @override
  State<SearchCard> createState() => _SearchCard();
}

class _SearchCard extends State<SearchCard> {
  final level = [0.0, 0.25, 0.50, 0.75, 1.0];
  int get progress => widget.searchCharacter.getProgress();
  //on calcule le cout de la progression
  int get upgradeCost =>
      (widget.searchCharacter.cost *
              (level[progress == widget.searchCharacter.progressLimit
                      ? progress
                      : progress + 1] -
                  level[progress]))
          .toInt();

  Future<void> _upgrade() async {
    try {
      //on progress si possible
      if (widget.searchCharacter.progress()) {
        //on recupere l'utilisateur depuis firestore
        AppUser user = AppUser.fromMap(
          (await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userAuth?.uid)
                      .get())
                  .data()
              as Map<String, dynamic>,
        );
        //on arrete tout s'il ne peux pas payer l'evolution
        if (user.gameData?['coin'] < upgradeCost) return;
        //on met a jour la somme du jouer et la progression pour ce pathogene
        user.gameData?['coin'] -= upgradeCost;
        user.gameData?['pathogenes'][widget.searchCharacter.id]['progress'] =
            progress;
        user.gameData?['pathogenes'][widget.searchCharacter.id]['quantity'] = 3;
        //operation
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userAuth?.uid)
            .update(user.toMap());
      }
    } catch (e, stack) {
      debugPrint('Erreur lors de la progression : $e\n$stack');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la progression : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCharacterDetails() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return buildCharacterInfoPopup(
          context: dialogContext,
          character: widget.searchCharacter,
          quantity: 1,
          onActionPressed: () {
            _upgrade();
            Navigator.of(dialogContext).pop();
          },
          actionButtonText: 'Progresser',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    IconData upgradeIcon = Icons.monetization_on;
    String upgradeText = '$upgradeCost';
    if (upgradeCost == 0) {
      upgradeIcon = Icons.check_circle;
      upgradeText = 'complete';
    }
    return Container(
      margin: EdgeInsets.all(12),
      child: Card(
        color: cardBackground,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 110,
              width: 110,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: neonBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(
                  8,
                ), // Slightly smaller radius
                border: Border.all(color: neonBlue.withOpacity(0.3)),
              ),
              child: Image.asset(
                widget.searchCharacter.photoUrl ?? '',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback si l'image n'est pas trouvée
                  return const Icon(
                    Icons.science_rounded,
                    size: 50,
                    color: Colors.blueGrey,
                  );
                },
              ),
            ),

            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 14,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Affichage du nom en gras suivi de la description
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${widget.searchCharacter.name}, ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: widget.searchCharacter.description,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    LinearProgressIndicator(
                      value: level[progress],
                      backgroundColor: neonBlue.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.lightBlue,
                      minHeight: 10,
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: textIconButton(
                            _upgrade,
                            upgradeIcon,
                            upgradeText,
                          ),
                        ),
                        Expanded(
                          child: textIconButton(
                            _showCharacterDetails,
                            Icons.info,
                            'infos',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Construit et retourne un AlertDialog affichant les informations d'un AppCharacter.
///
/// [context]: Le BuildContext actuel.
/// [character]: L'objet AppCharacter dont les informations doivent être affichées.
/// [onActionPressed]: La fonction VoidCallback à exécuter lorsque le bouton d'action est pressé.
/// [actionButtonText]: Le texte à afficher sur le bouton d'action (par exemple, "Sélectionner", "Attaquer").
Widget buildCharacterInfoPopup({
  required BuildContext context,
  required AppCharacter character,
  required int quantity,
  required VoidCallback onActionPressed,
  String actionButtonText = 'Action',
}) {
  return AlertDialog(
    backgroundColor: darkBackground.withOpacity(0.9),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    title: Row(
      children: [
        // Afficher la photo si disponible, sinon une icône par défaut
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            character.photoUrl ?? '',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback si l'image n'est pas trouvée
              return Icon(
                character.isProtector ? Icons.shield : Icons.coronavirus,
                size: 50,
                color: Colors.blueGrey,
              );
            },
          ),
        ),

        const SizedBox(width: 8),
        Expanded(
          // Utiliser Expanded pour éviter les débordements de texte
          child: Text(
            character.name,
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20),
            overflow: TextOverflow.ellipsis, // Gérer le texte trop long
          ),
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type de personnage (Protecteur/Pathogène)
        Row(
          children: [
            Icon(
              character.isProtector ? Icons.healing : Icons.bug_report,
              color: character.isProtector ? neonGreen : neonPurple,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Type: ${character.type} (${character.isProtector ? 'Protecteur' : 'Pathogène'})',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // PV
        Row(
          children: [
            const Icon(Icons.favorite, color: Colors.redAccent, size: 16),
            const SizedBox(width: 8),
            Text(
              'PV: ${character.pv}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Coût
        Row(
          children: [
            const Icon(Icons.attach_money, color: Colors.yellow, size: 16),
            const SizedBox(width: 8),
            Text(
              'Valeur: ${character.cost}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        //quantité
        Row(
          children: [
            const Icon(Icons.numbers, color: Colors.blue, size: 16),
            const SizedBox(width: 8),
            Text(
              'Quantité: ${quantity}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Description
        Text(
          character.description,
          style: const TextStyle(color: Colors.white54, fontSize: 13),
        ),
        const SizedBox(height: 16),
      ],
    ),
    actions: [
      TextButton(
        onPressed: onActionPressed, // Utilise la fonction passée en paramètre
        style: TextButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          actionButtonText, // Utilise le texte du bouton d'action passé en paramètre
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Ferme le pop-up
        },
        style: TextButton.styleFrom(
          foregroundColor: neonPink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: neonPink),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: const Text('Annuler'),
      ),
    ],
  );
}
