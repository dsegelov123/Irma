import 'package:flutter_test/flutter_test.dart';
import 'package:irma/services/cycle_calculator.dart';

void main() {
  group('CycleCalculator Tests', () {
    test('Calculates Menstrual Phase correctly', () {
      final lastPeriod = DateTime.now().subtract(const Duration(days: 2));
      final phase = CycleCalculator.getCurrentPhase(lastPeriod, 28, 5);
      expect(phase, CycleCalculator.menstrual);
    });

    test('Calculates Follicular Phase correctly', () {
      final lastPeriod = DateTime.now().subtract(const Duration(days: 7));
      final phase = CycleCalculator.getCurrentPhase(lastPeriod, 28, 5);
      expect(phase, CycleCalculator.follicular);
    });

    test('Calculates Ovulation Window correctly', () {
      final lastPeriod = DateTime.now().subtract(const Duration(days: 14));
      final phase = CycleCalculator.getCurrentPhase(lastPeriod, 28, 5);
      expect(phase, CycleCalculator.ovulation);
    });

    test('Calculates Luteal Phase correctly', () {
      final lastPeriod = DateTime.now().subtract(const Duration(days: 22));
      final phase = CycleCalculator.getCurrentPhase(lastPeriod, 28, 5);
      expect(phase, CycleCalculator.luteal);
    });

    test('Predicts next period correctly', () {
      final lastPeriod = DateTime(2026, 3, 1);
      final nextPeriod = CycleCalculator.predictNextPeriod(lastPeriod, 30);
      expect(nextPeriod, DateTime(2026, 3, 31));
    });
  });
}
