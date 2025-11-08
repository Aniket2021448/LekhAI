// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlipAdapter extends TypeAdapter<Slip> {
  @override
  final int typeId = 0;

  @override
  Slip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Slip(
      customerName: fields[0] as String,
      date: fields[1] as DateTime,
      imagePath: fields[2] as String,
      structuredData: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Slip obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.customerName)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.structuredData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
