import 'package:projetmascara/features/adaptive_assessment/data/question_bank.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_axis.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_question.dart';

enum OrientationLevel {
  level1, // Auto-apaisement guidé
  level2, // Consultation conseillée
  level3, // Contact rapide recommandé
  level4, // Aide immédiate
}

enum QuestionModule {
  safety,
  phq4, // Depression/Anxiety
  sleep,
  stress,
  functioning,
  relationship,
  attributionBias,
  sart, // Trauma
  health,
  social,
  economic,
  spiritual,
  general,
  emotions,
  productivity,
  angerRegulation,
  selfConfidence,
  dailyPressures,
  lifestyle,
  emotionalManagement,
  behavioral,
  cognitive,
  environmental,
  selfEsteem
}

enum ContentLibraryType {
  psychological,
  practical,
  spiritual,
  educational,
  action
}

class QuranVerse {
  final String id;
  final int surahNumber;
  final int verseNumber;
  final String textAr;
  final String textFr;
  final String theme;
  final String? context;
  final String? reflection;
  final List<QuestionModule> associatedDomains;

  QuranVerse({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    required this.textAr,
    required this.textFr,
    required this.theme,
    this.context,
    this.reflection,
    this.associatedDomains = const [],
  });
}

class Hadith {
  final String id;
  final String collection;
  final String number;
  final String textAr;
  final String textFr;
  final String? grade;
  final String theme;
  final String source;
  final List<QuestionModule> associatedDomains;

  Hadith({
    required this.id,
    required this.collection,
    required this.number,
    required this.textAr,
    required this.textFr,
    this.grade,
    required this.theme,
    required this.source,
    this.associatedDomains = const [],
  });
}

class PsychologicalResource {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String contentKey;
  final String duration;
  final QuestionModule domain;
  final String? source;
  final ContentLibraryType type;

  PsychologicalResource({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.contentKey,
    required this.duration,
    required this.domain,
    this.source,
    this.type = ContentLibraryType.psychological,
  });
}

class MicroAction {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final QuestionModule domain;
  final ContentLibraryType type;
  final int estimatedMinutes;

  MicroAction({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.domain,
    this.type = ContentLibraryType.action,
    this.estimatedMinutes = 5,
  });
}

class OrientationResult {
  final OrientationLevel level;
  final String summaryKey;
  final List<String> justifications;
  final List<String> strengths;
  final bool isRedFlagTriggered;
  final Map<QuestionModule, int> moduleScores;
  final List<OrientationRecommendation> recommendations;

  OrientationResult({
    required this.level,
    required this.summaryKey,
    this.justifications = const [],
    this.strengths = const [],
    this.isRedFlagTriggered = false,
    this.moduleScores = const {},
    this.recommendations = const [],
  });
}

class Question {
  final String id;
  final String textKey;
  final String? whyKey; // Explanation for "Why this question?"
  final QuestionModule module;
  final bool isSafety;
  final List<Option> options;
  final QuestionCondition? condition;
  final List<QuestionRule> followUpRules;
  final int basePriority;
  final String? source;
  final String? license;
  final String? version;

  Question({
    required this.id,
    required this.textKey,
    this.whyKey,
    required this.module,
    this.isSafety = false,
    this.options = const [],
    this.condition,
    this.followUpRules = const [],
    this.basePriority = 0,
    this.source,
    this.license,
    this.version,
  });
}

class Option {
  final String textKey;
  final int value;
  final bool isSafetyTrigger;

  Option({
    required this.textKey,
    required this.value,
    this.isSafetyTrigger = false,
  });
}

class QuestionCondition {
  final String? dependentQuestionId;
  final List<int>? requiredValues;
  final Map<QuestionModule, int>? minModuleScore;

  QuestionCondition({
    this.dependentQuestionId,
    this.requiredValues,
    this.minModuleScore,
  });

  bool evaluate(Map<String, int> answers, Map<QuestionModule, int> moduleScores) {
    if (dependentQuestionId != null) {
      final val = answers[dependentQuestionId!];
      if (val == null || (requiredValues != null && !requiredValues!.contains(val))) {
        return false;
      }
    }
    if (minModuleScore != null) {
      for (final entry in minModuleScore!.entries) {
        if ((moduleScores[entry.key] ?? 0) < entry.value) {
          return false;
        }
      }
    }
    return true;
  }
}

