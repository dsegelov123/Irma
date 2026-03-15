// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irma_user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IrmaUserAdapter extends TypeAdapter<IrmaUser> {
  @override
  final int typeId = 13;

  @override
  IrmaUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IrmaUser(
      name: fields[0] as String,
      dob: fields[1] as DateTime?,
      goals: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, IrmaUser obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.dob)
      ..writeByte(2)
      ..write(obj.goals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IrmaUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
