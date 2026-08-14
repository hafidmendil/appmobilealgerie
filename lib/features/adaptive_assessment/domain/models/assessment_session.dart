import 'assessment_question.dart';

class AssessmentSession {
  final String id;
  final String userId;
  final List<String> questionIds;
  final Map<String, int?> answers; // questionId -> value (0-4 or null)
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isSafetyInterrupted;

  const AssessmentSession({
    required this.id,
    required this.userId,
    this.questionIds = const [],
    this.answers = const {},
    required this.startedAt,
    this.completedAt,
    this.isSafetyInterrupted = false,
  });

  AssessmentSession copyWith({
    List<String>? questionIds,
    Map<String, int?>? answers,
    DateTime? completedAt,
    bool? isSafetyInterrupted,
  }) {
    return AssessmentSession(
      id: id,
      userId: userId,
      questionIds: questionIds ?? this.questionIds,
      answers: answers ?? this.answers,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      isSafetyInterrupted: isSafetyInterrupted ?? this.isSafetyInterrupted,
    );
  }
}
