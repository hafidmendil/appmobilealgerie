import 'assessment_axis.dart';

enum AnswerType {
  frequency, // Jamais, Rarement, Parfois, Souvent, Toujours
  boolean, // Oui, Non
  scale, // 1..10
  choice, // Single choice from custom options
  text, // Free text response
}

enum SafetyLevel { none, low, medium, high, urgent }

/// Defines how a numeric answer contributes to a need score. This prevents a
/// protective answer (for example, strong social support) from being mistaken
/// for a symptom of greater difficulty.
enum ScoreDirection {
  higherMeansGreaterNeed,
  higherMeansLowerNeed,
  nonScored,
}

class QuestionCondition {
  final String field;
  final List<int?> acceptedValues;
  final bool requireAll;

  const QuestionCondition({
    required this.field,
    this.acceptedValues = const [],
    this.requireAll = true,
  });
}

class QuestionRule {
  final String field;
  final List<int?> triggerValues;
  final String targetQuestionId;
  final double priorityBoost;

  const QuestionRule({
    required this.field,
    required this.triggerValues,
    required this.targetQuestionId,
    this.priorityBoost = 0,
  });
}

class AssessmentOption {
  final String textFr;
  final String textAr;
  final int? value; // null for "I prefer not to answer"
  final bool isSafetyTrigger;

  const AssessmentOption({
    required this.textFr,
    required this.textAr,
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
  final String category;
  final String subcategory;
  final String textFr;
  final String textAr;
  final AssessmentAxis axis;
  final String subTheme;
  final AnswerType answerType;
  final List<AssessmentOption> options;
  final double weight;
  final int priority;
  final Map<String, dynamic> conditions;
  final List<QuestionRule> rules;
  final Map<AssessmentAxis, double> weights;
  final List<String> tags;
  final List<NextQuestionRule> nextRules;
  final SafetyLevel safetyLevel;
  final int basePriority;
  final int depth; // Depth in the assessment tree
  final List<String> indicators; // Clinical indicators targeted
  final List<String> linkedQuestions;
  final String? source;
  final String validationStatus; // e.g., "validated", "draft"
  final String version;
  final String? recommendationId;
  final ScoreDirection scoreDirection;

  const AssessmentQuestion({
    required this.id,
    this.category = 'general',
    this.subcategory = 'general',
    required this.textFr,
    required this.textAr,
    required this.axis,
    required this.subTheme,
    required this.answerType,
    required this.options,
    this.weight = 1.0,
    this.priority = 0,
    this.conditions = const {},
    this.rules = const [],
    this.weights = const {},
    this.tags = const [],
    this.nextRules = const [],
    this.safetyLevel = SafetyLevel.none,
    this.basePriority = 0,
    this.depth = 0,
    this.indicators = const [],
    this.linkedQuestions = const [],
    this.source,
    this.validationStatus = 'validated',
    this.version = '1.0',
    this.recommendationId,
    this.scoreDirection = ScoreDirection.higherMeansGreaterNeed,
  });

  bool get isSafetySensitive => safetyLevel != SafetyLevel.none;
}
