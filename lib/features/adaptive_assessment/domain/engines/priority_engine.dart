import '../models/assessment_axis.dart';
import '../models/domain_state.dart';

class PriorityEngine {
  Map<AssessmentAxis, DomainState> adjustPriorities(
    Map<AssessmentAxis, DomainState> currentStates,
    Map<AssessmentAxis, double> needs,
  ) {
    final updatedStates = <AssessmentAxis, DomainState>{};

    currentStates.forEach((axis, state) {
      int newPriority = state.priority;

      // 1. Boost based on detected needs
      final need = needs[axis] ?? 0.0;
      if (need > 0.6) {
        newPriority += 150;
      } else if (need > 0.3) {
        newPriority += 75;
      }

      // 2. Adjust based on exploration status
      switch (state.status) {
        case ExplorationStatus.opened:
          newPriority += 50;
          break;
        case ExplorationStatus.exploring:
          newPriority += 100;
          break;
        case ExplorationStatus.closed:
          newPriority = 0; // Don't ask unless reopened
          break;
        case ExplorationStatus.held:
          newPriority -= 50;
          break;
        default:
          break;
      }

      // 3. Prevent priority from going negative
      if (newPriority < 0) newPriority = 0;

      updatedStates[axis] = state.copyWith(priority: newPriority);
    });

    return updatedStates;
  }
}
