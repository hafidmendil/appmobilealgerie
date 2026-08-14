// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccessRequestAdapter extends TypeAdapter<AccessRequest> {
  @override
  final int typeId = 4;

  @override
  AccessRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccessRequest(
      id: fields[0] as String,
      userId: fields[1] as String,
      professionalId: fields[2] as String,
      status: fields[3] as AccessRequestStatus,
      createdAt: fields[4] as DateTime,
      message: fields[5] as String?,
      updatedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AccessRequest obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.professionalId)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.message)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccessRequestStatusAdapter extends TypeAdapter<AccessRequestStatus> {
  @override
  final int typeId = 3;

  @override
  AccessRequestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AccessRequestStatus.pending;
      case 1:
        return AccessRequestStatus.accepted;
      case 2:
        return AccessRequestStatus.rejected;
      case 3:
        return AccessRequestStatus.revoked;
      default:
        return AccessRequestStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, AccessRequestStatus obj) {
    switch (obj) {
      case AccessRequestStatus.pending:
        writer.writeByte(0);
        break;
      case AccessRequestStatus.accepted:
        writer.writeByte(1);
        break;
      case AccessRequestStatus.rejected:
        writer.writeByte(2);
        break;
      case AccessRequestStatus.revoked:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccessRequestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
