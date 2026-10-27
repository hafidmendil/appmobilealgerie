// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentRecordAdapter extends TypeAdapter<AssessmentRecord> {
  @override
  final int typeId = 2;

  @override
  AssessmentRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssessmentRecord(
      id: fields[0] as String,
      userId: fields[1] as String?,
      answers: (fields[2] as Map).cast<String, int>(),
      safetyAnswers: (fields[3] as Map).cast<String, bool>(),
      createdAt: fields[4] as DateTime,
      syncStatus: fields[5] as String,
      finalMessage: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.answers)
      ..writeByte(3)
      ..write(obj.safetyAnswers)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.syncStatus)
      ..writeByte(6)
      ..write(obj.finalMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
