import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs du thème
  static const Color darkBackground = Color(0xFF0A0A1A);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color cardSurface = Color(0xFF242538);

  // Couleurs néon
  static const Color neonBlue = Color(0xFF00F7FF);
  static const Color neonPink = Color(0xFFFF00F5);
  static const Color neonPurple = Color(0xFFB400FF);
  static const Color neonGreen = Color(0xFF00FF75);

  // Effet de lueur pour les éléments interactifs
  static List<BoxShadow> glowEffect(
    Color color, {
    double spread = 2.0,
    double blur = 8.0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(0.4),
        blurRadius: blur,
        spreadRadius: spread,
      ),
      BoxShadow(
        color: color.withOpacity(0.2),
        blurRadius: blur * 2,
        spreadRadius: spread * 2,
      ),
    ];
  }

  // Styles de texte
  static TextStyle get headingStyle => GoogleFonts.orbitron(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static TextStyle get subtitleStyle => GoogleFonts.rajdhani(
    color: Colors.white70,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static TextStyle get cardTitleStyle => GoogleFonts.rajdhani(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get cardSubtitleStyle => GoogleFonts.rajdhani(
    color: Colors.white70,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  // Thème de l'application
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: neonBlue,
        secondary: neonPink,
        surface: cardSurface,
        background: darkBackground,
        onBackground: Colors.white,
        onSurface: Colors.white70,
      ),
      textTheme: TextTheme(
        displayLarge: headingStyle,
        displayMedium: headingStyle.copyWith(fontSize: 24),
        displaySmall: headingStyle.copyWith(fontSize: 20),
        bodyLarge: subtitleStyle,
        bodyMedium: subtitleStyle.copyWith(fontSize: 14),
        bodySmall: subtitleStyle.copyWith(fontSize: 12),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headingStyle.copyWith(fontSize: 22),
        iconTheme: const IconThemeData(color: neonBlue, size: 28),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonBlue,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neonBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neonBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }

  // Dégradés courants
  static LinearGradient get bluePinkGradient => const LinearGradient(
    colors: [neonBlue, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get purplePinkGradient => const LinearGradient(
    colors: [neonPurple, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBackground.withOpacity(0.8), darkBackground],
  );
}