class QuestionRule {
  final List<int> triggerValues;
  final String targetQuestionId;
  final int priorityBoost;

  QuestionRule({
    required this.triggerValues,
    required this.targetQuestionId,
    this.priorityBoost = 0,
  });
}

class DimensionScore {
  final QuestionModule module;
  final int score;
  final int maxPossible;
  final double normalized;

  DimensionScore({
    required this.module,
    required this.score,
    required this.maxPossible,
  }) : normalized = maxPossible > 0 ? score / maxPossible : 0.0;
}

class SafetySignal {
  final String questionId;
  final String messageKey;
  final bool isUrgent;

  SafetySignal({
    required this.questionId,
    required this.messageKey,
    this.isUrgent = false,
  });
}

class OrientationRecommendation {
  final String titleKey;
  final String descriptionKey;
  final List<String> resourceIds;
  final String? professionalType;
  final bool isEmergency;

  OrientationRecommendation({
    required this.titleKey,
    required this.descriptionKey,
    this.resourceIds = const [],
    this.professionalType,
    this.isEmergency = false,
  });
}

class EvidenceReference {
  final String source;
  final String author;
  final String? publication;
  final String? evidenceLevel;
  final bool isVerified;

  EvidenceReference({
    required this.source,
    required this.author,
    this.publication,
    this.evidenceLevel,
    this.isVerified = false,
  });
}

class AssessmentSession {
  final String id;
  final DateTime startTime;
  final Map<String, int> answers;
  final List<String> path;
  final List<String> skippedQuestions;
  final double progressEstimate;
  final bool isCompleted;

  AssessmentSession({
    required this.id,
    required this.startTime,
    this.answers = const {},
    this.path = const [],
    this.skippedQuestions = const [],
    this.progressEstimate = 0.0,
    this.isCompleted = false,
  });

