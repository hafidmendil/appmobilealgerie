// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_core_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartnerSpecialityAdapter extends TypeAdapter<PartnerSpeciality> {
  @override
  final int typeId = 109;

  @override
  PartnerSpeciality read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartnerSpeciality(
      id: fields[0] as String,
      nameFr: fields[1] as String,
      nameAr: fields[2] as String,
      type: fields[3] as PartnerType,
    );
  }

  @override
  void write(BinaryWriter writer, PartnerSpeciality obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameFr)
      ..writeByte(2)
      ..write(obj.nameAr)
      ..writeByte(3)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerSpecialityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PartnerAdapter extends TypeAdapter<Partner> {
  @override
  final int typeId = 110;

  @override
  Partner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Partner(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as PartnerType,
      specialityId: fields[3] as String,
      wilayaId: fields[4] as String,
      communeId: fields[5] as String,
      location: fields[6] as String,
      phone: fields[7] as String,
      languages: (fields[8] as List).cast<String>(),
      availability: fields[9] as bool,
      status: fields[10] as PartnerStatus,
      active: fields[11] as bool,
      acceptedCaseTypes: (fields[12] as List).cast<UserSituation>(),
      supportedRiskLevels: (fields[13] as List).cast<RiskLevel>(),
    );
  }

  @override
  void write(BinaryWriter writer, Partner obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.specialityId)
      ..writeByte(4)
      ..write(obj.wilayaId)
      ..writeByte(5)
      ..write(obj.communeId)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.languages)
      ..writeByte(9)
      ..write(obj.availability)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.active)
      ..writeByte(12)
      ..write(obj.acceptedCaseTypes)
      ..writeByte(13)
      ..write(obj.supportedRiskLevels);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartnerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstitutionAdapter extends TypeAdapter<Institution> {
  @override
  final int typeId = 111;

  @override
  Institution read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Institution(
      id: fields[0] as String,
      nameFr: fields[1] as String,
      nameAr: fields[2] as String,
      type: fields[3] as InstitutionType,
      wilayaId: fields[4] as String,
      communeId: fields[5] as String,
      phone: fields[6] as String,
      location: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Institution obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameFr)
      ..writeByte(2)
      ..write(obj.nameAr)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.wilayaId)
      ..writeByte(5)
      ..write(obj.communeId)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstitutionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
