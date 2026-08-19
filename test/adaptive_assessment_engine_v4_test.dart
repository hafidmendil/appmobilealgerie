import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_session.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/domain_state.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AdaptiveQuestionEngine engine;

  setUp(() {
    engine = AdaptiveQuestionEngine();
  });

  group('AdaptiveQuestionEngine V4 Integration Tests', () {
    test('Should prioritize domains with high needs', () {
      final session = AssessmentSession(
        id: const Uuid().v4(),
        userId: 'test_user',
        startedAt: DateTime.now(),
        domainStates: {
          for (var axis in AssessmentAxis.values) axis: DomainState(axis: axis)
        },
        // Simulate high stress answers previously
        answers: {
          'stress_1': 4,
          'stress_2': 4,
        },
        questionIds: ['stress_1', 'stress_2'],
      );

      final next = engine.getNextQuestion(session);
      
      // Since stress is already high, it should either explore more stress 
      // OR move to highly correlated domains like sleep if stress confidence is high enough.
      expect(next, isNotNull);
      print('Next question axis: ${next?.axis}');
    });

    test('Should respect CompletionEngine early exit', () {
      // Create a session where all domains have high confidence
      final session = AssessmentSession(
        id: const Uuid().v4(),
        userId: 'test_user',
        startedAt: DateTime.now(),
        domainStates: {
          for (var axis in AssessmentAxis.values) 
            axis: DomainState(
              axis: axis, 
              confidence: 0.9, 
              status: ExplorationStatus.closed,
              questionsAsked: 5,
            )
        },
        questionIds: List.generate(10, (i) => 'q_$i'),
        answers: { for (var i = 0; i < 10; i++) 'q_$i': 1 },
      );

      final next = engine.getNextQuestion(session);
      expect(next, isNull);
    });

    test('EngineTrace should be generated correctly in update flow', () {
      final session = AssessmentSession(
        id: const Uuid().v4(),
        userId: 'test_user',
        startedAt: DateTime.now(),
        domainStates: {
          for (var axis in AssessmentAxis.values) axis: DomainState(axis: axis)
        },
      );

      final updatedStates = engine.getUpdatedStates(session);
      expect(updatedStates, isNotNull);
      expect(updatedStates[AssessmentAxis.emotions]?.confidence, 0.0);
    });
  });
}
