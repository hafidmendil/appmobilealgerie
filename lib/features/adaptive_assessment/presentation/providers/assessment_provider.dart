import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/assessment_session.dart';
import '../../domain/models/assessment_question.dart';
import '../../domain/engines/adaptive_question_engine.dart';
import '../../domain/engines/safety_engine.dart';
import '../../domain/engines/scoring_engine.dart';
import '../../domain/engines/orientation_engine.dart';
import '../../domain/engines/recommendation_engine.dart';
import '../../domain/models/assessment_result.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../domain/engines/message_analysis_engine.dart';

import '../../domain/models/engine_trace.dart';
import '../../domain/models/domain_state.dart';
import '../../domain/models/assessment_axis.dart';

class AssessmentState {
  final AssessmentSession? session;
  final AssessmentQuestion? currentQuestion;
  final bool isLoading;
  final AssessmentResult? result;
  final bool isSafetyAlert;

  AssessmentState({
    this.session,
    this.currentQuestion,
    this.isLoading = false,
    this.result,
    this.isSafetyAlert = false,
  });

  AssessmentState copyWith({
    AssessmentSession? session,
    AssessmentQuestion? currentQuestion,
    bool? isLoading,
    AssessmentResult? result,
    bool? isSafetyAlert,
  }) {
    return AssessmentState(
      session: session ?? this.session,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      isSafetyAlert: isSafetyAlert ?? this.isSafetyAlert,
    );
  }
}

class AssessmentNotifier extends StateNotifier<AssessmentState> {
  final AdaptiveQuestionEngine _adaptiveEngine = AdaptiveQuestionEngine();
  final SafetyEngine _safetyEngine = SafetyEngine();
  final ScoringEngine _scoringEngine = ScoringEngine();
  final OrientationEngine _orientationEngine = OrientationEngine();
  final RecommendationEngine _recommendationEngine = RecommendationEngine();
  final MessageAnalysisEngine _messageEngine = MessageAnalysisEngine();
  final AssessmentRepository _repository = AssessmentRepository();

  AssessmentNotifier() : super(AssessmentState()) {
    _repository.init();
  }

  void startSession(String userId, {int? initialConcern}) {
    state = AssessmentState(); // Reset state
    final session = AssessmentSession(
      id: const Uuid().v4(),
      userId: userId,
      startedAt: DateTime.now(),
      questionIds: initialConcern == null ? const [] : const ['Q000_Concern'],
      answers: initialConcern == null
          ? const {}
          : {'Q000_Concern': initialConcern},
      domainStates: {
        for (var axis in AssessmentAxis.values) axis: DomainState(axis: axis),
      },
    );
    state = state.copyWith(session: session, isLoading: true);
    _nextQuestion();
  }

  void answerQuestion(int? value) {
    if (state.currentQuestion == null || state.session == null) return;

    final updatedAnswers = Map<String, int?>.from(state.session!.answers);
    updatedAnswers[state.currentQuestion!.id] = value;

    final updatedSession = state.session!.copyWith(answers: updatedAnswers);
    state = state.copyWith(session: updatedSession);

    if (_safetyEngine.isSafetyTriggered(updatedAnswers)) {
      state = state.copyWith(isSafetyAlert: true);
      _finishAssessment(isSafetyInterrupted: true);
    } else {
      _nextQuestion();
    }
  }

  Future<void> _nextQuestion() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true);

    final next = _adaptiveEngine.getNextQuestion(state.session!);
    final updatedStates = _adaptiveEngine.getUpdatedStates(state.session!);
    final candidateQuestionIds = _adaptiveEngine.getCandidateQuestionIds(
      state.session!,
    );
    final rejectedQuestionIds = candidateQuestionIds
        .where((id) => id != next?.id)
        .toList();

    if (next == null) {
      _finishAssessment();
    } else {
      final updatedQuestionIds = List<String>.from(state.session!.questionIds);
      updatedQuestionIds.add(next.id);

      final trace = EngineTrace(
        sessionId: state.session!.id,
        timestamp: DateTime.now(),
        previousQuestionId: state.session!.questionIds.isEmpty
            ? null
            : state.session!.questionIds.last,
        lastAnswerValue: state.session!.questionIds.isEmpty
            ? null
            : state.session!.answers[state.session!.questionIds.last],
        domainStatesSnapshot: updatedStates,
        candidateQuestionIds: candidateQuestionIds,
        rejectedQuestionIds: rejectedQuestionIds,
        selectedQuestionId: next.id,
        selectionReason:
            'Highest score from prior answers, axis needs, rules and diversity',
        nextAction: updatedStates[next.axis]?.status.name ?? 'EXPLORE',
      );

      final updatedTraces = List<EngineTrace>.from(state.session!.traces);
      updatedTraces.add(trace);

      state = state.copyWith(
        currentQuestion: next,
        session: state.session!.copyWith(
          questionIds: updatedQuestionIds,
          domainStates: updatedStates,
          traces: updatedTraces,
        ),
        isLoading: false,
      );
    }
  }

  void finishWithMessage(String message) {
    final themes = _messageEngine.analyzeThemes(message);
    _finishAssessment(userMessage: message, themes: themes);
  }

  void _finishAssessment({
    bool isSafetyInterrupted = false,
    String? userMessage,
    List<String>? themes,
  }) {
    final answers = state.session?.answers ?? {};
    final needs = _scoringEngine.calculateAxisNeeds(answers);
    final orientation = _orientationEngine.determineLevel(answers, needs);
    final justifications = _orientationEngine.getJustifications(
      needs,
      orientation,
    );
    final recs = _recommendationEngine.getRecommendations(needs, 3);

    final result = AssessmentResult(
      sessionId: state.session!.id,
      axisNeeds: needs,
      orientationLevel: orientation,
      identifiedThemes: justifications,
      recommendationIds: recs.map((r) => r.id).toList(),
      exerciseIds: [],
      spiritualContentIds: [],
      userFreeMessage: userMessage,
      createdAt: DateTime.now(),
    );

    _repository.saveResult(
      result,
      userId: state.session!.userId,
      answers: answers,
      safetyAnswers: {
        'urgent_support': _safetyEngine.isSafetyTriggered(answers),
      },
    );

    state = state.copyWith(
      result: result,
      currentQuestion: null,
      isLoading: false,
      session: state.session?.copyWith(
        completedAt: DateTime.now(),
        isSafetyInterrupted: isSafetyInterrupted,
      ),
    );
  }
}

final assessmentProvider =
    StateNotifierProvider<AssessmentNotifier, AssessmentState>((ref) {
      return AssessmentNotifier();
    });

final latestResultProvider = Provider<AssessmentResult?>((ref) {
  final state = ref.watch(assessmentProvider);
  if (state.result != null) return state.result;
  // This is a simplified logic, in real app it would fetch from repository
  return null;
});
