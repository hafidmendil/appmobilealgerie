// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecurityLogAdapter extends TypeAdapter<SecurityLog> {
  @override
  final int typeId = 8;

  @override
  SecurityLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecurityLog(
      id: fields[0] as String,
      actorId: fields[1] as String,
      actorRole: fields[2] as String,
      action: fields[3] as String,
      targetId: fields[4] as String?,
      timestamp: fields[5] as DateTime,
      status: fields[6] as String,
      metadata: (fields[7] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SecurityLog obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.actorId)
      ..writeByte(2)
      ..write(obj.actorRole)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.targetId)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecurityLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
