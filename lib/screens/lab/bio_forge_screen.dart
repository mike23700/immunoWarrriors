import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            decoration: BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
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
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône de la Bio-Forge
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppTheme.neonPink, AppTheme.neonPurple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                ...AppTheme.glowEffect(AppTheme.neonPink),
                                BoxShadow(
                                  color: AppTheme.neonPurple.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.auto_fix_high_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Titre
                          Text(
                            'BIO-FORGE',
                            style: GoogleFonts.orbitron(
                              color: AppTheme.neonPink,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Description
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              'Créez et personnalisez vos propres agents biologiques pour combattre les menaces virales.',
                              style: GoogleFonts.rajdhani(
                                color: Colors.white70,
                                fontSize: 16,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
