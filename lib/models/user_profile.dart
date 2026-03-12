import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  DateTime onboardingDate;

  @HiveField(1)
  int averageCycleLength;

  @HiveField(2)
  int averagePeriodLength;

  @HiveField(3)
  List<String> symptomsToTrack;

  @HiveField(4)
  bool isPremium;

  UserProfile({
    required this.onboardingDate,
    this.averageCycleLength = 28,
    this.averagePeriodLength = 5,
    this.symptomsToTrack = const [],
    this.isPremium = false,
  });
}
