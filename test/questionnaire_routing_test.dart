import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/adaptive_assessment/data/question_bank.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_session.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/domain_state.dart';
import 'package:projetmascara/features/health/data/health_quiz_catalog.dart';

void main() {
  test('the anger path prioritizes anger-regulation questions', () {
    final concern = QuestionBank.questions.firstWhere(
      (question) => question.id == 'Q000_Concern',
    );
    expect(concern.options.map((option) => option.value), contains(3));
    expect(
      concern.nextRules.any(
        (rule) =>
            rule.triggerValues.contains(3) && rule.targetQuestionId == 'Q251',
      ),
      isTrue,
    );

    final session = AssessmentSession(
      id: 'test-session',
      userId: 'test-user',
      startedAt: DateTime(2026),
      questionIds: const ['Q000_Concern', 'Q000_Activity', 'Q000_Living'],
      answers: const {'Q000_Concern': 3},
      domainStates: {
        for (final axis in AssessmentAxis.values) axis: DomainState(axis: axis),
      },
    );

    expect(AdaptiveQuestionEngine().getNextQuestion(session)?.id, 'Q251');
  });

  test('health quizzes use a question set matching their service category', () {
    final nutrition = HealthQuizCatalog.questionsFor('nutrition');
    final sleep = HealthQuizCatalog.questionsFor('sleepHabits');
    final wellbeing = HealthQuizCatalog.questionsFor('psychologicalWellbeing');

    expect(nutrition.first.textFr, isNot(sleep.first.textFr));
    expect(sleep.first.textAr, contains('النوم'));
    expect(wellbeing.first.textAr, contains('التوتر'));
  });
}
