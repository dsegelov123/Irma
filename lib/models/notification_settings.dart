import 'package:hive/hive.dart';

part 'notification_settings.g.dart';

@HiveType(typeId: 5)
enum NotificationFrequency {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

@HiveType(typeId: 6)
class NotificationSettings extends HiveObject {
  @HiveField(0)
  bool isEnabled;

  @HiveField(1)
  bool isPrivateMode;

  @HiveField(2)
  NotificationFrequency frequency;

  NotificationSettings({
    this.isEnabled = true,
    this.isPrivateMode = false,
    this.frequency = NotificationFrequency.high,
  });
}
