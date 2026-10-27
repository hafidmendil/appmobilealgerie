// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anonymous_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnonymousSessionAdapter extends TypeAdapter<AnonymousSession> {
  @override
  final int typeId = 100;

  @override
  AnonymousSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnonymousSession(
      id: fields[0] as String,
      createdAt: fields[1] as DateTime,
      expiresAt: fields[2] as DateTime,
      locale: fields[3] as String,
      wilayaId: fields[4] as String?,
      communeId: fields[5] as String?,
      consentState: (fields[6] as Map).cast<ConsentType, ConsentStatus>(),
    );
  }

  @override
  void write(BinaryWriter writer, AnonymousSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.expiresAt)
      ..writeByte(3)
      ..write(obj.locale)
      ..writeByte(4)
      ..write(obj.wilayaId)
      ..writeByte(5)
      ..write(obj.communeId)
      ..writeByte(6)
      ..write(obj.consentState);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnonymousSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
