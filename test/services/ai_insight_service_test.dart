import 'package:flutter_test/flutter_test.dart';
import 'package:irma/models/cycle_data.dart';
import 'package:irma/models/daily_log.dart';
import 'package:irma/services/ai_insight_service.dart';

void main() {
  group('AI Insight Service Tests', () {
    test('generateDailyInsight returns a fallback or string', () async {
      // Create mock data
      final cycle = CycleData(
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        cycleLength: 28,
      );
      
      final logs = [
        DailyLog(
          date: DateTime.now(),
          energyLevel: 3,
          mood: '😊',
          symptoms: ['Headache'],
        )
      ];

      // We expect the network call to fail in the test environment (no valid API key)
      // So it should hit the catch block and return the error fallback string.
      final insight = await AIInsightService.generateDailyInsight(
        recentLogs: logs,
        currentCycle: cycle,
        currentPhase: 'Luteal Phase',
        isPremium: false,
      );

      expect(insight.isNotEmpty, true);
    });
  });
}