  AssessmentSession copyWith({
    Map<String, int>? answers,
    List<String>? path,
    List<String>? skippedQuestions,
    double? progressEstimate,
    bool? isCompleted,
  }) {
    return AssessmentSession(
      id: id,
      startTime: startTime,
      answers: answers ?? this.answers,
      path: path ?? this.path,
      skippedQuestions: skippedQuestions ?? this.skippedQuestions,
      progressEstimate: progressEstimate ?? this.progressEstimate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// Global Question Bank
final List<Question> neuroSyncAdaptiveBank = [
  // --- PREFERENCES ---
  Question(
    id: 'pref_spiritual',
    textKey: 'q_pref_spiritual',
    whyKey: 'why_q_pref_spiritual',
    module: QuestionModule.spiritual,
    basePriority: 200, // Ask early
    options: [
      Option(textKey: 'opt_yes', value: 1),
      Option(textKey: 'opt_no', value: 0),
    ],
  ),

  // --- GENERAL WELLBEING ---
  Question(
    id: 'gen_1',
    textKey: 'q_gen_wellbeing',
    whyKey: 'why_q_gen_wellbeing',
    module: QuestionModule.general,
    basePriority: 100,
    options: _standardOptions(),
  ),
  Question(
    id: 'gen_2',
    textKey: 'q_gen_stress_level',
    whyKey: 'why_q_gen_stress',
    module: QuestionModule.general,
    basePriority: 95,
    options: _standardOptions(),
  ),

  // --- EMOTIONAL STATE ---
  Question(
    id: 'Q001',
    textKey: 'q_emotions_mood',
    whyKey: 'why_q_emotions_mood',
    module: QuestionModule.emotions,
    basePriority: 90,
    options: _standardOptions(),
  ),
  Question(
    id: 'Q002',
    textKey: 'q_emotions_sadness',
    whyKey: 'why_q_emotions_sadness',
    module: QuestionModule.emotions,
    condition: QuestionCondition(dependentQuestionId: 'Q001', requiredValues: [1, 2, 3, 4]),
    basePriority: 85,
    options: _standardOptions(),
  ),
  Question(
    id: 'emo_3',
    textKey: 'q_emotions_loneliness',
    whyKey: 'why_q_emotions_loneliness',
    module: QuestionModule.emotions,
    basePriority: 80,
    options: _standardOptions(),
  ),
  Question(
    id: 'emo_4',
    textKey: 'q_emotions_overload',
    whyKey: 'why_q_emotions_overload',
    module: QuestionModule.emotions,
    basePriority: 75,
    options: _standardOptions(),
  ),

  // --- STRESS ---
  Question(
    id: 'stress_1',
    textKey: 'q_stress_tension',
    whyKey: 'why_q_stress_tension',
    module: QuestionModule.stress,
    basePriority: 80,
    options: _standardOptions(),
  ),
  Question(
    id: 'stress_2',
    textKey: 'q_stress_physical',
    whyKey: 'why_q_stress_physical',
    module: QuestionModule.stress,
    basePriority: 75,
    options: _standardOptions(),
  ),
  Question(
    id: 'stress_3',
    textKey: 'q_stress_overwhelmed',
    whyKey: 'why_q_stress_overwhelmed',
    module: QuestionModule.stress,
    basePriority: 70,
    options: _standardOptions(),
  ),

  // --- EMOTIONAL MANAGEMENT ---
  Question(
    id: 'mgmt_1',
    textKey: 'q_mgmt_difficulty_reaction',
    whyKey: 'why_q_mgmt_reaction',
    module: QuestionModule.emotionalManagement,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'mgmt_2',
    textKey: 'q_mgmt_asking_help',
    whyKey: 'why_q_mgmt_help',
    module: QuestionModule.emotionalManagement,
    basePriority: 65,
    options: _standardOptions(),
  ),
  Question(
    id: 'mgmt_3',
    textKey: 'q_mgmt_emotions_control',
    module: QuestionModule.emotionalManagement,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'mgmt_4',
    textKey: 'q_mgmt_calm_speed',
    module: QuestionModule.emotionalManagement,
    basePriority: 55,
    options: _standardOptions(),
  ),

  // --- SOCIAL RELATIONS ---
  Question(
    id: 'rel_1',
    textKey: 'q_rel_family_tension',
    whyKey: 'why_q_rel_family',
    module: QuestionModule.relationship,
    basePriority: 75,
    options: _standardOptions(),
  ),
  Question(
    id: 'rel_2',
    textKey: 'q_rel_belonging',
    whyKey: 'why_q_rel_belonging',
    module: QuestionModule.relationship,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'rel_3',
    textKey: 'q_rel_conflict_freq',
    module: QuestionModule.relationship,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'rel_4',
    textKey: 'q_rel_trust',
    module: QuestionModule.relationship,
    basePriority: 55,
    options: _standardOptions(),
  ),
  Question(
    id: 'rel_5',
    textKey: 'q_rel_communication',
    module: QuestionModule.relationship,
    basePriority: 50,
    options: _standardOptions(),
  ),

  // --- SELF-ESTEEM & CONFIDENCE ---
  Question(
    id: 'est_1',
    textKey: 'q_est_confidence',
    whyKey: 'why_q_est_confidence',
    module: QuestionModule.selfEsteem,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'est_2',
    textKey: 'q_est_value',
    whyKey: 'why_q_est_value',
    module: QuestionModule.selfEsteem,
    basePriority: 65,
    options: _standardOptions(),
  ),
  Question(
    id: 'est_3',
    textKey: 'q_est_comparison',
    module: QuestionModule.selfEsteem,
    basePriority: 55,
    options: _standardOptions(),
  ),
  Question(
    id: 'est_4',
    textKey: 'q_est_shame',
    module: QuestionModule.selfEsteem,
    basePriority: 50,
    options: _standardOptions(),
  ),
  Question(
    id: 'est_5',
    textKey: 'q_est_decision_confidence',
    module: QuestionModule.selfConfidence,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'est_6',
    textKey: 'q_est_future_confidence',
    module: QuestionModule.selfConfidence,
    basePriority: 55,
    options: _standardOptions(),
  ),

  // --- BEHAVIORAL & ORGANIZATION ---
  Question(
    id: 'beh_1',
    textKey: 'q_beh_organization',
    whyKey: 'why_q_beh_organization',
    module: QuestionModule.behavioral,
    basePriority: 65,
    options: _standardOptions(),
  ),
  Question(
    id: 'beh_2',
    textKey: 'q_beh_motivation',
    whyKey: 'why_q_beh_motivation',
    module: QuestionModule.behavioral,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'beh_3',
    textKey: 'q_beh_procrastination',
    module: QuestionModule.behavioral,
    basePriority: 55,
    options: _standardOptions(),
  ),
  Question(
    id: 'beh_4',
    textKey: 'q_beh_routine',
    module: QuestionModule.behavioral,
    basePriority: 50,
    options: _standardOptions(),
  ),

  // --- COGNITIVE & CONCENTRATION ---
  Question(
    id: 'cog_1',
    textKey: 'q_cog_ruminations',
    whyKey: 'why_q_cog_ruminations',
    module: QuestionModule.cognitive,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'cog_2',
    textKey: 'q_cog_decisions',
    whyKey: 'why_q_cog_decisions',
    module: QuestionModule.cognitive,
    basePriority: 65,
    options: _standardOptions(),
  ),
  Question(
    id: 'cog_3',
    textKey: 'q_cog_concentration',
    whyKey: 'why_q_cog_concentration',
    module: QuestionModule.cognitive,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'cog_4',
    textKey: 'q_cog_memory',
    module: QuestionModule.cognitive,
    basePriority: 55,
    options: _standardOptions(),
  ),

  // --- ANXIETY & WORRY ---
  Question(
    id: 'anx_1',
    textKey: 'q_anx_nervous',
    module: QuestionModule.phq4,
    basePriority: 85,
    options: _standardOptions(),
  ),
  Question(
    id: 'anx_2',
    textKey: 'q_anx_worry',
    module: QuestionModule.phq4,
    basePriority: 80,
    options: _standardOptions(),
  ),
  Question(
    id: 'anx_3',
    textKey: 'q_anx_panic',
    module: QuestionModule.phq4,
    basePriority: 75,
    options: _standardOptions(),
  ),

  // --- SLEEP & FATIGUE ---
  Question(
    id: 'slp_1',
    textKey: 'q_sleep_difficulty',
    module: QuestionModule.sleep,
    basePriority: 75,
    options: _standardOptions(),
  ),
  Question(
    id: 'slp_2',
    textKey: 'q_sleep_early_wake',
    module: QuestionModule.sleep,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'slp_3',
    textKey: 'q_sleep_fatigue_day',
    module: QuestionModule.sleep,
    basePriority: 65,
    options: _standardOptions(),
  ),

  // --- LIFESTYLE ---
  Question(
    id: 'life_1',
    textKey: 'q_life_balance',
    module: QuestionModule.lifestyle,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'life_2',
    textKey: 'q_life_digital',
    module: QuestionModule.lifestyle,
    basePriority: 55,
    options: _standardOptions(),
  ),
  Question(
    id: 'life_3',
    textKey: 'q_life_activity',
    module: QuestionModule.lifestyle,
    basePriority: 50,
    options: _standardOptions(),
  ),

  // --- SOCIAL SUPPORT ---
  Question(
    id: 'soc_1',
    textKey: 'q_soc_support_people',
    module: QuestionModule.social,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'soc_2',
    textKey: 'q_soc_isolation',
    module: QuestionModule.social,
    basePriority: 65,
    options: _standardOptions(),
  ),
  Question(
    id: 'soc_3',
    textKey: 'q_soc_help_ease',
    module: QuestionModule.social,
    basePriority: 60,
    options: _standardOptions(),
  ),

  // --- PRODUCTIVITY & PRESSURE ---
  Question(
    id: 'prod_1',
    textKey: 'q_prod_efficiency',
    module: QuestionModule.productivity,
    basePriority: 65,
    options: _standardOptions(),
  ),
  Question(
    id: 'prod_2',
    textKey: 'q_prod_motivation',
    module: QuestionModule.productivity,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'prod_3',
    textKey: 'q_prod_pressure_academic',
    module: QuestionModule.dailyPressures,
    basePriority: 75,
    options: _standardOptions(),
  ),
  Question(
    id: 'prod_4',
    textKey: 'q_prod_pressure_work',
    module: QuestionModule.dailyPressures,
    basePriority: 70,
    options: _standardOptions(),
  ),
  Question(
    id: 'prod_5',
    textKey: 'q_prod_future_pressure',
    module: QuestionModule.dailyPressures,
    basePriority: 65,
    options: _standardOptions(),
  ),

  // --- HEALTH ---
  Question(
    id: 'hlth_1',
    textKey: 'q_hlth_chronic_pain',
    module: QuestionModule.health,
    basePriority: 50,
    options: _standardOptions(),
  ),
  Question(
    id: 'hlth_2',
    textKey: 'q_hlth_appetite',
    module: QuestionModule.health,
    basePriority: 45,
    options: _standardOptions(),
  ),

  // --- ENVIRONMENTAL ---
  Question(
    id: 'env_1',
    textKey: 'q_env_safety',
    whyKey: 'why_q_env_safety',
    module: QuestionModule.environmental,
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'env_2',
    textKey: 'q_env_pressure',
    whyKey: 'why_q_env_pressure',
    module: QuestionModule.environmental,
    basePriority: 55,
    options: _standardOptions(),
  ),
  Question(
    id: 'env_3',
    textKey: 'q_env_noise',
    module: QuestionModule.environmental,
    basePriority: 40,
    options: _standardOptions(),
  ),
  Question(
    id: 'env_4',
    textKey: 'q_env_housing',
    module: QuestionModule.environmental,
    basePriority: 35,
    options: _standardOptions(),
  ),

  // --- SPIRITUAL ---
  Question(
    id: 'spi_1',
    textKey: 'q_spi_hope',
    whyKey: 'why_q_spi_hope',
    module: QuestionModule.spiritual,
    condition: QuestionCondition(dependentQuestionId: 'pref_spiritual', requiredValues: [1]),
    basePriority: 60,
    options: _standardOptions(),
  ),
  Question(
    id: 'spi_2',
    textKey: 'q_spi_gratitude',
    whyKey: 'why_q_spi_gratitude',
    module: QuestionModule.spiritual,
    condition: QuestionCondition(dependentQuestionId: 'pref_spiritual', requiredValues: [1]),
    basePriority: 55,
    options: _standardOptions(),
  ),
  Question(
    id: 'spi_3',
    textKey: 'q_spi_meaning',
    module: QuestionModule.spiritual,
    condition: QuestionCondition(dependentQuestionId: 'pref_spiritual', requiredValues: [1]),
    basePriority: 50,
    options: _standardOptions(),
  ),
  Question(
    id: 'spi_4',
    textKey: 'q_spi_connection',
    module: QuestionModule.spiritual,
    condition: QuestionCondition(dependentQuestionId: 'pref_spiritual', requiredValues: [1]),
    basePriority: 45,
    options: _standardOptions(),
  ),

  // --- SAFETY (Red Flags) ---
  Question(
    id: 'saf_1',
    textKey: 'q_safety_immediate_harm',
    module: QuestionModule.safety,
    isSafety: true,
    basePriority: 200,
    options: [
      Option(textKey: 'opt_no', value: 0),
      Option(textKey: 'opt_yes', value: 4, isSafetyTrigger: true),
    ],
  ),
  Question(
    id: 'saf_2',
    textKey: 'q_safety_hopeless',
    module: QuestionModule.safety,
    isSafety: true,
    basePriority: 210,
    options: [
      Option(textKey: 'opt_no', value: 0),
      Option(textKey: 'opt_yes', value: 4, isSafetyTrigger: true),
    ],
  ),
];

QuestionModule _mapAxisToModule(AssessmentAxis axis) {
  switch (axis) {
    case AssessmentAxis.emotions: return QuestionModule.emotions;
    case AssessmentAxis.stressAnxiety: return QuestionModule.stress;
    case AssessmentAxis.sleepEnergy: return QuestionModule.sleep;
    case AssessmentAxis.productivity: return QuestionModule.productivity;
    case AssessmentAxis.socialSupport: return QuestionModule.social;
    case AssessmentAxis.angerRegulation: return QuestionModule.angerRegulation;
    case AssessmentAxis.selfConfidence: return QuestionModule.selfConfidence;
    case AssessmentAxis.dailyPressures: return QuestionModule.dailyPressures;
    case AssessmentAxis.lifestyle: return QuestionModule.lifestyle;
    case AssessmentAxis.safety: return QuestionModule.safety;
    case AssessmentAxis.spiritual: return QuestionModule.spiritual;
    default: return QuestionModule.general;
  }
}

List<Option> _standardOptions() {
  return [
    Option(textKey: 'opt_never', value: 0),
    Option(textKey: 'opt_sometimes', value: 1),
    Option(textKey: 'opt_often', value: 2),
    Option(textKey: 'opt_always', value: 3),
  ];
}

// Deprecated - for backward compatibility during transition
final List<Question> neuroSyncQuestions = neuroSyncAdaptiveBank;
