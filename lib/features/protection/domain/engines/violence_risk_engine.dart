import 'package:uuid/uuid.dart';
import '../models/protection_models.dart';
import 'red_flag_engine.dart';
import 'initial_guidance_engine.dart';

class RiskRules {
  final String version;
  final Set<String> criticalFactors;
  final Map<String, int> scoringRules;
  final Map<RiskLevel, int> thresholds;
  final DateTime updatedAt;

  const RiskRules({
    required this.version,
    required this.criticalFactors,
    required this.scoringRules,
    required this.thresholds,
    required this.updatedAt,
  });

  static RiskRules current() => RiskRules(
    version: 'neurosync-violence-risk-2.0',
    criticalFactors: {
      'currentDanger',
      'seriousThreat',
      'dangerousMeans',
      'seriousInjury',
      'authorNearbyNoShelter',
      'dependentAtRisk',
      'abductionAttempt',
      'confinement',
      'directRecentThreat',
      'lockedIn',
      'childAtSeriousRisk',
    },
    scoringRules: const {
      'nonCritical': 1,
      'repeated': 2,
      'escalation': 3,
      'isolation': 2,
      'control': 2,
      'childExposed': 3,
      'seriousThreat': 4,
      'frequency_repeated': 2,
      'frequency_continuous': 3,
      'duration_long': 2,
      'vulnerability': 2,
      'threats': 3,
      'digitalBlackmail': 2,
      'digitalSharing': 3,
    },
    thresholds: const {
      RiskLevel.attention: 1,
      RiskLevel.moderate: 3,
      RiskLevel.high: 6,
    },
    updatedAt: DateTime.utc(2026, 8, 27),
  );
}

class ViolenceRiskEngine {
  final RedFlagEngine redFlagEngine;
  final InitialGuidanceEngine initialGuidanceEngine;

  const ViolenceRiskEngine({
    this.redFlagEngine = const RedFlagEngine(),
    this.initialGuidanceEngine = const InitialGuidanceEngine(),
  });

