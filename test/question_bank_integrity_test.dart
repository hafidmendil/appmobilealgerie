import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/adaptive_assessment/data/question_bank.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_question.dart';

void main() {
  group('QuestionBank Integrity Tests', () {
    test('All questions must have unique IDs', () {
      final ids = QuestionBank.questions.map((q) => q.id).toList();
      final uniqueIds = ids.toSet();
      expect(ids.length, uniqueIds.length, reason: 'Duplicate IDs found in QuestionBank');
    });

    test('All questions must have non-empty translations', () {
      for (var q in QuestionBank.questions) {
        expect(q.textFr.isNotEmpty, true, reason: 'Question ${q.id} has empty FR text');
        expect(q.textAr.isNotEmpty, true, reason: 'Question ${q.id} has empty AR text');
        expect(q.textDarja?.isNotEmpty ?? true, true, reason: 'Question ${q.id} has empty Darja text');
      }
    });

    test('All options must have non-empty translations', () {
      for (var q in QuestionBank.questions) {
        for (var o in q.options) {
          expect(o.textFr.isNotEmpty, true, reason: 'Option in ${q.id} has empty FR text');
          expect(o.textAr.isNotEmpty, true, reason: 'Option in ${q.id} has empty AR text');
        }
      }
    });

    test('NextRules must reference existing target IDs', () {
      final allIds = QuestionBank.questions.map((q) => q.id).toSet();
      for (var q in QuestionBank.questions) {
        for (var rule in q.nextRules) {
          expect(allIds.contains(rule.targetQuestionId), true, 
              reason: 'Question ${q.id} references non-existent target ${rule.targetQuestionId}');
        }
      }
    });
  });
}
