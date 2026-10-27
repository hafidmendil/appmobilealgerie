import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'assessment_core_models.g.dart';

@HiveType(typeId: 101)
class Assessment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? userId; // Null if anonymous

  @HiveField(2)
  final String? anonymousSessionId;

  @HiveField(3)
  final AssessmentType type;

  @HiveField(4)
  final DateTime startedAt;

  @HiveField(5)
  final DateTime? completedAt;

  @HiveField(6)
  final String status; // 'in_progress', 'completed', 'abandoned'

  @HiveField(7)
  final List<AssessmentAnswer> answers;

  @HiveField(8)
  final AssessmentResult? result;

  Assessment({
    required this.id,
    this.userId,
    this.anonymousSessionId,
    required this.type,
    required this.startedAt,
    this.completedAt,
    required this.status,
    this.answers = const [],
    this.result,
  });
}

@HiveType(typeId: 102)
class AssessmentQuestion extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String category;
  @HiveField(2)
  final String? subCategory;
  @HiveField(3)
  final String textFr;
  @HiveField(4)
  final String textAr;
  @HiveField(5)
  final String answerType; // 'single_choice', 'multiple_choice', 'scale', 'boolean'
  @HiveField(6)
  final List<String> optionsFr;
  @HiveField(7)
  final List<String> optionsAr;
  @HiveField(8)
  final int priority;
  @HiveField(9)
  final double weight;

  AssessmentQuestion({
    required this.id,
    required this.category,
    this.subCategory,
    required this.textFr,
    required this.textAr,
    required this.answerType,
    this.optionsFr = const [],
    this.optionsAr = const [],
    this.priority = 1,
    this.weight = 1.0,
  });
}

@HiveType(typeId: 103)
class AssessmentAnswer extends HiveObject {
  @HiveField(0)
  final String questionId;
  @HiveField(1)
  final String value;
  @HiveField(2)
  final DateTime answeredAt;

  AssessmentAnswer({
    required this.questionId,
    required this.value,
    required this.answeredAt,
  });
}

@HiveType(typeId: 104)
class AssessmentResult extends HiveObject {
  @HiveField(0)
  final String assessmentId;
  @HiveField(1)
  final RiskLevel riskLevel;
  @HiveField(2)
  final String primaryPath;
  @HiveField(3)
  final List<String> recommendedActions;
  @HiveField(4)
  final List<String> recommendedResources;
  @HiveField(5)
  final bool referralNeeded;
  @HiveField(6)
  final bool legalGuidanceAvailable;
  @HiveField(7)
  final bool urgentOrientation;
  @HiveField(8)
  final RiskAssessment riskAssessment;
  @HiveField(9)
  final EngineTrace? engineTrace;

  AssessmentResult({
    required this.assessmentId,
    required this.riskLevel,
    required this.primaryPath,
    this.recommendedActions = const [],
    this.recommendedResources = const [],
    this.referralNeeded = false,
    this.legalGuidanceAvailable = false,
    this.urgentOrientation = false,
    required this.riskAssessment,
    this.engineTrace,
  });
}

@HiveType(typeId: 105)
class RiskAssessment extends HiveObject {
  @HiveField(0)
  final double psychologicalScore;
  @HiveField(1)
  final double violenceExposureScore;
  @HiveField(2)
  final double socialVulnerabilityScore;
  @HiveField(3)
  final double safetyScore;
  @HiveField(4)
  final double supportScore;
  @HiveField(5)
  final double urgencyScore;

  RiskAssessment({
    required this.psychologicalScore,
    required this.violenceExposureScore,
    required this.socialVulnerabilityScore,
    required this.safetyScore,
    required this.supportScore,
    required this.urgencyScore,
  });
}

@HiveType(typeId: 106)
class EngineTrace extends HiveObject {
  @HiveField(0)
  final List<String> triggeredRules;
  @HiveField(1)
  final List<String> riskFactors;
  @HiveField(2)
  final String rawDecisionExplanation;

  EngineTrace({
    this.triggeredRules = const [],
    this.riskFactors = const [],
    required this.rawDecisionExplanation,
  });
}
