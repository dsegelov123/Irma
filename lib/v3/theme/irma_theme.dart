import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IrmaTheme {
  // --- GOSPEL COLORS ---
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  
  // Phase Colors
  // Gospel Phase Colors
  static const Color menstrual = Color(0xFFFF5E76);
  static const Color follicular = Color(0xFF7FD7C1);
  static const Color ovulation = Color(0xFFFDBB2D);
  static const Color luteal = Color(0xFF8E7AB5);

  // Layout Tokens (Gospel Track 13 Rectification)
  static const double radiusCard = 32.0;       // Large Cards / Standard
  static const double radiusCardMedium = 20.0; // Symptom Cards
  static const double radiusCardSmall = 16.0;  // Status Box / Info Cards
  static const double radiusAction = 24.0;     // Corrected to 24px as per Gospel v3
  static const double radiusTile = 16.0;       // Rectified to 16
  static const double radiusLarge = 40.0;      // Bottom Nav / Immersive elements
  
  static const double margin = 24.0;
  
  // Neutral / Text
  static const Color textMain = Color(0xFF1E1E1E);
  static const Color textSub = Color(0xFF7A7A7A);
  static const Color borderLight = Color(0xFFE9E6E6);

  // --- GRADIENTS ---
  // Gospel Orange-Purple Primary
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5E76), // Menstrual Red
      Color(0xFFE04A62), // Deep Rose
    ],
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [
      Color(0xFFFF5E76), // Menstrual Red
      Color(0xFFE04A62), // Deep Rose
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // --- TYPOGRAPHY ---
  static TextStyle get outfit => GoogleFonts.outfit();
  static TextStyle get inter => GoogleFonts.inter();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: pureWhite,
      textTheme: TextTheme(
        displayLarge: outfit.copyWith(fontSize: 36, fontWeight: FontWeight.bold, color: textMain),
        displayMedium: outfit.copyWith(fontSize: 22, fontWeight: FontWeight.w600, color: textMain),
        bodyLarge: inter.copyWith(fontSize: 16, fontWeight: FontWeight.w400, color: textMain),
        bodyMedium: inter.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: textSub),
        labelSmall: inter.copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: textSub),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: menstrual,
        primary: menstrual,
        secondary: luteal,
        surface: pureWhite,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
