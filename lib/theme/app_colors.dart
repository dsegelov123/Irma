import 'package:flutter/material.dart';

class AppColors {
  // Base UI
  static const Color background = Color(0xFFFFFFFF); // Pure White for Airy look
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color border = Color(0xFFF2F0F0); // Softer border

  // Primary Accent
  static const Color primary = Color(0xFFFF5E7E);
  static const Color primarySoft = Color(0xFFFFD3DC);

  // Phase Themed Colors
  static const Color menstrual = Color(0xFFCFCDF6); // Lavender
  static const Color follicular = Color(0xFFF6D4B8); // Peach
  static const Color ovulation = Color(0xFFFF5E7E);  // Pink
  static const Color luteal = Color(0xFFB4A8D3);    // Purple

  // Surface Washes (Pastel backgrounds)
  static const Color menstrualWash = Color(0xFFF1F0FF);
  static const Color follicularWash = Color(0xFFFFF7F0);
  static const Color ovulationWash = Color(0xFFFFEFF2);
  static const Color lutealWash = Color(0xFFF6F2FF);

  // AI & Feedback
  static const Color aiSparkStart = Color(0xFFFF8CA0);
  static const Color aiSparkEnd = Color(0xFFFF5E7E);
  
  static Color getPhaseColor(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
      case 'menstrual phase':
        return menstrual;
      case 'follicular':
      case 'follicular phase':
        return follicular;
      case 'ovulation':
      case 'ovulation window':
        return ovulation;
      case 'luteal':
      case 'luteal phase':
        return luteal;
      default:
        return luteal;
    }
  }

  static Color getSurfaceWash(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
      case 'menstrual phase':
        return menstrualWash;
      case 'follicular':
      case 'follicular phase':
        return follicularWash;
      case 'ovulation':
      case 'ovulation window':
        return ovulationWash;
      case 'luteal':
      case 'luteal phase':
        return lutealWash;
      default:
        return background;
    }
  }
}
