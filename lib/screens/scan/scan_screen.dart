import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

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
                    'SCAN',
                    style: GoogleFonts.orbitron(
                      color: AppTheme.neonBlue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: AppTheme.glowEffect(AppTheme.neonBlue),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Zone de scan
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cadre du scanner
                          Container(
                            width: 250,
                            height: 250,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.neonBlue.withOpacity(0.5),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: AppTheme.glowEffect(AppTheme.neonBlue, spread: 2, blur: 10),
                            ),
                            child: Stack(
                              children: [
                                // Animation de balayage
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          AppTheme.neonBlue,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Icône de scan
                                const Center(
                                  child: Icon(
                                    Icons.qr_code_scanner_rounded,
                                    color: AppTheme.neonBlue,
                                    size: 100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Message d'instruction
                          Text(
                            'Scannez L organimse ',
                            style: GoogleFonts.rajdhani(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Bouton d'action
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.bluePinkGradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: AppTheme.glowEffect(AppTheme.neonBlue, spread: 2, blur: 10),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Démarrer le scan
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'LANCER LE SCAN',
                        style: GoogleFonts.rajdhani(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
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
