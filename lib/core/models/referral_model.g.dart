// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReferralAdapter extends TypeAdapter<Referral> {
  @override
  final int typeId = 108;

  @override
  Referral read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Referral(
      id: fields[0] as String,
      userId: fields[1] as String?,
      anonymousSessionId: fields[2] as String?,
      partnerId: fields[3] as String,
      status: fields[4] as ReferralStatus,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      consentId: fields[7] as String?,
      assessmentResultId: fields[8] as String?,
      notes: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Referral obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.anonymousSessionId)
      ..writeByte(3)
      ..write(obj.partnerId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.consentId)
      ..writeByte(8)
      ..write(obj.assessmentResultId)
      ..writeByte(9)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReferralAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
