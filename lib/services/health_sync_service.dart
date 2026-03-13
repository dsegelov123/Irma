import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/foundation.dart';

class HealthSyncService {
  static final Health _health = Health();

  static final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
  ];

  static Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    // Request activity recognition permission first (mostly for Android)
    await Permission.activityRecognition.request();
    
    // Request Health permissions
    bool? hasPermissions = await _health.hasPermissions(_types);
    if (hasPermissions != true) {
      hasPermissions = await _health.requestAuthorization(_types);
    }
    return hasPermissions ?? false;
  }

  static Future<Map<String, dynamic>> fetchDailyContext() async {
    if (kIsWeb) {
      return {
        'steps': 0,
        'sleepHours': 0.0,
        'latestPeriodStart': null,
        'rawDataCount': 0,
      };
    }
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
      startTime: yesterday,
      endTime: now,
      types: _types,
    );

    int steps = 0;
    double sleepHours = 0;
    DateTime? latestPeriodStart;

    for (var point in healthData) {
      if (point.type == HealthDataType.STEPS) {
        steps += (point.value as NumericHealthValue).numericValue.toInt();
      } else if (point.type == HealthDataType.SLEEP_ASLEEP) {
        final duration = point.dateTo.difference(point.dateFrom);
        sleepHours += duration.inMinutes / 60.0;
      }
    }

    return {
      'steps': steps,
      'sleepHours': sleepHours.toDouble(),
      'latestPeriodStart': latestPeriodStart,
      'rawDataCount': healthData.length,
    };
  }
}
