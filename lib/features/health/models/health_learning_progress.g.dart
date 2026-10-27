// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_learning_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthLearningProgressAdapter
    extends TypeAdapter<HealthLearningProgress> {
  @override
  final int typeId = 24;

  @override
  HealthLearningProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthLearningProgress(
      userId: fields[0] as String,
      completedLessons: (fields[1] as List).cast<String>(),
      completedQuizzes: (fields[2] as List).cast<String>(),
      favoriteItems: (fields[3] as List).cast<String>(),
      readingHistory: (fields[4] as List).cast<String>(),
      knowledgeScore: fields[5] as int,
      badges: (fields[6] as List).cast<String>(),
      currentLevel: fields[7] as LearningLevel,
    );
  }

  @override
  void write(BinaryWriter writer, HealthLearningProgress obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.completedLessons)
      ..writeByte(2)
      ..write(obj.completedQuizzes)
      ..writeByte(3)
      ..write(obj.favoriteItems)
      ..writeByte(4)
      ..write(obj.readingHistory)
      ..writeByte(5)
      ..write(obj.knowledgeScore)
      ..writeByte(6)
      ..write(obj.badges)
      ..writeByte(7)
      ..write(obj.currentLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthLearningProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LearningLevelAdapter extends TypeAdapter<LearningLevel> {
  @override
  final int typeId = 23;

  @override
  LearningLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LearningLevel.beginner;
      case 1:
        return LearningLevel.explorer;
      case 2:
        return LearningLevel.learner;
      case 3:
        return LearningLevel.connoisseur;
      default:
        return LearningLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, LearningLevel obj) {
    switch (obj) {
      case LearningLevel.beginner:
        writer.writeByte(0);
        break;
      case LearningLevel.explorer:
        writer.writeByte(1);
        break;
      case LearningLevel.learner:
        writer.writeByte(2);
        break;
      case LearningLevel.connoisseur:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
