class CycleCalculator {
  /// Defines standard cycle phases
  static const String menstrual = 'Menstrual Phase';
  static const String follicular = 'Follicular Phase';
  static const String ovulation = 'Ovulation Window';
  static const String luteal = 'Luteal Phase';

  /// Detects period starts in history and calculates the average cycle length.
  /// Logic: Look for the first day of "Period" clusters.
  static int calculateAverageCycleLength(List<DailyLog> history, int defaultLength) {
    if (history.length < 30) return defaultLength; // Need at least ~1 cycle of data

    final periodStarts = <DateTime>[];
    DateTime? lastDate;

    // Sort history by date
    final sortedLogs = List<DailyLog>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    for (var log in sortedLogs) {
      final hasPeriod = log.symptoms.contains('Period');
      if (hasPeriod) {
        // If it's a new period start (more than 10 days since the last period day)
        if (lastDate == null || log.date.difference(lastDate).inDays > 10) {
          periodStarts.add(log.date);
        }
        lastDate = log.date;
      }
    }

    if (periodStarts.length < 2) return defaultLength;

    int totalDays = 0;
    int intervals = 0;

    for (int i = 1; i < periodStarts.length; i++) {
      final gap = periodStarts[i].difference(periodStarts[i - 1]).inDays;
      if (gap >= 20 && gap <= 45) { // Sanity check for realistic cycles
        totalDays += gap;
        intervals++;
      }
    }

    return intervals > 0 ? (totalDays / intervals).round() : defaultLength;
  }

  /// Calculate the current phase based on the start date of the last period
  /// and the user's average cycle length.
  static String getCurrentPhase(DateTime lastPeriodStart, int cycleLength, int periodLength, {DateTime? targetDate}) {
    final date = targetDate ?? DateTime.now();
    // Normalize dates to midnight for consistent day counting
    final normalizedLastPeriodStart = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final normalizedTargetDate = DateTime(date.year, date.month, date.day);
    
    final difference = normalizedTargetDate.difference(normalizedLastPeriodStart).inDays;
    
    // Day of cycle is 1-indexed (e.g., the day period starts is Day 1)
    final dayOfCycle = getCycleDayForDate(normalizedLastPeriodStart, normalizedTargetDate, cycleLength);

    // Approximate phase lengths based on scientific averages adapted to user's cycle length
     
    // 1. Menstrual Phase (Days 1 - averagePeriodLength)
    if (dayOfCycle <= periodLength) {
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

  /// Centralized logic for calculating day of cycle
  static int getCycleDayForDate(DateTime lastPeriodStart, DateTime targetDate, int cycleLength) {
    final anchor = DateTime(lastPeriodStart.year, lastPeriodStart.month, lastPeriodStart.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final difference = target.difference(anchor).inDays;
    return (difference % cycleLength) + 1;
  }
}
