import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

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
                    'SIMULATION',
                    style: GoogleFonts.orbitron(
                      color: AppTheme.neonBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: AppTheme.glowEffect(AppTheme.neonBlue),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Contenu de la simulation
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône de simulation
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.bluePinkGradient,
                              boxShadow: [
                                ...AppTheme.glowEffect(AppTheme.neonBlue),
                                BoxShadow(
                                  color: AppTheme.neonPink.withOpacity(0.5),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.videogame_asset_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Titre
                          Text(
                            'SIMULATION DE COMBAT',
                            style: GoogleFonts.orbitron(
                              color: AppTheme.neonPink,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
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
