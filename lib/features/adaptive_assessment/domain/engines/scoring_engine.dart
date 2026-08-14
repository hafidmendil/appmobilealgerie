import '../models/assessment_axis.dart';
import '../models/assessment_question.dart';
import '../../data/question_bank.dart';

class ScoringEngine {
  /// Calculates need scores for each axis based on provided answers.
  /// Scores are normalized between 0.0 and 1.0.
  Map<AssessmentAxis, double> calculateAxisNeeds(Map<String, int?> answers) {
    final Map<AssessmentAxis, double> totalScores = {};
    final Map<AssessmentAxis, double> maxPossibleScores = {};

    // Initialize maps for all axes
    for (var axis in AssessmentAxis.values) {
      totalScores[axis] = 0.0;
      maxPossibleScores[axis] = 0.0;
    }

    for (var entry in answers.entries) {
      final questionId = entry.key;
      final answerValue = entry.value;

      // Skip if user preferred not to answer
      if (answerValue == null) continue;

      final question = QuestionBank.questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => throw Exception('Question $questionId not found in bank'),
      );

      // Add to primary axis
      totalScores[question.axis] = (totalScores[question.axis] ?? 0) + answerValue;
      maxPossibleScores[question.axis] = (maxPossibleScores[question.axis] ?? 0) + 4; // Max value is 4

      // Add to other axes based on weights
      question.weights.forEach((axis, weight) {
        totalScores[axis] = (totalScores[axis] ?? 0) + (answerValue * weight);
        maxPossibleScores[axis] = (maxPossibleScores[axis] ?? 0) + (4 * weight);
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
}
