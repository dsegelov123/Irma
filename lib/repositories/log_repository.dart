import 'package:hive_flutter/hive_flutter.dart';
import '../models/daily_log.dart';

class LogRepository {
  final Box<DailyLog> _box;

  LogRepository(this._box);

  List<DailyLog> getAllLogs() {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> saveLog(DailyLog log) async {
    // Key logs by date string YYYY-MM-DD for uniqueness
    final key = "${log.date.year}-${log.date.month}-${log.date.day}";
    await _box.put(key, log);
  }

  DailyLog? getLogForDate(DateTime date) {
    final key = "${date.year}-${date.month}-${date.day}";
    return _box.get(key);
  }
}
