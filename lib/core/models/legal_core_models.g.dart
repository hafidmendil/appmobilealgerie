// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_core_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LegalArticleAdapter extends TypeAdapter<LegalArticle> {
  @override
  final int typeId = 112;

  @override
  LegalArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LegalArticle(
      id: fields[0] as String,
      titleFr: fields[1] as String,
      titleAr: fields[2] as String,
      descriptionFr: fields[3] as String,
      descriptionAr: fields[4] as String,
      legalReference: fields[5] as String,
      articleReference: fields[6] as String,
      source: fields[7] as String,
      lastVerifiedAt: fields[8] as DateTime,
      status: fields[9] as LegalKnowledgeStatus,
      applicableViolenceTypes: (fields[10] as List).cast<ViolenceType>(),
      procedureId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LegalArticle obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleFr)
      ..writeByte(2)
      ..write(obj.titleAr)
      ..writeByte(3)
      ..write(obj.descriptionFr)
      ..writeByte(4)
      ..write(obj.descriptionAr)
      ..writeByte(5)
      ..write(obj.legalReference)
      ..writeByte(6)
      ..write(obj.articleReference)
      ..writeByte(7)
      ..write(obj.source)
      ..writeByte(8)
      ..write(obj.lastVerifiedAt)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.applicableViolenceTypes)
      ..writeByte(11)
      ..write(obj.procedureId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LegalArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LegalProcedureAdapter extends TypeAdapter<LegalProcedure> {
  @override
  final int typeId = 113;

  @override
  LegalProcedure read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LegalProcedure(
      id: fields[0] as String,
      titleFr: fields[1] as String,
      titleAr: fields[2] as String,
      stepsFr: fields[3] as String,
      stepsAr: fields[4] as String,
      competentAuthority: fields[5] as InstitutionType,
      lastVerifiedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LegalProcedure obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.titleFr)
      ..writeByte(2)
      ..write(obj.titleAr)
      ..writeByte(3)
      ..write(obj.stepsFr)
      ..writeByte(4)
      ..write(obj.stepsAr)
      ..writeByte(5)
      ..write(obj.competentAuthority)
      ..writeByte(6)
      ..write(obj.lastVerifiedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LegalProcedureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LegalGuidanceAdapter extends TypeAdapter<LegalGuidance> {
  @override
  final int typeId = 114;

  @override
  LegalGuidance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LegalGuidance(
      id: fields[0] as String,
      assessmentId: fields[1] as String,
      potentialLegalClassifications: (fields[2] as List).cast<String>(),
      relevantLegalArticleIds: (fields[3] as List).cast<String>(),
      possibleProcedureIds: (fields[4] as List).cast<String>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LegalGuidance obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.assessmentId)
      ..writeByte(2)
      ..write(obj.potentialLegalClassifications)
      ..writeByte(3)
      ..write(obj.relevantLegalArticleIds)
      ..writeByte(4)
      ..write(obj.possibleProcedureIds)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LegalGuidanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
