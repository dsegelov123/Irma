// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingsAdapter extends TypeAdapter<NotificationSettings> {
  @override
  final int typeId = 6;

  @override
  NotificationSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSettings(
      isEnabled: fields[0] as bool,
      isPrivateMode: fields[1] as bool,
      frequency: fields[2] as NotificationFrequency,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSettings obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.isPrivateMode)
      ..writeByte(2)
      ..write(obj.frequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationFrequencyAdapter extends TypeAdapter<NotificationFrequency> {
  @override
  final int typeId = 5;

  @override
  NotificationFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationFrequency.low;
      case 1:
        return NotificationFrequency.medium;
      case 2:
        return NotificationFrequency.high;
      default:
        return NotificationFrequency.low;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationFrequency obj) {
    switch (obj) {
      case NotificationFrequency.low:
        writer.writeByte(0);
        break;
      case NotificationFrequency.medium:
        writer.writeByte(1);
        break;
      case NotificationFrequency.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
