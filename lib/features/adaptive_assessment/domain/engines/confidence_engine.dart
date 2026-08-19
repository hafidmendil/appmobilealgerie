import '../models/assessment_axis.dart';
import '../models/domain_state.dart';

class ConfidenceEngine {
  Map<AssessmentAxis, DomainState> calculateConfidence(
    Map<AssessmentAxis, DomainState> currentStates,
    int totalQuestionsAsked,
  ) {
    final updatedStates = <AssessmentAxis, DomainState>{};

    currentStates.forEach((axis, state) {
      // Confidence calculation logic:
      // More questions asked in a domain increases confidence.
      // Maximum confidence reached around 4-5 questions per domain.
      double confidence = state.questionsAsked * 0.25;
      if (confidence > 1.0) confidence = 1.0;

      updatedStates[axis] = state.copyWith(confidence: confidence);
    });

    return updatedStates;
  }
}
