import 'package:projetmascara/features/engine/decision_engine.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';

class ClinicalReportGenerator {
  static Map<String, dynamic> generate(OrientationResult result, Map<String, int> answers) {
    return {
      'scoreTotal': result.level.index + 1,
      'riskLevel': _getRiskLevel(result.level),
      'psychologicalProfile': _analyzeProfile(answers),
      'recommendations': _getRecommendations(result.level),
      'detailedInterpretations': result.justifications,
    };
  }

  static String _getRiskLevel(OrientationLevel level) {
    switch (level) {
      case OrientationLevel.level1: return "level1Title";
      case OrientationLevel.level2: return "level2Title";
      case OrientationLevel.level3: return "level3Title";
      case OrientationLevel.level4: return "level4Title";
    }
  }

  static List<String> _analyzeProfile(Map<String, int> answers) {
    final List<String> profile = [];
    
    // Module: Stress & Trauma
    int stressSum = (answers['stress_1'] ?? 0) + (answers['stress_2'] ?? 0);
    int traumaSum = (answers['trauma_1'] ?? 0) + (answers['trauma_2'] ?? 0);
    if (traumaSum > 3) profile.add("profile_intrusion_symptoms");
    if (stressSum > 4) profile.add("profile_high_stress");

    // Module: Cognition
    int cogSum = (answers['cog_1'] ?? 0) + (answers['cog_2'] ?? 0) + (answers['cog_3'] ?? 0);
    if (cogSum > 5) profile.add("profile_cognitive_bias");
    if ((answers['cog_1'] ?? 0) > 2) profile.add("profile_hostile_attribution");

    // Module: Social & Future
    int relSum = (answers['rel_1'] ?? 0) + (answers['rel_2'] ?? 0);
    if (relSum > 4) profile.add("profile_relational_distress");
    if ((answers['future_1'] ?? 0) > 2) profile.add("profile_hopelessness");

    // Module: Sleep
    int sleepSum = (answers['sleep_1'] ?? 0) + (answers['sleep_2'] ?? 0);
    if (sleepSum > 4) profile.add("profile_sleep_disturbance");

    if (profile.isEmpty) profile.add("profile_balanced");

    return profile;
  }

  static List<String> _getRecommendations(OrientationLevel level) {
    switch (level) {
      case OrientationLevel.level1:
        return ["rec_hygiene", "rec_mindfulness"];
      case OrientationLevel.level2:
        return ["rec_routine_consultation", "rec_sleep_eval"];
      case OrientationLevel.level3:
        return ["rec_weekly_followup", "rec_social_support"];
      case OrientationLevel.level4:
        return ["rec_immediate_psychiatry", "rec_safety_protocol", "rec_specialized_care"];
    }
  }
}
