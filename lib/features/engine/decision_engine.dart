import 'package:projetmascara/features/assessment/assessment_models.dart';
export 'package:projetmascara/features/assessment/assessment_models.dart';

class DeterministicDecisionEngine {
  static const String version = "1.0.0";

  /// Processes answers and returns a prioritized orientation.
  static OrientationResult compute(
    Map<String, int> answers,
    Map<String, bool> safetyAnswers,
  ) {
    // 1. Module Scoring
    final moduleScores = <QuestionModule, int>{};
    for (var question in neuroSyncQuestions) {
      if (!question.isSafety) {
        final val = answers[question.id] ?? 0;
        moduleScores[question.module] = (moduleScores[question.module] ?? 0) + val;
      }
    }

    // 2. Check Red Flags (Immediate priority)
    if (safetyAnswers.values.any((isTriggered) => isTriggered)) {
      return OrientationResult(
        level: OrientationLevel.level4,
        summaryKey: 'summary_urgent_help',
        justifications: ['priority_safety_alert'],
        isRedFlagTriggered: true,
        moduleScores: moduleScores,
      );
    }

    // 3. Composite indicators
    final totalScore = answers.values.fold(0, (sum, val) => sum + val);
    
    // Justification Generation
    final justifications = <String>[];
    if ((moduleScores[QuestionModule.stress] ?? 0) >= 4) justifications.add('high_stress_detected');
    if ((moduleScores[QuestionModule.sleep] ?? 0) >= 4) justifications.add('sleep_issues_detected');
    if ((moduleScores[QuestionModule.phq4] ?? 0) >= 4) justifications.add('mood_tension_detected');
    if ((moduleScores[QuestionModule.relationship] ?? 0) >= 4) justifications.add('relational_tension_detected');
    if ((moduleScores[QuestionModule.cognitive] ?? 0) >= 4) justifications.add('cognitive_bias_detected');
    if ((moduleScores[QuestionModule.functioning] ?? 0) >= 4) justifications.add('functioning_impact_detected');
    if ((moduleScores[QuestionModule.sart] ?? 0) >= 4) justifications.add('trauma_indicators_detected');
    if ((moduleScores[QuestionModule.social] ?? 0) >= 4) justifications.add('relational_tension_detected');
    if ((moduleScores[QuestionModule.emotions] ?? 0) >= 4) justifications.add('emotional_imbalance_detected');
    if ((moduleScores[QuestionModule.selfEsteem] ?? 0) >= 4) justifications.add('self_esteem_concerns');
    if ((moduleScores[QuestionModule.productivity] ?? 0) >= 4) justifications.add('functioning_impact_detected');
    
    // Safety justified if module general or others are present (exploration)
    if (justifications.isEmpty) {
      if (moduleScores.values.any((s) => s > 0)) {
         // Some minor things but not over threshold
      }
    }

    // 4. Threshold Logic
    // Total max score is (25 - 2) * 3 = 69
    OrientationLevel level;
    String summaryKey;

    if (totalScore >= 40) {
      level = OrientationLevel.level3;
      summaryKey = 'summary_contact_recommended';
    } else if (totalScore >= 20) {
      level = OrientationLevel.level2;
      summaryKey = 'summary_consultation_advised';
    } else {
      level = OrientationLevel.level1;
      summaryKey = 'summary_self_care';
    }

    return OrientationResult(
      level: level,
      summaryKey: summaryKey,
      justifications: justifications.isEmpty ? ['general_wellness'] : justifications,
      moduleScores: moduleScores,
    );
  }
}
