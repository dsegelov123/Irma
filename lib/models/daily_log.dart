import 'package:hive/hive.dart';

part 'daily_log.g.dart';

@HiveType(typeId: 1)
class DailyLog extends HiveObject {
  @HiveField(0)
  DateTime date; // Only down to the day level

  @HiveField(1)
  int energyLevel; // 1 to 5 scale

  @HiveField(2)
  String mood; // Emojis like "😊"

  @HiveField(3)
  List<String> symptoms; // E.g. ['Headache', 'Cramps']

  @HiveField(4)
  String? journalEntry; // Optional premium input

  DailyLog({
    required this.date,
    required this.energyLevel,
    required this.mood,
    this.symptoms = const [],
    this.journalEntry,
  });
}
