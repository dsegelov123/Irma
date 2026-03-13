import 'package:flutter/material.dart';

class AppColors {
  // Base UI
  static const Color background = Color(0xFFF7F6F6);
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color border = Color(0xFFE9E6E6);

  // Primary Accent
  static const Color primary = Color(0xFFFF5E7E);
  static const Color primarySoft = Color(0xFFFFD3DC);

  // Phase Themed Colors
  static const Color menstrual = Color(0xFFCFCDF6); // Lavender
  static const Color follicular = Color(0xFFF6D4B8); // Peach/Mint
  static const Color ovulation = Color(0xFFFF5E7E);  // Menstrual Pink (Primary)
  static const Color luteal = Color(0xFFB4A8D3);    // Calming Purple

  // AI & Feedback
  static const Color aiSparkStart = Color(0xFFFF8CA0);
  static const Color aiSparkEnd = Color(0xFFFF5E7E);
  
  static Color getPhaseColor(String phase) {
    switch (phase.toLowerCase()) {
      case 'menstrual':
        return menstrual;
      case 'follicular':
        return follicular;
      case 'ovulation':
        return ovulation;
      case 'luteal':
        return luteal;
      default:
        return luteal;
    }
  }
}
