import 'assessment_axis.dart';
import 'domain_state.dart';
import 'engine_trace.dart';

class AssessmentSession {
  final String id;
  final String userId;
  final List<String> questionIds;
  final Map<String, int?> answers;
  final Map<AssessmentAxis, DomainState> domainStates;
  final List<EngineTrace> traces;
  final String? currentBranch;
  final String version;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isSafetyInterrupted;

  const AssessmentSession({
    required this.id,
    required this.userId,
    this.questionIds = const [],
    this.answers = const {},
    this.domainStates = const {},
    this.traces = const [],
    this.currentBranch,
    this.version = '1.0',
    required this.startedAt,
    this.completedAt,
    this.isSafetyInterrupted = false,
  });

  AssessmentSession copyWith({
    List<String>? questionIds,
    Map<String, int?>? answers,
    Map<AssessmentAxis, DomainState>? domainStates,
    List<EngineTrace>? traces,
    String? currentBranch,
    DateTime? completedAt,
    bool? isSafetyInterrupted,
  }) {
    return AssessmentSession(
      id: id,
      userId: userId,
      questionIds: questionIds ?? this.questionIds,
      answers: answers ?? this.answers,
      domainStates: domainStates ?? this.domainStates,
      traces: traces ?? this.traces,
      currentBranch: currentBranch ?? this.currentBranch,
      version: version,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      isSafetyInterrupted: isSafetyInterrupted ?? this.isSafetyInterrupted,
    );
  }
}
