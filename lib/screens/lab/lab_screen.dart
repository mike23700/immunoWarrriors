import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/screens/lab/bio_forge_screen.dart';
import 'package:immuno_warriors/screens/lab/labo_screen.dart';
import 'package:immuno_warriors/theme/app_theme.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({super.key});

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
    }
  }

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
          Column(
            children: [
              // Contenu des onglets
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    LaboScreen(),
                    BioForgeScreen(protectors: false),
                  ],
                ),
              ),

              // Barre de navigation secondaire (positionnée plus haut pour éviter le chevauchement)
              Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem('LABORATOIRE', 0, AppTheme.neonGreen),
                    Container(
                      width: 1,
                      height: 20,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    _buildNavItem('BIO-FORGE', 1, AppTheme.neonPink),
                  ],
                ),
              ),

              // Espace pour la barre de navigation principale
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String title, int index, Color color) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _tabController.animateTo(index);
          });
        },
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.rajdhani(
                color: isSelected ? color : Colors.white70,
                fontSize: 14, // Taille de police réduite
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
