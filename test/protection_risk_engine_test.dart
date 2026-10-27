import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/protection/domain/engines/adaptive_protection_question_engine.dart';
import 'package:projetmascara/features/protection/domain/engines/violence_risk_engine.dart';
import 'package:projetmascara/features/protection/domain/models/protection_models.dart';

void main() {
  const engine = ViolenceRiskEngine();

  test('critical red flag takes priority over cumulative score', () {
    final assessment = engine.assess(
      id: 'risk-1',
      reportId: 'report-1',
      answers: {
        'currentDanger': AnswerValue.yes,
        'repeated': AnswerValue.yes,
        'isolation': AnswerValue.yes,
      },
    );

    expect(assessment.level, RiskLevel.immediate);
    expect(assessment.emergencyFlags, contains('currentDanger'));
    expect(assessment.engineVersion, 'neurosync-violence-risk-2.0');
  });

  test('prefer not to answer is not treated as no or yes', () {
    final assessment = engine.assess(
      id: 'risk-2',
      reportId: 'report-2',
      answers: {'currentDanger': AnswerValue.preferNotToAnswer},
    );

    expect(assessment.level, RiskLevel.none);
    expect(assessment.factors, isEmpty);
  });

  test(
    'adaptive engine does not repeat answered questions and adapts digital questions',
    () {
      const adaptive = AdaptiveProtectionQuestionEngine();
      final question = adaptive.next(
        categories: {ViolenceType.digital},
        answers: {'currentDanger': AnswerValue.no},
      );

      expect(question, isNotNull);
      expect(question!.id, isNot('currentDanger'));
      expect(
        {question.id},
        anyOf(
          contains('seriousThreat'),
          contains('digitalBlackmail'),
          contains('digitalSharing'),
        ),
      );
    },
  );
}
