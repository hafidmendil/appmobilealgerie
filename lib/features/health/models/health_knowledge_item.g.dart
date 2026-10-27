// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_knowledge_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthKnowledgeItemAdapter extends TypeAdapter<HealthKnowledgeItem> {
  @override
  final int typeId = 22;

  @override
  HealthKnowledgeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthKnowledgeItem(
      id: fields[0] as String,
      title: fields[1] as String,
      arabicTitle: fields[2] as String,
      description: fields[3] as String,
      category: fields[4] as HealthCategory,
      author: fields[5] as String?,
      source: fields[6] as String?,
      publicationYear: fields[7] as int?,
      sourceUrl: fields[8] as String?,
      evidenceLevel: fields[9] as EvidenceLevel,
      scientificSummary: fields[10] as String?,
      traditionalContext: fields[11] as String?,
      benefits: (fields[12] as List).cast<String>(),
      limitations: (fields[13] as List).cast<String>(),
      warnings: (fields[14] as List).cast<String>(),
      references: (fields[15] as List).cast<String>(),
      language: fields[16] as String,
      createdAt: fields[17] as DateTime,
      updatedAt: fields[18] as DateTime,
      sourceStatus: fields[19] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthKnowledgeItem obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.arabicTitle)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.author)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.publicationYear)
      ..writeByte(8)
      ..write(obj.sourceUrl)
      ..writeByte(9)
      ..write(obj.evidenceLevel)
      ..writeByte(10)
      ..write(obj.scientificSummary)
      ..writeByte(11)
      ..write(obj.traditionalContext)
      ..writeByte(12)
      ..write(obj.benefits)
      ..writeByte(13)
      ..write(obj.limitations)
      ..writeByte(14)
      ..write(obj.warnings)
      ..writeByte(15)
      ..write(obj.references)
      ..writeByte(16)
      ..write(obj.language)
      ..writeByte(17)
      ..write(obj.createdAt)
      ..writeByte(18)
      ..write(obj.updatedAt)
      ..writeByte(19)
      ..write(obj.sourceStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthKnowledgeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EvidenceLevelAdapter extends TypeAdapter<EvidenceLevel> {
  @override
  final int typeId = 20;

  @override
  EvidenceLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EvidenceLevel.traditionalSource;
      case 1:
        return EvidenceLevel.religiousSource;
      case 2:
        return EvidenceLevel.academicResearch;
      case 3:
        return EvidenceLevel.clinicalEvidence;
      case 4:
        return EvidenceLevel.review;
      case 5:
        return EvidenceLevel.uncertain;
      default:
        return EvidenceLevel.traditionalSource;
    }
  }

  @override
  void write(BinaryWriter writer, EvidenceLevel obj) {
    switch (obj) {
      case EvidenceLevel.traditionalSource:
        writer.writeByte(0);
        break;
      case EvidenceLevel.religiousSource:
        writer.writeByte(1);
        break;
      case EvidenceLevel.academicResearch:
        writer.writeByte(2);
        break;
      case EvidenceLevel.clinicalEvidence:
        writer.writeByte(3);
        break;
      case EvidenceLevel.review:
        writer.writeByte(4);
        break;
      case EvidenceLevel.uncertain:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvidenceLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthCategoryAdapter extends TypeAdapter<HealthCategory> {
  @override
  final int typeId = 21;

  @override
  HealthCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HealthCategory.nutrition;
      case 1:
        return HealthCategory.lifestyle;
      case 2:
        return HealthCategory.islamicNutrition;
      case 3:
        return HealthCategory.propheticMedicine;
      case 4:
        return HealthCategory.traditionalPlants;
      case 5:
        return HealthCategory.physicalWellbeing;
      case 6:
        return HealthCategory.psychologicalWellbeing;
      case 7:
        return HealthCategory.sleepHabits;
      case 8:
        return HealthCategory.prevention;
      case 9:
        return HealthCategory.scientificResearch;
      case 10:
        return HealthCategory.sources;
      default:
        return HealthCategory.nutrition;
    }
  }

  @override
  void write(BinaryWriter writer, HealthCategory obj) {
    switch (obj) {
      case HealthCategory.nutrition:
        writer.writeByte(0);
        break;
      case HealthCategory.lifestyle:
        writer.writeByte(1);
        break;
      case HealthCategory.islamicNutrition:
        writer.writeByte(2);
        break;
      case HealthCategory.propheticMedicine:
        writer.writeByte(3);
        break;
      case HealthCategory.traditionalPlants:
        writer.writeByte(4);
        break;
      case HealthCategory.physicalWellbeing:
        writer.writeByte(5);
        break;
      case HealthCategory.psychologicalWellbeing:
        writer.writeByte(6);
        break;
      case HealthCategory.sleepHabits:
        writer.writeByte(7);
        break;
      case HealthCategory.prevention:
        writer.writeByte(8);
        break;
      case HealthCategory.scientificResearch:
        writer.writeByte(9);
        break;
      case HealthCategory.sources:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
