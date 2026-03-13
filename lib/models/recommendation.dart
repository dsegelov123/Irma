import 'package:flutter/material.dart';

enum RecommendationCategory { nutrition, movement, mindfulness }

class Recommendation {
  final String title;
  final String description;
  final IconData icon;
  final RecommendationCategory category;
  final String targetPhase;

  const Recommendation({
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.targetPhase,
  });
}
