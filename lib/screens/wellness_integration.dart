import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import '../services/cycle_calculator.dart';
import '../services/recommendation_service.dart';
import '../models/recommendation.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';

class WellnessIntegration extends ConsumerWidget {
  final String? currentPhase;

  const WellnessIntegration({
    super.key, 
    this.currentPhase,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    
    if (profile == null) {
      return const Scaffold(body: Center(child: Text('Profile not found.')));
    }

    final phase = currentPhase ?? CycleCalculator.getCurrentPhase(
      profile.onboardingDate, 
      profile.averageCycleLength, 
      profile.averagePeriodLength
    );

    final recommendations = RecommendationService.getRecommendationsForPhase(phase);
    final themeColor = AppColors.getPhaseColor(phase);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Syncing'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: themeColor.withOpacity(0.05),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness for your $phase',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Auntie Irma\'s suggestions for optimizing your energy and mood today, based on your current hormonal context.',
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 32),

                if (recommendations.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text('No recommendations found for this phase.', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                else
                  ...recommendations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final rec = entry.value;
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 600 + (index * 200)),
                      curve: Curves.easeOutQuart,
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildRecommendationCard(
                                context,
                                icon: rec.icon,
                                title: rec.title,
                                description: rec.description,
                                color: themeColor,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      border: Border.all(color: color.withOpacity(0.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
