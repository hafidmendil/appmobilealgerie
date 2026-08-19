import 'assessment_axis.dart';
import 'domain_state.dart';

class EngineTrace {
  final String sessionId;
  final DateTime timestamp;
  final String? previousQuestionId;
  final int? lastAnswerValue;
  final Map<AssessmentAxis, DomainState> domainStatesSnapshot;
  final List<String> candidateQuestionIds;
  final List<String> rejectedQuestionIds;
  final String selectedQuestionId;
  final String selectionReason;
  final String nextAction; // e.g., "EXPLORE", "OPEN", "CLOSE"

  const EngineTrace({
    required this.sessionId,
    required this.timestamp,
    this.previousQuestionId,
    this.lastAnswerValue,
    required this.domainStatesSnapshot,
    required this.candidateQuestionIds,
    required this.rejectedQuestionIds,
    required this.selectedQuestionId,
    required this.selectionReason,
    required this.nextAction,
  });
}
