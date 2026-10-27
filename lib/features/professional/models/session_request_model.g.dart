// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_request_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionRequestModelAdapter extends TypeAdapter<SessionRequestModel> {
  @override
  final int typeId = 12;

  @override
  SessionRequestModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionRequestModel(
      id: fields[0] as int,
      userId: fields[1] as int,
      professionalId: fields[2] as int?,
      centerId: fields[3] as int?,
      wilayaId: fields[4] as int,
      requestedDate: fields[5] as DateTime,
      preferredTime: fields[6] as String?,
      sessionType: fields[7] as String?,
      userMessage: fields[8] as String?,
      status: fields[9] as SessionRequestStatus,
      consentGiven: fields[10] as bool,
      consentDate: fields[11] as DateTime?,
      consentVersion: fields[12] as String?,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SessionRequestModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.professionalId)
      ..writeByte(3)
      ..write(obj.centerId)
      ..writeByte(4)
      ..write(obj.wilayaId)
      ..writeByte(5)
      ..write(obj.requestedDate)
      ..writeByte(6)
      ..write(obj.preferredTime)
      ..writeByte(7)
      ..write(obj.sessionType)
      ..writeByte(8)
      ..write(obj.userMessage)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.consentGiven)
      ..writeByte(11)
      ..write(obj.consentDate)
      ..writeByte(12)
      ..write(obj.consentVersion)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionRequestModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SessionRequestStatusAdapter extends TypeAdapter<SessionRequestStatus> {
  @override
  final int typeId = 11;

  @override
  SessionRequestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SessionRequestStatus.PENDING;
      case 1:
        return SessionRequestStatus.ACCEPTED;
      case 2:
        return SessionRequestStatus.REJECTED;
      case 3:
        return SessionRequestStatus.CANCELLED;
      case 4:
        return SessionRequestStatus.COMPLETED;
      default:
        return SessionRequestStatus.PENDING;
    }
  }

  @override
  void write(BinaryWriter writer, SessionRequestStatus obj) {
    switch (obj) {
      case SessionRequestStatus.PENDING:
        writer.writeByte(0);
        break;
      case SessionRequestStatus.ACCEPTED:
        writer.writeByte(1);
        break;
      case SessionRequestStatus.REJECTED:
        writer.writeByte(2);
        break;
      case SessionRequestStatus.CANCELLED:
        writer.writeByte(3);
        break;
      case SessionRequestStatus.COMPLETED:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionRequestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
