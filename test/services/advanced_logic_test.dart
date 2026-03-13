import 'package:flutter_test/flutter_test.dart';
import 'package:irma/services/cycle_calculator.dart';
import 'package:irma/models/daily_log.dart';

void main() {
  group('CycleCalculator Advanced Logic', () {
    test('calculateAverageCycleLength should return default length for small history', () {
      final logs = <DailyLog>[];
      final result = CycleCalculator.calculateAverageCycleLength(logs, 28);
      expect(result, 28);
    });

    test('calculateAverageCycleLength should detect intervals correctly', () {
      final now = DateTime.now();
      final logs = <DailyLog>[
        // Period 1 (30 days ago)
        DailyLog(date: now.subtract(const Duration(days: 30)), energyLevel: 3, mood: '😊', symptoms: ['Period']),
        // Period 2 (60 days ago)
        DailyLog(date: now.subtract(const Duration(days: 60)), energyLevel: 3, mood: '😊', symptoms: ['Period']),
        // Padding logs to reach the 30-log threshold
        ...List.generate(30, (i) => DailyLog(date: now.subtract(Duration(days: i + 100)), energyLevel: 3, mood: '😐'))
      ];

      final result = CycleCalculator.calculateAverageCycleLength(logs, 28);
      // Gap between 30 and 60 is 30 days
      expect(result, 30);
    });
  });
}
