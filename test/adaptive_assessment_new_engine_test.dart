import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/scoring_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/safety_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';

void main() {
  final adaptiveEngine = AdaptiveQuestionEngine();
  final scoringEngine = ScoringEngine();
  final safetyEngine = SafetyEngine();

  group('New Adaptive Assessment Module Tests', () {
    test('ScoringEngine should calculate needs correctly', () {
      final answers = {
        'Q001': 4, // Emotions max
        'Q051': 2, // Stress mid
      };
      final needs = scoringEngine.calculateAxisNeeds(answers);
      
      expect(needs[AssessmentAxis.emotions], greaterThan(0));
      expect(needs[AssessmentAxis.stressAnxiety], greaterThan(0));
      expect(needs[AssessmentAxis.sleepEnergy], equals(0));
    });

    test('SafetyEngine should detect safety triggers', () {
      final safeAnswers = {'Q451': 0}; // "Yes" to safety
      final riskyAnswers = {'Q451': 4}; // "No" to safety (trigger)
      
      expect(safetyEngine.isSafetyTriggered(safeAnswers), isFalse);
      expect(safetyEngine.isSafetyTriggered(riskyAnswers), isTrue);
    });

    test('AdaptiveQuestionEngine should respect max questions', () {
      final askedIds = List.generate(15, (i) => 'Q$i');
      final next = adaptiveEngine.getNextQuestion(
        askedQuestionIds: askedIds, 
        answers: {},
      );
      expect(next, isNull);
    });

    test('AdaptiveQuestionEngine should return a question from the bank', () {
      final next = adaptiveEngine.getNextQuestion(
        askedQuestionIds: [], 
        answers: {},
      );
      expect(next, isNotNull);
      expect(next!.id, isNotEmpty);
    });
  });
}
