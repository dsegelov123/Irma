import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_state_providers.dart';
import 'health_sync_service.dart';
import 'notification_service.dart';
import 'cycle_calculator.dart';

class CycleSyncManager {
  final WidgetRef _ref;

  CycleSyncManager(this._ref);

  static final provider = Provider((ref) => CycleSyncManager(ref as WidgetRef));

  Future<void> syncWithHealth() async {
    final profile = _ref.read(userProfileProvider);
    if (profile == null) return;

    final healthContext = await HealthSyncService.fetchDailyContext();
    final DateTime? healthPeriodStart = healthContext['latestPeriodStart'];

    if (healthPeriodStart != null) {
      if (healthPeriodStart.isAfter(profile.onboardingDate)) {
        profile.onboardingDate = healthPeriodStart;
        
        await _ref.read(userRepositoryProvider).saveUserProfile(profile);
        
        final logs = _ref.read(dailyLogsProvider);
        final personalizedLength = CycleCalculator.calculateAverageCycleLength(logs, profile.averageCycleLength);
        await NotificationService.rescheduleAllNotifications(profile, personalizedLength);
        
        _ref.refresh(userProfileProvider);
      }
    }
  }
}
