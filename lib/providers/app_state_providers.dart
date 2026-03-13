import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';
import '../models/daily_log.dart';
import '../models/cycle_data.dart';
import '../repositories/user_repository.dart';
import '../repositories/log_repository.dart';
import '../services/subscription_service.dart';

// Repositories
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final box = Hive.box<UserProfile>('userProfileBox');
  return UserRepository(box);
});

final logRepositoryProvider = Provider<LogRepository>((ref) {
  final box = Hive.box<DailyLog>('dailyLogBox');
  return LogRepository(box);
});

// State Providers
final userProfileProvider = StateProvider<UserProfile?>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getUserProfile();
});

final dailyLogsProvider = StateProvider<List<DailyLog>>((ref) {
  final repo = ref.watch(logRepositoryProvider);
  return repo.getAllLogs();
});

// Initialization Provider
final appInitializedProvider = FutureProvider<bool>((ref) async {
  try {
    // Open boxes
    if (!Hive.isBoxOpen('userProfileBox')) {
      await Hive.openBox<UserProfile>('userProfileBox');
    }
    if (!Hive.isBoxOpen('dailyLogBox')) {
      await Hive.openBox<DailyLog>('dailyLogBox');
    }

    // Initialize Subscription Service (RevenueCat)
    await SubscriptionService.init();

    return true;
  } catch (e) {
    debugPrint('Initialization error: $e');
    return false;
  }
});
