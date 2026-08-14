import 'dart:math';
import '../models/assessment_axis.dart';
import '../models/assessment_question.dart';
import '../../data/question_bank.dart';
import 'scoring_engine.dart';

class AdaptiveQuestionEngine {
  final ScoringEngine _scoringEngine = ScoringEngine();

  /// Selects the best next question based on current session state.
  AssessmentQuestion? getNextQuestion({
    required List<String> askedQuestionIds,
    required Map<String, int?> answers,
    int maxQuestions = 15,
  }) {
    if (askedQuestionIds.length >= maxQuestions) return null;

    final candidateQuestions = QuestionBank.questions.where(
      (q) => !askedQuestionIds.contains(q.id)
    ).toList();

    if (candidateQuestions.isEmpty) return null;

    final currentNeeds = _scoringEngine.calculateAxisNeeds(answers);
    final axisDistribution = _calculateAxisDistribution(askedQuestionIds);

    final scores = <String, double>{};

    for (var q in candidateQuestions) {
      double score = q.basePriority.toDouble();

      // 1. Boost based on axis needs
      final needScore = currentNeeds[q.axis] ?? 0.0;
      score += needScore * 150; // Significant boost for relevant axes

      // 2. Boost based on nextRules from previous answers
      score += _calculateRuleBoost(q.id, answers);

      // 3. Safety boost
      if (q.safetyLevel != SafetyLevel.none) {
        score += (q.safetyLevel.index * 20);
      }

      // 4. Exploration bonus for unexplored areas
      if (axisDistribution[q.axis] == 0) {
        score += 40; // Increased exploration bonus
      }

      // 5. Penalty for over-represented axes to maintain variety
      final count = axisDistribution[q.axis] ?? 0;
      score -= count * 35; // Increased penalty for repetition

      // 6. Avoid asking too many questions from the same subtheme consecutively
      if (askedQuestionIds.isNotEmpty) {
        final lastId = askedQuestionIds.last;
        final lastQ = QuestionBank.questions.firstWhere((q) => q.id == lastId);
        if (lastQ.subTheme == q.subTheme) {
          score -= 50; // Heavy penalty for same subtheme
        }
      }

      scores[q.id] = score;
    }

    // Sort by score descending
    candidateQuestions.sort((a, b) {
      final scoreA = scores[a.id] ?? 0.0;
      final scoreB = scores[b.id] ?? 0.0;
      return scoreB.compareTo(scoreA);
    });

    return candidateQuestions.first;
  }

  Map<AssessmentAxis, int> _calculateAxisDistribution(List<String> askedIds) {
    final dist = <AssessmentAxis, int>{};
    for (var axis in AssessmentAxis.values) dist[axis] = 0;

    for (var id in askedIds) {
      final q = QuestionBank.questions.firstWhere((q) => q.id == id);
      dist[q.axis] = (dist[q.axis] ?? 0) + 1;
    }
    return dist;
  }

  double _calculateRuleBoost(String targetId, Map<String, int?> answers) {
    double boost = 0;
    for (var entry in answers.entries) {
      final q = QuestionBank.questions.firstWhere((q) => q.id == entry.key);
      for (var rule in q.nextRules) {
        if (rule.targetQuestionId == targetId && rule.triggerValues.contains(entry.value)) {
          boost += rule.priorityBoost;
        }
      }
    }
    return boost;
  }
}
