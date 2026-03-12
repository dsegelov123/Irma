import 'package:hive/hive.dart';

part 'cycle_data.g.dart';

@HiveType(typeId: 2)
class CycleData extends HiveObject {
  @HiveField(0)
  DateTime startDate; // First day of the period

  @HiveField(1)
  DateTime? endDate; // Last day of the period (null if ongoing)

  @HiveField(2)
  int cycleLength; // Length of the entire cycle in days

  CycleData({
    required this.startDate,
    this.endDate,
    required this.cycleLength,
  });

  // Helper method to check if the period is currently ongoing
  bool get isOngoing => endDate == null;
}
