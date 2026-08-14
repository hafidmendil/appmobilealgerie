import 'assessment_axis.dart';

enum AnswerType {
  frequency,  // Jamais, Rarement, Parfois, Souvent, Toujours
  boolean,    // Oui, Non
  scale       // 1..10
}

enum SafetyLevel {
  none,
  low,
  medium,
  high,
  urgent
}

class AssessmentOption {
  final String textFr;
  final String textAr;
  final String? textDarja;
  final int? value; // null for "I prefer not to answer"
  final bool isSafetyTrigger;

  const AssessmentOption({
    required this.textFr,
    required this.textAr,
    this.textDarja,
    this.value,
    this.isSafetyTrigger = false,
  });
}

class NextQuestionRule {
  final List<int?> triggerValues;
  final String targetQuestionId;
  final int priorityBoost;

  const NextQuestionRule({
    required this.triggerValues,
    required this.targetQuestionId,
    this.priorityBoost = 0,
  });
}

class AssessmentQuestion {
  final String id;
  final String textFr;
  final String textAr;
  final String? textDarja;
  final AssessmentAxis axis;
  final String subTheme;
  final AnswerType answerType;
  final List<AssessmentOption> options;
  final Map<AssessmentAxis, double> weights;
  final List<String> tags;
  final List<NextQuestionRule> nextRules;
  final SafetyLevel safetyLevel;
  final int basePriority;
  final String? recommendationId;

  const AssessmentQuestion({
    required this.id,
    required this.textFr,
    required this.textAr,
    this.textDarja,
    required this.axis,
    required this.subTheme,
    required this.answerType,
    required this.options,
    this.weights = const {},
    this.tags = const [],
    this.nextRules = const [],
    this.safetyLevel = SafetyLevel.none,
    this.basePriority = 0,
    this.recommendationId,
  });
}
