// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confidence_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfidenceEntryAdapter extends TypeAdapter<ConfidenceEntry> {
  @override
  final int typeId = 9;

  @override
  ConfidenceEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfidenceEntry(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      strength: fields[2] as String,
      success: fields[3] as String,
      goal: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConfidenceEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.strength)
      ..writeByte(3)
      ..write(obj.success)
      ..writeByte(4)
      ..write(obj.goal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfidenceEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
