import '../models/assessment_axis.dart';
import '../models/domain_state.dart';

class RuleEngine {
  Map<AssessmentAxis, DomainState> evaluateRules(
    Map<AssessmentAxis, DomainState> currentStates,
    Map<AssessmentAxis, double> needs,
  ) {
    final updatedStates = <AssessmentAxis, DomainState>{};

    currentStates.forEach((axis, state) {
      ExplorationStatus newStatus = state.status;
      final need = needs[axis] ?? 0.0;

      if (state.status == ExplorationStatus.unexplored && need > 0.1) {
        newStatus = ExplorationStatus.opened;
      } else if (state.status == ExplorationStatus.opened && need > 0.4) {
        newStatus = ExplorationStatus.exploring;
      } else if (state.status == ExplorationStatus.exploring && state.confidence >= 0.8) {
        newStatus = ExplorationStatus.closed;
      } else if (state.status == ExplorationStatus.unexplored && state.questionsAsked > 2 && need < 0.1) {
          newStatus = ExplorationStatus.closed;
      }

      updatedStates[axis] = state.copyWith(status: newStatus);
    });

    return updatedStates;
  }
}
