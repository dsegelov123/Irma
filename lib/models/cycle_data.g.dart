// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cycle_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CycleDataAdapter extends TypeAdapter<CycleData> {
  @override
  final int typeId = 2;

  @override
  CycleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CycleData(
      startDate: fields[0] as DateTime,
      endDate: fields[1] as DateTime?,
      cycleLength: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CycleData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(1)
      ..write(obj.endDate)
      ..writeByte(2)
      ..write(obj.cycleLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
