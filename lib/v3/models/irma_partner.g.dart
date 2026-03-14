// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irma_partner.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmaPartnerAdapter extends TypeAdapter<IrmaPartner> {
  @override
  final int typeId = 31;

  @override
  IrmaPartner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmaPartner(
      id: fields[0] as String?,
      name: fields[1] as String,
      inviteCode: fields[2] as String?,
      status: fields[3] as PartnerStatus,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IrmaPartner obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.inviteCode)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmaPartnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartnerStatusAdapter extends TypeAdapter<PartnerStatus> {
  @override
  final int typeId = 30;

  @override
  PartnerStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartnerStatus.pending;
      case 1:
        return PartnerStatus.connected;
      case 2:
        return PartnerStatus.disconnected;
      default:
        return PartnerStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, PartnerStatus obj) {
    switch (obj) {
      case PartnerStatus.pending:
        writer.writeByte(0);
        break;
      case PartnerStatus.connected:
        writer.writeByte(1);
        break;
      case PartnerStatus.disconnected:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
