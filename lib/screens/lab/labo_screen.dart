import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/screens/home/home_screen.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class LaboratoryContent extends StatelessWidget {
  const LaboratoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titre
              Text(
                'LABORATOIRE D\'ANALYSE',
                style: GoogleFonts.orbitron(
                  color: AppTheme.neonGreen,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Icône du laboratoire
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(0),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: neonBlue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: neonBlue.withOpacity(0.3)),
                      ),
                      child: Image.asset(
                        'assets/macro_vorace.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback si l'image n'est pas trouvée
                          return const Icon(
                            Icons.science_rounded,
                            size: 100,
                            color: Colors.white70,
                          );
                        },
                      ),
                    ),

                    Expanded(
                      child: Column(
                        children: [
                          Text("description de la recherche"),
                          LinearProgressIndicator(
                            value: 0.65,
                            backgroundColor: Colors.grey,
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.lightBlue,
                            minHeight: 10,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Icon(Icons.money),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Icon(Icons.info),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Analysez les échantillons et découvrez des informations détaillées sur les agents pathogènes.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Espace pour la barre de navigation secondaire
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