  /// Evaluates a full ViolenceAssessment and produces a structured ViolenceAssessmentResult.
  ViolenceAssessmentResult evaluateAssessment(
    ViolenceAssessment assessment, {
    String wilaya = '01',
  }) {
    final answers = assessment.answers;
    final activeRedFlags = redFlagEngine.evaluate(answers);
    final hasCriticalRedFlag = activeRedFlags.any(
      (r) => r.severity == ViolenceSeverity.level4GravePrioriteSecurite,
    );

    // Factors analysis
    final factors = <String>[];
    for (final entry in answers.entries) {
      if (entry.value == AnswerValue.yes) {
        factors.add(entry.key);
      }
    }

    if (assessment.frequency != null && assessment.frequency != 'isolated') {
      factors.add('frequency_${assessment.frequency}');
    }
    if (assessment.duration != null) {
      factors.add('duration_${assessment.duration}');
    }
    if (assessment.contextType != null) {
      factors.add('context_${assessment.contextType}');
    }
    if (assessment.relationshipToAuthor != null) {
      factors.add('relationship_${assessment.relationshipToAuthor}');
    }

    // Cumulative scoring
    final rules = RiskRules.current();
    int score = 0;
    for (final factor in factors) {
      if (!rules.criticalFactors.contains(factor)) {
        score +=
            rules.scoringRules[factor] ?? rules.scoringRules['nonCritical']!;
      }
    }

    // Severity determination
    ViolenceSeverity severity;
    if (hasCriticalRedFlag || answers['currentDanger'] == AnswerValue.yes) {
      severity = ViolenceSeverity.level4GravePrioriteSecurite;
    } else if (activeRedFlags.isNotEmpty || score >= 8) {
      severity = ViolenceSeverity.level4GravePrioriteSecurite;
    } else if (score >= 5) {
      severity = ViolenceSeverity.level3Accompagnement;
    } else if (score >= 2) {
      severity = ViolenceSeverity.level2Vigilance;
    } else {
      severity = ViolenceSeverity.level1Preoccupante;
    }

    final riskLevel = severity.toRiskLevel();

    // Guidance generation via InitialGuidanceEngine
    final guidanceItems = initialGuidanceEngine.generateGuidance(
      severity: severity,
      categories: assessment.categories,
      hasRedFlag: activeRedFlags.isNotEmpty,
    );
    final initialGuidanceTextsFr = guidanceItems.map((g) => g.titleFr).toList();
    final initialGuidanceTextsAr = guidanceItems.map((g) => g.titleAr).toList();

    // Orientation details (Specialty & urgency mapping)
    String requiredSpecialty = 'psychologist';
    if (assessment.categories.contains(ViolenceType.childAbuse)) {
      requiredSpecialty = 'child_specialist';
    } else if (assessment.categories.contains(ViolenceType.family)) {
      requiredSpecialty = 'family_counselor';
    } else if (assessment.categories.contains(ViolenceType.digital)) {
      requiredSpecialty = 'digital_safety_expert';
    }

    final orientation = OrientationDetails(
      requiredSpecialty: requiredSpecialty,
      urgencyLevel: severity.code,
      wilaya: wilaya,
      remoteConsultationPossible: true,
      inPersonPossible: true,
      recommendedSpecialists: const [
        'psychologist',
        'social_worker',
        'legal_counselor',
      ],
    );

    // Legal context preparation
    final legalPrep = LegalContextPreparation(
      hasDocumentedTimeline:
          assessment.frequency != null || assessment.duration != null,
      legalRelevantIndicators: factors
          .where(
            (f) =>
                f.contains('threat') ||
                f.contains('danger') ||
                f.contains('confinement'),
          )
          .toList(),
      recommendationForLegalModule:
          'Ces indicateurs pré-documentent la situation sans constituer un dossier judiciaire formel. Ils serviront au futur module juridique.',
    );

    const disclaimerFr =
        'Évaluation indicative et d’orientation basée sur les informations fournies. Ne constitue pas un diagnostic définitif, une certitude, ni une accusation juridique.';
    const disclaimerAr =
        'تقييم استرشادي وتوجيهي بناءً على المعلومات المقدمة. لا يشكل تشخيصاً نهائياً أو يقيناً أو اتهاماً قانونياً.';

    return ViolenceAssessmentResult(
      id: const Uuid().v4(),
      assessmentId: assessment.id,
      assessedAt: DateTime.now(),
      severity: severity,
      level: riskLevel,
      detectedRedFlags: activeRedFlags,
      influencingFactors: factors,
      identifiedTypes: assessment.categories,
      initialGuidance: initialGuidanceTextsFr,
      initialGuidanceAr: initialGuidanceTextsAr,
      initialGuidanceFr: initialGuidanceTextsFr,
      orientation: orientation,
      legalPreparation: legalPrep,
      disclaimer: disclaimerFr,
      disclaimerAr: disclaimerAr,
      disclaimerFr: disclaimerFr,
    );
  }

  /// Legacy assess method preserved for full backward compatibility
  RiskAssessment assess({
    required String id,
    required String reportId,
    required Map<String, AnswerValue> answers,
    RiskRules? rules,
  }) {
    final activeRules = rules ?? RiskRules.current();
    final critical = activeRules.criticalFactors
        .where((factor) => answers[factor] == AnswerValue.yes)
        .toList();
    final declared = answers.entries
        .where((entry) => entry.value == AnswerValue.yes)
        .map((entry) => entry.key)
        .toList();
    final score = declared.fold<int>(0, (total, factor) {
      if (activeRules.criticalFactors.contains(factor)) return total;
      return total +
          (activeRules.scoringRules[factor] ??
              activeRules.scoringRules['nonCritical']!);
    });

    final level = critical.isNotEmpty
        ? RiskLevel.immediate
        : score >= activeRules.thresholds[RiskLevel.high]!
        ? RiskLevel.high
        : score >= activeRules.thresholds[RiskLevel.moderate]!
        ? RiskLevel.moderate
        : score >= activeRules.thresholds[RiskLevel.attention]!
        ? RiskLevel.attention
        : RiskLevel.none;

    return RiskAssessment(
      id: id,
      reportId: reportId,
      assessedAt: DateTime.now(),
      level: level,
      factors: declared,
      emergencyFlags: critical,
      recommendedActions: level == RiskLevel.immediate
          ? const ['show_emergency_options', 'offer_trusted_contact']
          : const ['offer_verified_resources'],
      engineVersion: activeRules.version,
      assessedBy: 'local-rule-engine',
      humanReviewRequired:
          level == RiskLevel.high || level == RiskLevel.immediate,
    );
  }
}
