class CycleCalculator {
  /// Defines standard cycle phases
  static const String menstrual = 'Menstrual Phase';
  static const String follicular = 'Follicular Phase';
  static const String ovulation = 'Ovulation Window';
  static const String luteal = 'Luteal Phase';

  /// Calculate the current phase based on the start date of the last period
  /// and the user's average cycle length.
  static String getCurrentPhase(DateTime lastPeriodStart, int averageCycleLength, int averagePeriodLength) {
    final now = DateTime.now();
    final difference = now.difference(lastPeriodStart).inDays;
    
    // Day of cycle is 1-indexed (e.g., the day period starts is Day 1)
    final dayOfCycle = (difference % averageCycleLength) + 1;

    // Approximate phase lengths based on scientific averages adapted to user's cycle length
     
    // 1. Menstrual Phase (Days 1 - averagePeriodLength)
    if (dayOfCycle <= averagePeriodLength) {
      return menstrual;
    }

    // Typical ovulation happens ~14 days before the END of the cycle.
    final estimatedOvulationDay = averageCycleLength - 14;
    
    // 2. Ovulation Window (3 days before to 1 day after ovulation)
    final ovulationWindowStart = estimatedOvulationDay - 3;
    final ovulationWindowEnd = estimatedOvulationDay + 1;

    // 3. Luteal Phase (Post-ovulation until next period)
    if (dayOfCycle > ovulationWindowEnd) {
      return luteal;
    }

    // 4. Follicular Phase (Post-period until ovulation window)
    if (dayOfCycle > averagePeriodLength && dayOfCycle < ovulationWindowStart) {
       return follicular;
    }
    
    // Fallback catching the exact window
    if(dayOfCycle >= ovulationWindowStart && dayOfCycle <= ovulationWindowEnd) {
      return ovulation;
    }

    return 'Tracking Phase...';
  }

  /// Predict the start date of the next period
  static DateTime predictNextPeriod(DateTime lastPeriodStart, int averageCycleLength) {
    return lastPeriodStart.add(Duration(days: averageCycleLength));
  }
}
