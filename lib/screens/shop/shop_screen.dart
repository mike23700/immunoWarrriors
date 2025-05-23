import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

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
                  // En-tête avec bouton de retour
                  Row(
                    children: [
                      // Bouton de retour
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.neonPink.withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: AppTheme.glowEffect(AppTheme.neonPink),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Titre
                      Text(
                        'BOUTIQUE',
                        style: GoogleFonts.orbitron(
                          color: AppTheme.neonPink,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: AppTheme.glowEffect(AppTheme.neonPink),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Contenu de la boutique
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icône de la boutique
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
                              Icons.shopping_cart_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Titre
                          Text(
                            'BOUTIQUE',
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
