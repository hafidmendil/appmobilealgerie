import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';
import 'package:projetmascara/features/engine/adaptive_assessment_engine.dart';

void main() {
  final bank = [
    Question(
      id: 'q1',
      textKey: 'q1',
      module: QuestionModule.general,
      basePriority: 100,
      options: [Option(textKey: 'o0', value: 0), Option(textKey: 'o1', value: 1)],
    ),
    Question(
      id: 'q2_stress',
      textKey: 'q2',
      module: QuestionModule.stress,
      condition: QuestionCondition(dependentQuestionId: 'q1', requiredValues: [1]),
      basePriority: 2000, // Increased to beat safety in this test scenario
      options: [Option(textKey: 'o0', value: 0)],
    ),
    Question(
      id: 'q3_safety',
      textKey: 'q3',
      module: QuestionModule.safety,
      isSafety: true,
      basePriority: 1000,
      options: [
        Option(textKey: 'o0', value: 0),
        Option(textKey: 'o1', value: 1, isSafetyTrigger: true)
      ],
    ),
  ];

  final engine = AdaptiveAssessmentEngine(questionBank: bank);

  group('Adaptive Assessment Engine Branching', () {
    test('Should trigger branching based on condition (User A - High Stress)', () {
      final qNext = engine.getNextQuestion({'q1': 1});
      expect(qNext?.id, equals('q2_stress'));
    });

    test('Should skip branch if condition not met (User B - No Stress)', () {
      final qNext = engine.getNextQuestion({'q1': 0});
      // Should find next available or return null if nothing left (excluding q2_stress and q1)
      expect(qNext?.id, equals('q3_safety'));
    });

    test('Safety trigger should stop normal flow', () {
      final result = engine.computeResult({'q3_safety': 1});
      expect(result.isRedFlagTriggered, true);
    });

    test('Engine should return null when no questions available', () {
      final qNext = engine.getNextQuestion({'q1': 0, 'q3_safety': 0});
      expect(qNext, isNull);
    });
  });
}
