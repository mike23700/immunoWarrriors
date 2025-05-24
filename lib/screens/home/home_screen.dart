import 'dart:ui';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/screens/protectors/protectors.dart';
import 'package:immuno_warriors/screens/scan/scan_screen.dart';
//import 'package:immuno_warriors/screens/simulation/simulation_screen.dart';
import 'package:immuno_warriors/screens/lab/lab_screen.dart';
import 'package:immuno_warriors/screens/archive/archive_screen.dart';
import 'package:immuno_warriors/screens/gemini/gemini_screen.dart';
import 'package:immuno_warriors/screens/shop/shop_screen.dart';
import 'package:immuno_warriors/screens/settings/settings_screen.dart';
import 'package:immuno_warriors/screens/simulation/simulation_screen.dart';

// Neon color palette
const Color neonBlue = Color(0xFF00F7FF);
const Color neonPink = Color(0xFFFF00F5);
const Color neonPurple = Color(0xFFB400FF);
const Color neonGreen = Color(0xFF00FF75);
const Color darkBackground = Color(0xFF0A0A1A);
const Color cardBackground = Color(0xFF1A1A2E);
const Color cardSurface = Color(0xFF242538);

// Text styles
final TextStyle headingStyle = GoogleFonts.orbitron(
  color: Colors.white,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
);

final TextStyle subtitleStyle = GoogleFonts.rajdhani(
  color: Colors.white70,
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

final TextStyle cardTitleStyle = GoogleFonts.rajdhani(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
);

final TextStyle cardSubtitleStyle = GoogleFonts.rajdhani(
  color: Colors.white70,
  fontSize: 14,
);

// Glow effect for neon elements
List<BoxShadow> glowEffect(Color color) {
  return [
    BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2),
    BoxShadow(color: color.withOpacity(0.2), blurRadius: 16, spreadRadius: 4),
  ];
}

