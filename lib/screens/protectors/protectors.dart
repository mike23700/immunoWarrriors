import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class ProtectorsScreen extends StatelessWidget {
  const ProtectorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImmunoWarriors Character Slider',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CharacterSliderPage(),
    );
  }
}

// Modèle de données pour un personnage
class Character {
  final String name;
  final String description;
  final String imagePath; // Chemin vers l'image du personnage
  final Color backgroundColor; // Couleur de fond pour le slide du personnage

  Character({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.backgroundColor,
  });
}

class CharacterSliderPage extends StatefulWidget {
  const CharacterSliderPage({super.key});

  @override
  State<CharacterSliderPage> createState() => _CharacterSliderPageState();
}

class _CharacterSliderPageState extends State<CharacterSliderPage> {
  // Liste de personnages fictifs pour notre slider
  final List<Character> characters = [
    Character(
      name: 'Macro-Vorace',
      description:
          'Le gourmand cellulaire, première ligne de défense contre les envahisseurs!',
      imagePath:
          'assets/macro_vorace.png', // Assurez-vous d'avoir cette image dans votre dossier assets
      backgroundColor: Colors.lightGreen.shade200,
    ),
    Character(
      name: 'T-Faucheur',
      description:
          'Le moissonneur cellulaire, spécialiste de l\'élimination des cellules infectées.',
      imagePath:
          'assets/t_faucheur.png', // Assurez-vous d'avoir cette image dans votre dossier assets
      backgroundColor: Colors.red.shade200,
    ),
    Character(
      name: 'Ig-Bouclier',
      description:
          'Le bouclier immunitaire, neutralise les menaces et marque les ennemis.',
      imagePath:
          'assets/ig_bouclier.png', // Assurez-vous d'avoir cette image dans votre dossier assets
      backgroundColor: Colors.blue.shade200,
    ),
    Character(
      name: 'Neutro-Blitz',
      description:
          'L\'éclair neutre, rapide et efficace contre les bactéries et champignons.',
      imagePath:
          'assets/neutro_blitz.png', // Assurez-vous d'avoir cette image dans votre dossier assets
      backgroundColor: Colors.purple.shade200,
    ),
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROTECTORS',
          style: GoogleFonts.orbitron(
            color: AppTheme.neonPink,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: AppTheme.glowEffect(AppTheme.neonPink),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
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
              children: List.generate(characters.length, (index) {
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
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({required this.character, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: character.backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                character.imagePath,
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
            Text(
              character.description,
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
