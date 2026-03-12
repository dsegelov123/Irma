import 'package:flutter/material.dart';

class WellnessIntegration extends StatelessWidget {
  final String currentPhase;

  const WellnessIntegration({
    super.key, 
    required this.currentPhase,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle Syncing'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wellness for your $currentPhase',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Based on your current hormones, here are personalized recommendations to optimize your energy and mood today.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 32),

              _buildRecommendationCard(
                context,
                icon: Icons.self_improvement,
                title: 'Mindfulness',
                description: 'A 5-minute grounding meditation to help stabilize mood swings typical in this phase.',
                color: const Color(0xFFB4A8D3),
              ),
              const SizedBox(height: 16),

              _buildRecommendationCard(
                context,
                icon: Icons.fitness_center,
                title: 'Movement',
                description: 'Low-impact yoga or walking. Avoid high-intensity workouts today to prioritize recovery.',
                color: const Color(0xFF98D8D8),
              ),
              const SizedBox(height: 16),

              _buildRecommendationCard(
                context,
                icon: Icons.restaurant,
                title: 'Nutrition',
                description: 'Focus on magnesium-rich foods like dark chocolate or spinach to help reduce cramping.',
                color: const Color(0xFFFFB3BA),
              ),
            ],
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey.shade800, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
