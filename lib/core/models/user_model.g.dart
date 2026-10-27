// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      email: fields[1] as String,
      role: fields[2] as UserRole,
      status: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      wilayaId: fields[6] as String?,
      prefSpiritual: fields[7] as bool,
      hasCompletedInitialAssessment: fields[8] as bool,
      name: fields[9] as String?,
      mfaRequired: fields[10] as bool? ?? false,
      mustChangePassword: fields[11] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.wilayaId)
      ..writeByte(7)
      ..write(obj.prefSpiritual)
      ..writeByte(8)
      ..write(obj.hasCompletedInitialAssessment)
      ..writeByte(9)
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.mfaRequired)
      ..writeByte(11)
      ..write(obj.mustChangePassword);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
