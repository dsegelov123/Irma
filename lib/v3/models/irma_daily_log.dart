import 'package:hive/hive.dart';

part 'irma_daily_log.g.dart';

@HiveType(typeId: 20)
class IrmaDailyLog extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final List<String> symptoms; // e.g., "Cramps", "Headache", "Mood Swings"

  @HiveField(2)
  final double? waterLiters;

  @HiveField(3)
  final double? weightKg;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final String? flowIntensity; // e.g., "Light", "Medium", "Heavy"

  IrmaDailyLog({
    required this.date,
    this.symptoms = const [],
    this.waterLiters,
    this.weightKg,
    this.note,
    this.flowIntensity,
  });
}
