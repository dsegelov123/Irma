import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IrmaTheme {
  // --- GOSPEL COLORS ---
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  
  // Phase Colors
  static const Color menstrual = Color(0xFFFF5E7E);
  static const Color follicular = Color(0xFFF4D5B6);
  static const Color ovulation = Color(0xFF7BE4D5);
  static const Color luteal = Color(0xFFC9B3FF);
  
  // Neutral / Text
  static const Color textMain = Color(0xFF1E1E1E);
  static const Color textSub = Color(0xFF7A7A7A);
  static const Color borderLight = Color(0xFFE9E6E6);

  // --- GRADIENTS ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8E4DD6), Color(0xFF6A35A3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF8E4DD6), Color(0xFF6A35A3)],
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
        displayLarge: outfit.copyWith(fontSize: 32, fontWeight: FontWeight.bold, color: textMain),
        displayMedium: outfit.copyWith(fontSize: 24, fontWeight: FontWeight.w600, color: textMain),
        bodyLarge: inter.copyWith(fontSize: 16, color: textMain),
        bodyMedium: inter.copyWith(fontSize: 14, color: textSub),
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
