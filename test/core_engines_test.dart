import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/adaptive_assessment/data/question_bank.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/orientation_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/safety_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/scoring_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_result.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_session.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/domain_state.dart';

void main() {
  group('Current assessment engines', () {
    test('urgent safety answer interrupts the assessment', () {
      final safety = SafetyEngine();
      final decision = safety.evaluate({'Q452': 3});

      expect(decision.status, SafetyStatus.urgentSupport);
      expect(decision.shouldStopAssessment, isTrue);
      expect(decision.isNonDiagnostic, isTrue);
    });

    test('non-scored context does not inflate a clinical need', () {
      final needs = ScoringEngine().calculateAxisNeeds({
        'Q000_Concern': 3,
        'Q251': 4,
      });

      expect(needs[AssessmentAxis.angerRegulation], 1);
      expect(needs[AssessmentAxis.general], 0);
    });

    test('safety has priority over the regular orientation score', () {
      final orientation = OrientationEngine().determineLevel(
        {'Q452': 3},
        {for (final axis in AssessmentAxis.values) axis: 0.0},
      );

      expect(orientation, OrientationLevel.level4);
    });

    test('anger concern selects the anger-regulation question first', () {
      final session = AssessmentSession(
        id: 'assessment-1',
        userId: 'user-1',
        startedAt: DateTime(2026),
        questionIds: const ['Q000_Concern', 'Q000_Activity', 'Q000_Living'],
        answers: const {'Q000_Concern': 3},
        domainStates: {
          for (final axis in AssessmentAxis.values)
            axis: DomainState(axis: axis),
        },
      );

      expect(AdaptiveQuestionEngine().getNextQuestion(session)?.id, 'Q251');
      expect(
        QuestionBank.questions.any((question) => question.id == 'Q251'),
        isTrue,
      );
    });
  });
}
