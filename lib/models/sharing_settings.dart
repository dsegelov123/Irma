import 'package:hive/hive.dart';

part 'sharing_settings.g.dart';

@HiveType(typeId: 3)
class SharingSettings extends HiveObject {
  @HiveField(0)
  bool isEnabled;

  @HiveField(1)
  bool sharePhase;

  @HiveField(2)
  bool shareMood;

  @HiveField(3)
  bool shareSymptoms;

  @HiveField(4)
  String? partnerUid;

  @HiveField(5)
  String? sharingCode;

  SharingSettings({
    this.isEnabled = false,
    this.sharePhase = true,
    this.shareMood = false,
    this.shareSymptoms = false,
    this.partnerUid,
    this.sharingCode,
  });
}
