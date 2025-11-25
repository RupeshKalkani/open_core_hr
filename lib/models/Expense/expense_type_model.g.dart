// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseTypeModelAdapter extends TypeAdapter<ExpenseTypeModel> {
  @override
  final int typeId = 3;

  @override
  ExpenseTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseTypeModel(
      id: fields[0] as dynamic,
      name: fields[1] as dynamic,
      isImgRequired: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseTypeModel obj) {
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
      other is ExpenseTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
