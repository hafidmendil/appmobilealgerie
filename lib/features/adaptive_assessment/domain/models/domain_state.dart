import 'assessment_axis.dart';

enum ExplorationStatus { unexplored, opened, exploring, held, closed, reopened }

class DomainState {
  final AssessmentAxis axis;
  final double score; // Normalized 0.0 to 1.0
  final double confidence; // Normalized 0.0 to 1.0
  final int priority; // Dynamic priority value
  final ExplorationStatus status;
  final int questionsAsked;

  const DomainState({
    required this.axis,
    this.score = 0.0,
    this.confidence = 0.0,
    this.priority = 100,
    this.status = ExplorationStatus.unexplored,
    this.questionsAsked = 0,
  });

  DomainState copyWith({
    double? score,
    double? confidence,
    int? priority,
    ExplorationStatus? status,
    int? questionsAsked,
  }) {
    return DomainState(
      axis: axis,
      score: score ?? this.score,
      confidence: confidence ?? this.confidence,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      questionsAsked: questionsAsked ?? this.questionsAsked,
    );
  }
}

enum DeclaredState {
  overload,
  lackOfMotivation,
  stress,
  academicDifficulty,
  relationalConflict,
  relationalProblem,
  familyConflict,
  isolation,
  sad,
  seekingMeaning,
  professionalDifficulty,
  medicalCondition,
}
