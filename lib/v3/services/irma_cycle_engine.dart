import '../models/irma_cycle_data.dart';

class IrmaCycleState {
  final int currentDay;
  final int totalDays;
  final IrmaCyclePhase phase;
  final String phaseDescription;

  IrmaCycleState({
    required this.currentDay,
    required this.totalDays,
    required this.phase,
    required this.phaseDescription,
  });
}

class IrmaCycleEngine {
  static IrmaCycleState calculateState(IrmaCycleData data, DateTime today) {
    final difference = today.isBefore(data.lastPeriodDate) 
        ? 0 
        : today.difference(data.lastPeriodDate).inDays;
    
    final currentDay = (difference % data.avgCycleLength) + 1;
    final cycleLength = data.avgCycleLength;
    final periodLength = data.avgPeriodLength;
    final ovulationDay = cycleLength - 14;

    IrmaCyclePhase phase;
    String description;

    if (currentDay <= periodLength) {
      phase = IrmaCyclePhase.menstrual;
      description = "Your cycle is starting. Focus on rest and iron-rich foods.";
    } else if (currentDay < ovulationDay) {
      phase = IrmaCyclePhase.follicular;
      description = "Energy levels are rising. A great time for new projects.";
    } else if (currentDay == ovulationDay) {
      phase = IrmaCyclePhase.ovulation;
      description = "Peak fertility. You may feel more social and vibrant.";
    } else {
      phase = IrmaCyclePhase.luteal;
      description = "Progesterone is rising. Prioritize self-care and gentle movement.";
    }

    return IrmaCycleState(
      currentDay: currentDay,
      totalDays: cycleLength,
      phase: phase,
      phaseDescription: description,
    );
  }
}
