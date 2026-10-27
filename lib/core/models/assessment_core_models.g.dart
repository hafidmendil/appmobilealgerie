// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_core_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssessmentAdapter extends TypeAdapter<Assessment> {
  @override
  final int typeId = 101;

  @override
  Assessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Assessment(
      id: fields[0] as String,
      userId: fields[1] as String?,
      anonymousSessionId: fields[2] as String?,
      type: fields[3] as AssessmentType,
      startedAt: fields[4] as DateTime,
      completedAt: fields[5] as DateTime?,
      status: fields[6] as String,
      answers: (fields[7] as List).cast<AssessmentAnswer>(),
      result: fields[8] as AssessmentResult?,
    );
  }

  @override
  void write(BinaryWriter writer, Assessment obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.anonymousSessionId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.startedAt)
      ..writeByte(5)
      ..write(obj.completedAt)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.answers)
      ..writeByte(8)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssessmentQuestionAdapter extends TypeAdapter<AssessmentQuestion> {
  @override
  final int typeId = 102;

  @override
  AssessmentQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssessmentQuestion(
      id: fields[0] as String,
      category: fields[1] as String,
      subCategory: fields[2] as String?,
      textFr: fields[3] as String,
      textAr: fields[4] as String,
      answerType: fields[5] as String,
      optionsFr: (fields[6] as List).cast<String>(),
      optionsAr: (fields[7] as List).cast<String>(),
      priority: fields[8] as int,
      weight: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentQuestion obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.subCategory)
      ..writeByte(3)
      ..write(obj.textFr)
      ..writeByte(4)
      ..write(obj.textAr)
      ..writeByte(5)
      ..write(obj.answerType)
      ..writeByte(6)
      ..write(obj.optionsFr)
      ..writeByte(7)
      ..write(obj.optionsAr)
      ..writeByte(8)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssessmentAnswerAdapter extends TypeAdapter<AssessmentAnswer> {
  @override
  final int typeId = 103;

  @override
  AssessmentAnswer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssessmentAnswer(
      questionId: fields[0] as String,
      value: fields[1] as String,
      answeredAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentAnswer obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.answeredAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentAnswerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AssessmentResultAdapter extends TypeAdapter<AssessmentResult> {
  @override
  final int typeId = 104;

  @override
  AssessmentResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssessmentResult(
      assessmentId: fields[0] as String,
      riskLevel: fields[1] as RiskLevel,
      primaryPath: fields[2] as String,
      recommendedActions: (fields[3] as List).cast<String>(),
      recommendedResources: (fields[4] as List).cast<String>(),
      referralNeeded: fields[5] as bool,
      legalGuidanceAvailable: fields[6] as bool,
      urgentOrientation: fields[7] as bool,
      riskAssessment: fields[8] as RiskAssessment,
      engineTrace: fields[9] as EngineTrace?,
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentResult obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.assessmentId)
      ..writeByte(1)
      ..write(obj.riskLevel)
      ..writeByte(2)
      ..write(obj.primaryPath)
      ..writeByte(3)
      ..write(obj.recommendedActions)
      ..writeByte(4)
      ..write(obj.recommendedResources)
      ..writeByte(5)
      ..write(obj.referralNeeded)
      ..writeByte(6)
      ..write(obj.legalGuidanceAvailable)
      ..writeByte(7)
      ..write(obj.urgentOrientation)
      ..writeByte(8)
      ..write(obj.riskAssessment)
      ..writeByte(9)
      ..write(obj.engineTrace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RiskAssessmentAdapter extends TypeAdapter<RiskAssessment> {
  @override
  final int typeId = 105;

  @override
  RiskAssessment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RiskAssessment(
      psychologicalScore: fields[0] as double,
      violenceExposureScore: fields[1] as double,
      socialVulnerabilityScore: fields[2] as double,
      safetyScore: fields[3] as double,
      supportScore: fields[4] as double,
      urgencyScore: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RiskAssessment obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.psychologicalScore)
      ..writeByte(1)
      ..write(obj.violenceExposureScore)
      ..writeByte(2)
      ..write(obj.socialVulnerabilityScore)
      ..writeByte(3)
      ..write(obj.safetyScore)
      ..writeByte(4)
      ..write(obj.supportScore)
      ..writeByte(5)
      ..write(obj.urgencyScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RiskAssessmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EngineTraceAdapter extends TypeAdapter<EngineTrace> {
  @override
  final int typeId = 106;

  @override
  EngineTrace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EngineTrace(
      triggeredRules: (fields[0] as List).cast<String>(),
      riskFactors: (fields[1] as List).cast<String>(),
      rawDecisionExplanation: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EngineTrace obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.triggeredRules)
      ..writeByte(1)
      ..write(obj.riskFactors)
      ..writeByte(2)
      ..write(obj.rawDecisionExplanation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EngineTraceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
