// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SharingSettingsAdapter extends TypeAdapter<SharingSettings> {
  @override
  final int typeId = 3;

  @override
  SharingSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SharingSettings(
      isEnabled: fields[0] as bool,
      sharePhase: fields[1] as bool,
      shareMood: fields[2] as bool,
      shareSymptoms: fields[3] as bool,
      partnerUid: fields[4] as String?,
      sharingCode: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SharingSettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.isEnabled)
      ..writeByte(1)
      ..write(obj.sharePhase)
      ..writeByte(2)
      ..write(obj.shareMood)
      ..writeByte(3)
      ..write(obj.shareSymptoms)
      ..writeByte(4)
      ..write(obj.partnerUid)
      ..writeByte(5)
      ..write(obj.sharingCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharingSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
