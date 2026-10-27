import '../models/assessment_axis.dart';
import '../models/assessment_question.dart';
import '../models/assessment_session.dart';
import '../models/domain_state.dart';
import '../models/engine_trace.dart';
import '../../data/question_bank.dart';
import 'scoring_engine.dart';
import 'priority_engine.dart';
import 'confidence_engine.dart';
import 'completion_engine.dart';
import 'rule_engine.dart';

class AdaptiveQuestionEngine {
  final ScoringEngine _scoringEngine = ScoringEngine();
  final PriorityEngine _priorityEngine = PriorityEngine();
  final ConfidenceEngine _confidenceEngine = ConfidenceEngine();
  final CompletionEngine _completionEngine = CompletionEngine();
  final RuleEngine _ruleEngine = RuleEngine();

  /// Processes the latest answer and returns the next question or null if finished.
  /// Also updates the session state with new domain states and a trace.
  AssessmentQuestion? getNextQuestion(AssessmentSession session) {
    // Safety check should be done before calling this.

    // 3. Update Context
    final needs = _scoringEngine.calculateAxisNeeds(session.answers);

    var domainStates = _scoringEngine.updateDomainStates(
      session.domainStates,
      session.answers,
      needs,
    );

    domainStates = _confidenceEngine.calculateConfidence(
      domainStates,
      session.questionIds.length,
    );

    domainStates = _ruleEngine.evaluateRules(domainStates, needs);

    domainStates = _priorityEngine.adjustPriorities(domainStates, needs);

    // 3. Completion Check
    if (_completionEngine.shouldStopAssessment(
      domainStates,
      session.questionIds.length,
    )) {
      return null;
    }

    // 4. Selection Logic
    final candidates = QuestionBank.questions.where((q) {
      if (session.questionIds.contains(q.id)) return false;

      final state = domainStates[q.axis];
      if (state == null || state.status == ExplorationStatus.closed)
        return false;

      return true;
    }).toList();

    if (candidates.isEmpty) return null;

    final scores = <String, double>{};
    for (var q in candidates) {
      final state = domainStates[q.axis]!;
      double score = q.basePriority.toDouble() + state.priority;
      score += state.score * 250;
      score += _contextBoost(q.axis, session.answers);

      // Rule boost
      score += _calculateRuleBoost(q.id, session.answers);

      // Diversity penalty
      final askedInAxis = session.questionIds.where((id) {
        final aq = QuestionBank.questions.firstWhere((aq) => aq.id == id);
        return aq.axis == q.axis;
      }).length;
      score -= askedInAxis * 40;

      scores[q.id] = score;
    }

    candidates.sort((a, b) {
      final scoreComparison = (scores[b.id] ?? 0.0).compareTo(
        scores[a.id] ?? 0.0,
      );
      if (scoreComparison != 0) return scoreComparison;
      return _tieBreakScore(
        b.id,
        session,
      ).compareTo(_tieBreakScore(a.id, session));
    });
    final selected = candidates.first;

    // 5. Trace & Session Update (These would be applied back to the session by the caller)
    // Note: session.domainStates and session.traces are updated in the notifier.

    return selected;
  }

  List<String> getCandidateQuestionIds(AssessmentSession session) {
    final needs = _scoringEngine.calculateAxisNeeds(session.answers);
    var states = _scoringEngine.updateDomainStates(
      session.domainStates,
      session.answers,
      needs,
    );
    states = _confidenceEngine.calculateConfidence(
      states,
      session.questionIds.length,
    );
    states = _ruleEngine.evaluateRules(states, needs);
    states = _priorityEngine.adjustPriorities(states, needs);

    return QuestionBank.questions
        .where(
          (question) =>
              !session.questionIds.contains(question.id) &&
              states[question.axis]?.status != ExplorationStatus.closed,
        )
        .map((question) => question.id)
        .toList();
  }

  // Helper for notifier to get updated states
  Map<AssessmentAxis, DomainState> getUpdatedStates(AssessmentSession session) {
    final needs = _scoringEngine.calculateAxisNeeds(session.answers);
    var domainStates = _scoringEngine.updateDomainStates(
      session.domainStates,
      session.answers,
      needs,
    );
    domainStates = _confidenceEngine.calculateConfidence(
      domainStates,
      session.questionIds.length,
    );
    domainStates = _ruleEngine.evaluateRules(domainStates, needs);
    domainStates = _priorityEngine.adjustPriorities(domainStates, needs);
    return domainStates;
  }

  double _calculateRuleBoost(String targetId, Map<String, int?> answers) {
    double boost = 0;
    for (var entry in answers.entries) {
      final q = QuestionBank.questions.firstWhere((q) => q.id == entry.key);
      for (var rule in q.nextRules) {
        if (rule.targetQuestionId == targetId &&
            rule.triggerValues.contains(entry.value)) {
          boost += rule.priorityBoost;
        }
      }
    }
    return boost;
  }

  int _tieBreakScore(String questionId, AssessmentSession session) {
    final answerSeed = session.answers.values.fold<int>(
      17,
      (seed, answer) => seed * 31 + (answer ?? -1),
    );
    final questionSeed = questionId.codeUnits.fold<int>(
      0,
      (sum, code) => sum + code,
    );
    return (answerSeed + questionSeed) & 0x7fffffff;
  }

  double _contextBoost(AssessmentAxis axis, Map<String, int?> answers) {
    final concern = answers['Q000_Concern'];
    switch (concern) {
      case 0:
        return axis == AssessmentAxis.stressAnxiety ? 180 : 0;
      case 1:
        return axis == AssessmentAxis.emotions ||
                axis == AssessmentAxis.sleepEnergy
            ? 180
            : 0;
      case 2:
        return axis == AssessmentAxis.socialSupport ? 180 : 0;
      case 3:
        return axis == AssessmentAxis.angerRegulation ? 180 : 0;
      default:
        return 0;
    }
  }
}
