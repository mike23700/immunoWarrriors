import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/screens/protectors/protectors_screen.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class BioForgeScreen extends StatelessWidget {
  const BioForgeScreen({super.key});

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

          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Titre
                  Text(
                    'BIO-FORGE',
                    style: GoogleFonts.orbitron(
                      color: AppTheme.neonPink,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: AppTheme.glowEffect(AppTheme.neonPink),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Contenu de la Bio-Forge
                  Expanded(child: Center(child: CharacterSliderPage())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
