import 'package:flutter/material.dart';
import '../models/recommendation.dart';
import 'cycle_calculator.dart';

class RecommendationService {
  static const List<Recommendation> _allRecommendations = [
    // Menstrual Phase
    Recommendation(
      title: 'Iron-Rich Foods',
      description: 'Focus on spinach, lentils, and red meat to replenish iron lost during your period.',
      icon: Icons.restaurant,
      category: RecommendationCategory.nutrition,
      targetPhase: CycleCalculator.menstrual,
    ),
    Recommendation(
      title: 'Gentle Stretching',
      description: 'Restorative yoga or light stretching can help alleviate pelvic congestion and cramps.',
      icon: Icons.fitness_center,
      category: RecommendationCategory.movement,
      targetPhase: CycleCalculator.menstrual,
    ),
    Recommendation(
      title: 'Grounding Meditation',
      description: 'A 5-minute meditation focusing on your breath to help manage period-related fatigue.',
      icon: Icons.self_improvement,
      category: RecommendationCategory.mindfulness,
      targetPhase: CycleCalculator.menstrual,
    ),

    // Follicular Phase
    Recommendation(
      title: 'Fermented Foods',
      description: 'Support your gut and estrogen metabolism with kimchi, sauerkraut, or kefir.',
      icon: Icons.restaurant,
      category: RecommendationCategory.nutrition,
      targetPhase: CycleCalculator.follicular,
    ),
    Recommendation(
      title: 'New Challenges',
      description: 'Your energy is rising! Try a new workout class or a challenging hike today.',
      icon: Icons.fitness_center,
      category: RecommendationCategory.movement,
      targetPhase: CycleCalculator.follicular,
    ),
    Recommendation(
      title: 'Creativity Boost',
      description: 'This is the best time for brainstorming. Spend 10 minutes journaling your ideas.',
      icon: Icons.edit,
      category: RecommendationCategory.mindfulness,
      targetPhase: CycleCalculator.follicular,
    ),

    // Ovulation Window
    Recommendation(
      title: 'Anti-inflammatory',
      description: 'Berries and omega-3s are great for supporting your high-energy ovulation window.',
      icon: Icons.restaurant,
      category: RecommendationCategory.nutrition,
      targetPhase: CycleCalculator.ovulation,
    ),
    Recommendation(
      title: 'High Intensity',
      description: 'Your strength and coordination are at their peak. Great day for HIIT or heavy lifting.',
      icon: Icons.flash_on,
      category: RecommendationCategory.movement,
      targetPhase: CycleCalculator.ovulation,
    ),
    Recommendation(
      title: 'Social Connection',
      description: 'You are naturally more communicative. Reach out to a friend or collaborate on a project.',
      icon: Icons.groups,
      category: RecommendationCategory.mindfulness,
      targetPhase: CycleCalculator.ovulation,
    ),

    // Luteal Phase
    Recommendation(
      title: 'Complex Carbs',
      description: 'Stabilize blood sugar with sweet potatoes and quinoa to help reduce PMS cravings.',
      icon: Icons.restaurant,
      category: RecommendationCategory.nutrition,
      targetPhase: CycleCalculator.luteal,
    ),
    Recommendation(
      title: 'Low Impact',
      description: 'Prioritize recovery. Walking, Pilates, or swimming are ideal as your body prepares for rest.',
      icon: Icons.pool,
      category: RecommendationCategory.movement,
      targetPhase: CycleCalculator.luteal,
    ),
    Recommendation(
      title: 'Nested Rest',
      description: 'Prioritize sleep and solo time. Try a Yoga Nidra session before bed.',
      icon: Icons.bed,
      category: RecommendationCategory.mindfulness,
      targetPhase: CycleCalculator.luteal,
    ),
  ];

  static List<Recommendation> getRecommendationsForPhase(String phase) {
    return _allRecommendations.where((r) => r.targetPhase == phase).toList();
  }
}
