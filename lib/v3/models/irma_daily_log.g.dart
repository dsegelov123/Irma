// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irma_daily_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmaDailyLogAdapter extends TypeAdapter<IrmaDailyLog> {
  @override
  final int typeId = 20;

  @override
  IrmaDailyLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmaDailyLog(
      date: fields[0] as DateTime,
      symptoms: (fields[1] as List).cast<String>(),
      waterLiters: fields[2] as double?,
      weightKg: fields[3] as double?,
      note: fields[4] as String?,
      flowIntensity: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IrmaDailyLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.symptoms)
      ..writeByte(2)
      ..write(obj.waterLiters)
      ..writeByte(3)
      ..write(obj.weightKg)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.flowIntensity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmaDailyLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
