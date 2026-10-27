import '../models/assessment_axis.dart';
import '../models/domain_state.dart';

class CompletionEngine {
  bool shouldStopAssessment(
    Map<AssessmentAxis, DomainState> states,
    int totalQuestionsAsked, {
    int maxQuestions = 25,
    int minQuestions = 8,
  }) {
    if (totalQuestionsAsked >= maxQuestions) return true;
    if (totalQuestionsAsked < minQuestions) return false;

    // Check if high priority domains have sufficient confidence
    final highPriorityDomains = states.values
        .where((s) => s.priority > 200)
        .toList();

    if (highPriorityDomains.isEmpty) {
      // If no high priority domains are left to explore, we can stop
      return true;
    }

    final allHighConfidence = highPriorityDomains.every(
      (s) => s.confidence >= 0.75,
    );

    return allHighConfidence;
  }
}