// Gradient background
BoxDecoration backgroundGradient = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      darkBackground.withOpacity(0.9),
      darkBackground,
      const Color(0xFF0A0A1A).withBlue(50),
    ],
  ),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Widget> _screens = [
    const HomeContent(),
    const Scaffold(body: ProtectorsScreen()),
    const Scaffold(body: ScanScreen()),
    const Scaffold(body: LabScreen()),
    const Scaffold(body: ArchiveScreen()),
    const Scaffold(body: SimulationScreen()),
  ];

  double _draggableButtonX = 30.0;
  double _draggableButtonY = 155.0;
  final double _draggableButtonSize = 60.0;
  late Positioned draggrableButton;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran pour définir les limites de déplacement
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            right: _draggableButtonX,
            top: _draggableButtonY,
            child: GestureDetector(
              // Détecte le début du glissement
              onPanStart: (details) {
                // Optionnel: stocker le point de départ du glissement
                // pour des calculs plus complexes si nécessaire.
              },
              // Détecte le mouvement de glissement
              onPanUpdate: (details) {
                setState(() {
                  // Met à jour les coordonnées X et Y du bouton
                  // en ajoutant le delta de déplacement.

                  // Assure que le bouton reste dans les limites de l'écran
                  _draggableButtonX = (_draggableButtonX + details.delta.dx)
                      .clamp(0.0, screenSize.width - _draggableButtonSize);
                  _draggableButtonY = (_draggableButtonY + details.delta.dy)
                      .clamp(
                        0.0,
                        screenSize.height -
                            _draggableButtonSize -
                            AppBar().preferredSize.height -
                            MediaQuery.of(context).padding.top,
                      );
                  // On soustrait la hauteur de l'AppBar et la barre de statut
                  // pour que le bouton ne dépasse pas le bas de l'écran visible.
                });
              },
              // Détecte la fin du glissement (quand le doigt est levé)
              onPanEnd: (details) {
                // Optionnel: Tu peux ajouter ici une logique pour "ancrer" le bouton
                // à un bord de l'écran s'il est proche, par exemple.
                // Ou réinitialiser sa position si tu veux.
              },
              // Détecte un simple tap sur le bouton
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimulationScreen(),
                  ),
                );
              },
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimulationScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.view_in_ar_rounded),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: neonPurple.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: cardSurface.withOpacity(0.7),
                border: Border.all(
                  color: neonPurple.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: neonBlue,
                unselectedItemColor: Colors.white60,
                selectedLabelStyle: GoogleFonts.rajdhani(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: GoogleFonts.rajdhani(
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                elevation: 0,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 0
                                ? neonBlue.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.home_rounded,
                        size: 24,
                        color: _selectedIndex == 0 ? neonBlue : Colors.white60,
                      ),
                    ),
                    label: 'Accueil',
                  ),

                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 1
                                ? neonBlue.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.shield_rounded,
                        size: 24,
                        color: _selectedIndex == 1 ? neonBlue : Colors.white60,
                      ),
                    ),
                    label: 'Protectors',
                  ),

                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 2
                                ? neonPink.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_search,
                        size: 24,
                        color: _selectedIndex == 2 ? neonPink : Colors.white60,
                      ),
                    ),
                    label: 'Scanner',
                  ),

                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 3
                                ? neonPurple.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Contenu de la fiole
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Col de la fiole
                              Container(
                                width: 10,
                                height: 4,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedIndex == 3
                                          ? neonPurple
                                          : Colors.white60,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Container(
                                width: 16,
                                height: 20,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedIndex == 3
                                          ? neonPurple.withOpacity(0.2)
                                          : Colors.white10,
                                  border: Border.all(
                                    color:
                                        _selectedIndex == 3
                                            ? neonPurple
                                            : Colors.white60,
                                    width: 1.5,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                    topLeft: Radius.circular(1),
                                    topRight: Radius.circular(1),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Liquide dans la fiole
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color:
                                              _selectedIndex == 3
                                                  ? neonPurple.withOpacity(0.8)
                                                  : Colors.white60.withOpacity(
                                                    0.3,
                                                  ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    label: 'Lab',
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:
                            _selectedIndex == 4
                                ? neonPink.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.archive_rounded,
                        size: 24,
                        color: _selectedIndex == 4 ? neonPink : Colors.white60,
                      ),
                    ),
                    label: 'Archives',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget pour les boutons d'en-tête
Widget _buildHeaderButton(
  BuildContext context, {
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: glowEffect(color),
      ),
      child: Icon(icon, color: color, size: 22),
    ),
  );
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: backgroundGradient,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec boutons et titre
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    // Boutons en haut à droite
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bouton Paramètres
                        _buildHeaderButton(
                          context,
                          icon: Icons.settings_rounded,
                          color: neonBlue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        // Bouton Boutique
                        _buildHeaderButton(
                          context,
                          icon: Icons.shopping_cart_rounded,
                          color: neonPink,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Titre "IMMUNOWARRIORS"
                    Container(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'IMMUNOWARRIORS',
                          style: GoogleFonts.orbitron(
                            color: neonBlue,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                            shadows: glowEffect(neonBlue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // "RESSOURCES DÉFENSIVES" Section (within a styled square container)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(
                    15,
                  ), // Inner padding for the section content
                  decoration: BoxDecoration(
                    color: cardBackground.withOpacity(
                      0.5,
                    ), // Slightly transparent background for the section container
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: neonBlue.withOpacity(
                        0.3,
                      ), // Border color for the section
                      width: 1,
                    ),
                    boxShadow: glowEffect(neonBlue.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RESSOURCES DÉFENSIVES',
                        style: GoogleFonts.rajdhani(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 15),
                      IntrinsicHeight(
                        // Ensures all children in the row have the same height
                        child: Row(
                          // All three cards in one row, exactly the same size
                          children: [
                            Expanded(
                              flex: 1,
                              child: _buildDefensiveResourceCard(
                                context,
                                icon: Icons.shield,
                                color: neonBlue,
                                title: 'Barrière',
                                value: '2,350',
                                regeneration: '+30/min',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: _buildDefensiveResourceCard(
                                context,
                                icon: Icons.hexagon_outlined,
                                color: neonPink,
                                title: 'Blindage',
                                value: '1,720',
                                regeneration: '+22/min',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: _buildDefensiveResourceCard(
                                context,
                                icon: Icons.track_changes,
                                color: neonPurple,
                                title: 'Champ magnétique',
                                value: '860',
                                regeneration: 'Régénération',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // "MÉMOIRE IMMUNITAIRE" and "Gemini" Section (side-by-side with bottom alignment)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .end, // Align contents to the bottom of the row
                  children: [
                    Expanded(
                      flex: 3, // MEMOIRE IMMUNITAIRE is wider
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MÉMOIRE IMMUNITAIRE',
                            style: GoogleFonts.rajdhani(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: cardBackground,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: neonPink.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: glowEffect(neonPink.withOpacity(0.1)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize:
                                  MainAxisSize.min, // Keep height minimal
                              children: [
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ShaderMask(
                                        shaderCallback:
                                            (bounds) => const LinearGradient(
                                              colors: [neonPink, neonPurple],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ).createShader(bounds),
                                        child: const CircularProgressIndicator(
                                          value: 0.7,
                                          strokeWidth: 8,
                                          backgroundColor: Colors.white10,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '70%',
                                        style: GoogleFonts.rajdhani(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Régénération',
                                  style: cardTitleStyle.copyWith(
                                    color: neonPink,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Optimisation des capacités de guérison et de mémoire immunitaire.',
                                  style: cardSubtitleStyle.copyWith(
                                    fontSize: 11,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ), // Space between the two main cards
                    Expanded(
                      flex: 2, // Gemini is narrower, so smaller flex
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start, // Adjust as needed, usually start for text
                        children: [
                          // Empty SizedBox to push Gemini card down for bottom alignment
                          // Calculate height needed to match the top spacing of the left card's title
                          SizedBox(
                            height:
                                GoogleFonts.rajdhani(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ).fontSize! +
                                15, // Height of title + its bottom padding
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const GeminiScreen(),
                                  transitionsBuilder: (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOutQuart;
                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(
                                      tween,
                                    );
                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: _buildGeminiCardContent(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Space for bottom navigation bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefensiveResourceCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String regeneration,
  }) {
    return Container(
      // The height will be implicitly determined by IntrinsicHeight and content
      padding: const EdgeInsets.all(
        10,
      ), // Adjusted padding for very compact cards
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: glowEffect(color.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribute space vertically
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5), // Further adjusted icon padding
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8), // Slightly smaller radius
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20, // Further adjusted icon size
            ),
          ),
          const SizedBox(height: 5), // Adjusted spacing
          Text(
            title,
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 14, // Adjusted font size
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 3), // Adjusted spacing
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: color,
              fontSize: 16, // Adjusted font size
              fontWeight: FontWeight.bold,
              shadows: glowEffect(color.withOpacity(0.5)),
            ),
          ),
          const SizedBox(height: 3), // Adjusted spacing
          Text(
            regeneration,
            style: GoogleFonts.rajdhani(
              color: Colors.white70,
              fontSize: 10, // Adjusted font size
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeminiCardContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: neonPink.withOpacity(0.3), width: 1),
        boxShadow: glowEffect(neonPink.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start, // Align content to top of Gemini card
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gemini Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [neonPurple, neonPink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: glowEffect(neonPurple.withOpacity(0.3)),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 35),
          ),
          const SizedBox(height: 8),
          Text(
            'Gemini',
            style: GoogleFonts.orbitron(
              color: neonPink,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'IA ANALYSTE DE COMBAT IA',
            style: GoogleFonts.rajdhani(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Renforce les barrières lors d\'une attaque virale imminente',
            style: cardSubtitleStyle.copyWith(
              fontSize: 11,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
