import 'package:hive/hive.dart';

part 'irma_cycle_data.g.dart';

@HiveType(typeId: 10) // Unique ID for v3 isolation
enum IrmaCyclePhase {
  @HiveField(0)
  menstrual,
  @HiveField(1)
  follicular,
  @HiveField(2)
  ovulation,
  @HiveField(3)
  luteal,
}

@HiveType(typeId: 11)
class IrmaCycleData extends HiveObject {
  @HiveField(0)
  final DateTime lastPeriodDate;

  @HiveField(1)
  final int avgCycleLength;

  @HiveField(2)
  final int avgPeriodLength;

  IrmaCycleData({
    required this.lastPeriodDate,
    this.avgCycleLength = 28,
    this.avgPeriodLength = 5,
  });
}
