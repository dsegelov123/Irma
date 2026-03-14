// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irma_cycle_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmaCycleDataAdapter extends TypeAdapter<IrmaCycleData> {
  @override
  final int typeId = 11;

  @override
  IrmaCycleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmaCycleData(
      lastPeriodDate: fields[0] as DateTime,
      avgCycleLength: fields[1] as int,
      avgPeriodLength: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, IrmaCycleData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lastPeriodDate)
      ..writeByte(1)
      ..write(obj.avgCycleLength)
      ..writeByte(2)
      ..write(obj.avgPeriodLength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmaCycleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IrmaCyclePhaseAdapter extends TypeAdapter<IrmaCyclePhase> {
  @override
  final int typeId = 10;

  @override
  IrmaCyclePhase read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IrmaCyclePhase.menstrual;
      case 1:
        return IrmaCyclePhase.follicular;
      case 2:
        return IrmaCyclePhase.ovulation;
      case 3:
        return IrmaCyclePhase.luteal;
      default:
        return IrmaCyclePhase.menstrual;
    }
  }

  @override
  void write(BinaryWriter writer, IrmaCyclePhase obj) {
    switch (obj) {
      case IrmaCyclePhase.menstrual:
        writer.writeByte(0);
        break;
      case IrmaCyclePhase.follicular:
        writer.writeByte(1);
        break;
      case IrmaCyclePhase.ovulation:
        writer.writeByte(2);
        break;
      case IrmaCyclePhase.luteal:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmaCyclePhaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
