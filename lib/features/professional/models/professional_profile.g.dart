// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfessionalProfileAdapter extends TypeAdapter<ProfessionalProfile> {
  @override
  final int typeId = 7;

  @override
  ProfessionalProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfessionalProfile(
      id: fields[0] as String,
      userId: fields[1] as String,
      fullName: fields[2] as String,
      specialty: fields[3] as ProfessionalSpecialty,
      description: fields[4] as String,
      location: fields[5] as String,
      languages: (fields[6] as List).cast<String>(),
      createdAt: fields[8] as DateTime,
      isApproved: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfessionalProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.specialty)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.languages)
      ..writeByte(7)
      ..write(obj.isApproved)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionalProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProfessionalSpecialtyAdapter extends TypeAdapter<ProfessionalSpecialty> {
  @override
  final int typeId = 5;

  @override
  ProfessionalSpecialty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProfessionalSpecialty.psychologist;
      case 1:
        return ProfessionalSpecialty.doctor;
      case 2:
        return ProfessionalSpecialty.neurologist;
      case 3:
        return ProfessionalSpecialty.socialWorker;
      case 4:
        return ProfessionalSpecialty.educator;
      case 5:
        return ProfessionalSpecialty.counselor;
      default:
        return ProfessionalSpecialty.psychologist;
    }
  }

  @override
  void write(BinaryWriter writer, ProfessionalSpecialty obj) {
    switch (obj) {
      case ProfessionalSpecialty.psychologist:
        writer.writeByte(0);
        break;
      case ProfessionalSpecialty.doctor:
        writer.writeByte(1);
        break;
      case ProfessionalSpecialty.neurologist:
        writer.writeByte(2);
        break;
      case ProfessionalSpecialty.socialWorker:
        writer.writeByte(3);
        break;
      case ProfessionalSpecialty.educator:
        writer.writeByte(4);
        break;
      case ProfessionalSpecialty.counselor:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfessionalSpecialtyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
