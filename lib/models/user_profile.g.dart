// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      onboardingDate: fields[0] as DateTime,
      averageCycleLength: fields[1] as int,
      averagePeriodLength: fields[2] as int,
      symptomsToTrack: (fields[3] as List).cast<String>(),
      isPremium: fields[4] as bool,
      lastInsight: fields[5] as String?,
      lastInsightDate: fields[6] as DateTime?,
      sharingSettings: fields[7] as SharingSettings?,
      notificationSettings: fields[8] as NotificationSettings?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.onboardingDate)
      ..writeByte(1)
      ..write(obj.averageCycleLength)
      ..writeByte(2)
      ..write(obj.averagePeriodLength)
      ..writeByte(3)
      ..write(obj.symptomsToTrack)
      ..writeByte(4)
      ..write(obj.isPremium)
      ..writeByte(5)
      ..write(obj.lastInsight)
      ..writeByte(6)
      ..write(obj.lastInsightDate)
      ..writeByte(7)
      ..write(obj.sharingSettings)
      ..writeByte(8)
      ..write(obj.notificationSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
