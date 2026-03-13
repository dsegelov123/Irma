import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../models/daily_log.dart';
import '../models/user_profile.dart';

class ExportService {
  static Future<void> exportToCsv(UserProfile profile, List<DailyLog> logs) async {
    List<List<dynamic>> rows = [];

    // Header row
    rows.add([
      "Date",
      "Cycle Day",
      "Mood",
      "Energy Level",
      "Symptoms",
    ]);

    // Data rows
    for (var log in logs) {
      final cycleDay = (log.date.difference(profile.onboardingDate).inDays % 
                        profile.averageCycleLength) + 1;
      
      rows.add([
        DateFormat('yyyy-MM-dd').format(log.date),
        cycleDay,
        log.moodEmoji,
        log.energyLevel,
        log.symptoms.join(", "),
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/irma_data_export_${DateTime.now().millisecondsSinceEpoch}.csv";
    final file = File(path);
    
    await file.writeAsString(csvData);

    await Share.shareXFiles(
      [XFile(path)], 
      text: 'My Irma Health Data Export',
      subject: 'Irma Health Data Export',
    );
  }
}
