import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:immuno_warriors/models/caracter_model.dart';
import 'package:immuno_warriors/models/user_model.dart';
import 'package:immuno_warriors/screens/home/home_screen.dart';
import 'package:immuno_warriors/screens/lab/labo_screen.dart';
import 'package:immuno_warriors/widgets/characters_listener.dart';
import 'package:immuno_warriors/widgets/custom_button.dart';

class BioForgeScreen extends StatefulWidget {
  final bool protectors;
  const BioForgeScreen({required this.protectors, super.key});

  @override
  State<BioForgeScreen> createState() => _BioForgeScreen();
}

class _BioForgeScreen extends State<BioForgeScreen> {
  @override
  Widget build(BuildContext context) {
    return CharactersListener(
      (List<ProgressAppCharacter> pChars) {
        return CharacterSliderPage(characters: pChars);
      },
      protectors: widget.protectors,
      onlyComplete: true,
    );
  }
}

class CharacterSliderPage extends StatefulWidget {
  final List<AppCharacter> characters;
  const CharacterSliderPage({required this.characters, super.key});

  @override
  State<CharacterSliderPage> createState() => _CharacterSliderPageState();
}

class _CharacterSliderPageState extends State<CharacterSliderPage> {
  final PageController _pageController = PageController(
    viewportFraction: 0.85, // Pour voir un peu du slide suivant/précédent
    initialPage: 0,
  );

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.characters.length,
            itemBuilder: (context, index) {
              final character = widget.characters[index];
              // Utilisation d'un AnimatedBuilder pour créer un effet de zoom
              // lorsque le slide est centré.
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    // Plus le slide est proche du centre (value proche de 0),
                    // plus il est grand.
                    value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height:
                          Curves.easeOut.transform(value) *
                          400, // Ajustez la hauteur max
                      width:
                          Curves.easeOut.transform(value) *
                          MediaQuery.of(context).size.width *
                          0.85, // Ajustez la largeur max
                      child: child,
                    ),
                  );
                },
                child: CharacterCard(character: character),
              );
            },
          ),
        ),
        // Indicateurs de pages
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.characters.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 8.0,
                width: _currentPage == index ? 24.0 : 8.0,
                decoration: BoxDecoration(
                  color:
                      _currentPage == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class CharacterCard extends StatelessWidget {
  final AppCharacter character;

  const CharacterCard({required this.character, super.key});

  Future<void> _build(BuildContext context) async {
    try {
      //on recupere l'utilisateur depuis firestore
      AppUser user = AppUser.fromMap(
        (await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userAuth?.uid)
                    .get())
                .data()
            as Map<String, dynamic>,
      );
      //on arrete tout s'il ne peux pas payer la forge
      if (user.gameData?['coin'] < character.cost) return;
      //on met a jour la somme du joueur et la quantite pour cette agent
      user.gameData?['coin'] -= character.cost;

      // Vérification de l'existence des clés avant modification
      if (user.gameData?['pathogenes'] != null &&
          user.gameData?['pathogenes'][character.id] != null &&
          user.gameData?['pathogenes'][character.id]['quantity'] != null) {
        user.gameData?['pathogenes'][character.id]['quantity'] += 1;
      } else {
        // Initialisation si la clé n'existe pas
        user.gameData?['pathogenes'][character.id] = {'quantity': 1};
      }

      //operation de mise a jour sur firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userAuth?.uid)
          .update(user.toMap());
    } catch (e, stack) {
      // Affiche l'erreur dans la console pour le debug
      debugPrint('Erreur lors de la forge : $e\n$stack');
      // afficher un message à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la forge : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCharacterDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return buildCharacterInfoPopup(
          context: dialogContext,
          character: character,
          quantity: 1,
          onActionPressed: () => _build(dialogContext),
          actionButtonText: 'forger',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: neonBlue,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                character.photoUrl ?? '',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback si l'image n'est pas trouvée
                  return const Icon(
                    Icons.coronavirus,
                    size: 100,
                    color: Colors.white70,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              character.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            textIconButton(
              () => _showCharacterDetails(context),
              Icons.build,
              '+10 forger',
            ),
          ],
        ),
      ),
    );
  }
}
