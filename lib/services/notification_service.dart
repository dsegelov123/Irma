import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/notification_settings.dart';
import '../models/user_profile.dart';
import 'cycle_calculator.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<bool> requestPermissions() async {
    final bool? result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    return result ?? false;
  }

  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> rescheduleAllNotifications(UserProfile profile, int personalizedCycleLength) async {
    await cancelAll();
    
    if (profile.notificationSettings == null || !profile.notificationSettings!.isEnabled) return;

    final now = DateTime.now();

    // Reschedule for the next 7 days based on phase
    for (int i = 0; i < 7; i++) {
      final targetDate = now.add(Duration(days: i));
      
      // Use the newly refactored getCurrentPhase with the specific future date
      final targetPhase = CycleCalculator.getCurrentPhase(
        profile.onboardingDate, 
        personalizedCycleLength, 
        profile.averagePeriodLength,
        targetDate: targetDate,
      );

      final isPrivate = profile.notificationSettings!.isPrivateMode;
      String title = isPrivate ? "Irma: Moment of Zen" : "Auntie Irma's Wisdom";
      String body = isPrivate 
          ? "Time for your daily check-in." 
          : _getPersonaMessage(targetPhase);

      await _scheduleNotification(
        id: i,
        title: title,
        body: body,
        scheduledDate: DateTime(targetDate.year, targetDate.month, targetDate.day, 9, 0), // 9 AM
      );
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // In a production app, we would use tz.TZDateTime.now() and tz.local
    // For this MVP, we use the standard notification details.
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'irma_nudges',
      'Auntie Nudges',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Note: To use zonedSchedule, we'd need to initialize timezone package.
    // For this demonstration, we'll use a simpler show() if it's today,
    // though in reality we'd use themed scheduling.
    if (scheduledDate.day == DateTime.now().day) {
        await _notificationsPlugin.show(id, title, body, platformDetails);
    }
  }

  static String _getPersonaMessage(String phase) {
    switch (phase) {
      case CycleCalculator.menstrual:
        return "I've put the kettle on. A bit of rest today is exactly what you need.";
      case CycleCalculator.follicular:
        return "You're sparky today! Perfect time for that project.";
      case CycleCalculator.ovulation:
        return "The world is your oyster today, love. You're radiant.";
      case CycleCalculator.luteal:
        return "Steady as she goes. A quiet evening will do wonders.";
      default:
        return "Just a little nudge to check in with yourself today.";
    }
  }
}
