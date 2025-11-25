// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaveTypeModelAdapter extends TypeAdapter<LeaveTypeModel> {
  @override
  final int typeId = 2;

  @override
  LeaveTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LeaveTypeModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      isImgRequired: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, LeaveTypeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isImgRequired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaveTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
