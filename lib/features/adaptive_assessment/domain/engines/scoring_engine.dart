import '../models/assessment_axis.dart';
import '../models/assessment_question.dart';
import '../models/domain_state.dart';
import '../../data/question_bank.dart';

class ScoringEngine {
  Map<AssessmentAxis, double> calculateAxisNeeds(Map<String, int?> answers) {
    final Map<AssessmentAxis, double> totalScores = {};
    final Map<AssessmentAxis, double> maxPossibleScores = {};

    for (var axis in AssessmentAxis.values) {
      totalScores[axis] = 0.0;
      maxPossibleScores[axis] = 0.0;
    }

    for (var entry in answers.entries) {
      final questionId = entry.key;
      final answerValue = entry.value;

      if (answerValue == null) continue;

      final question = QuestionBank.questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => throw Exception('Question $questionId not found in bank'),
      );

      if (question.scoreDirection == ScoreDirection.nonScored) continue;

      final values = question.options
          .map((option) => option.value)
          .whereType<int>();
      if (values.isEmpty) continue;
      final maxValue = values.reduce((a, b) => a > b ? a : b);
      if (maxValue <= 0) continue;

      final orientedValue =
          question.scoreDirection == ScoreDirection.higherMeansLowerNeed
          ? maxValue - answerValue
          : answerValue;

      totalScores[question.axis] =
          (totalScores[question.axis] ?? 0) + (orientedValue * question.weight);
      maxPossibleScores[question.axis] =
          (maxPossibleScores[question.axis] ?? 0) +
          (maxValue * question.weight);

      question.weights.forEach((axis, weight) {
        totalScores[axis] = (totalScores[axis] ?? 0) + (orientedValue * weight);
        maxPossibleScores[axis] =
            (maxPossibleScores[axis] ?? 0) + (maxValue * weight);
      });
    }

    final Map<AssessmentAxis, double> normalizedNeeds = {};
    for (var axis in AssessmentAxis.values) {
      final total = totalScores[axis] ?? 0.0;
      final max = maxPossibleScores[axis] ?? 0.0;
      normalizedNeeds[axis] = max > 0 ? total / max : 0.0;
    }

    return normalizedNeeds;
  }

  Map<AssessmentAxis, DomainState> updateDomainStates(
    Map<AssessmentAxis, DomainState> currentStates,
    Map<String, int?> answers,
    Map<AssessmentAxis, double> needs,
  ) {
    final updatedStates = <AssessmentAxis, DomainState>{};

    for (var axis in AssessmentAxis.values) {
      final currentState = currentStates[axis] ?? DomainState(axis: axis);

      // Calculate how many questions were asked for this axis
      int askedCount = 0;
      for (var questionId in answers.keys) {
        final q = QuestionBank.questions.firstWhere((q) => q.id == questionId);
        if (q.axis == axis) askedCount++;
      }

      updatedStates[axis] = currentState.copyWith(
        score: needs[axis] ?? 0.0,
        questionsAsked: askedCount,
      );
    }

    return updatedStates;
  }
}
