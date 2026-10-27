import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/protection/domain/engines/adaptive_protection_question_engine.dart';
import 'package:projetmascara/features/protection/domain/engines/initial_guidance_engine.dart';
import 'package:projetmascara/features/protection/domain/engines/orientation_engine.dart';
import 'package:projetmascara/features/protection/domain/engines/red_flag_engine.dart';
import 'package:projetmascara/features/protection/domain/engines/violence_risk_engine.dart';
import 'package:projetmascara/features/protection/domain/models/protection_models.dart';

void main() {
  group('Violence Risk & Protection Engine Tests', () {
    const redFlagEngine = RedFlagEngine();
    const initialGuidanceEngine = InitialGuidanceEngine();
    const riskEngine = ViolenceRiskEngine(
      redFlagEngine: redFlagEngine,
      initialGuidanceEngine: initialGuidanceEngine,
    );
    const adaptiveEngine = AdaptiveProtectionQuestionEngine(
      redFlagEngine: redFlagEngine,
    );
    const orientationEngine = ProtectionOrientationEngine();

    test('1. Category Registry covers all required categories', () {
      final categories = ViolenceCategoryRegistry.all;
      expect(categories.isNotEmpty, true);
      expect(categories.any((c) => c.id == ViolenceType.verbal), true);
      expect(
        categories.any((c) => c.id == ViolenceType.threatIntimidation),
        true,
      );
      expect(categories.any((c) => c.id == ViolenceType.discrimination), true);
      expect(categories.any((c) => c.id == ViolenceType.family), true);
      expect(categories.any((c) => c.id == ViolenceType.school), true);
      expect(categories.any((c) => c.id == ViolenceType.workplace), true);
    });

    test('2. RedFlagEngine correctly detects critical danger indicators', () {
      final answers = {
        'currentDanger': AnswerValue.yes,
        'repeated': AnswerValue.yes,
      };

      final activeRedFlags = redFlagEngine.evaluate(answers);
      expect(activeRedFlags.length, 1);
      expect(activeRedFlags.first.code, 'currentDanger');
      expect(redFlagEngine.hasCriticalRedFlag(answers), true);
    });

    test(
      '3. AdaptiveProtectionQuestionEngine stops when critical Red Flag is detected',
      () {
        final answersWithRedFlag = {'currentDanger': AnswerValue.yes};

        final nextQuestion = adaptiveEngine.next(
          categories: {ViolenceType.physical},
          answers: answersWithRedFlag,
        );

        expect(nextQuestion, null); // Interrupted by Red Flag
      },
    );

    test(
      '4. Comprehensive assessment evaluation produces LEVEL_4 for Red Flag scenario',
      () {
        final assessment = ViolenceAssessment(
          id: 'test-assessment-1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          categories: [ViolenceType.physical, ViolenceType.domestic],
          answers: {
            'currentDanger': AnswerValue.yes,
            'repeated': AnswerValue.yes,
          },
          frequency: 'escalating',
          contextType: 'family',
          relationshipToAuthor: 'partner',
          status: 'interruptedByRedFlag',
          isAnonymous: true,
        );

        final result = riskEngine.evaluateAssessment(assessment, wilaya: '31');

        expect(result.severity, ViolenceSeverity.level4GravePrioriteSecurite);
        expect(result.level, RiskLevel.immediate);
        expect(result.detectedRedFlags.isNotEmpty, true);
        expect(result.orientation.wilaya, '31');
        expect(result.disclaimer.contains('Évaluation indicative'), true);
        expect(
          result.disclaimer.contains(
            'Ne constitue pas un diagnostic définitif',
          ),
          true,
        );
      },
    );

    test(
      '5. Non-critical assessment produces appropriate LEVEL_1 or LEVEL_2 severity',
      () {
        final assessment = ViolenceAssessment(
          id: 'test-assessment-2',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          categories: [ViolenceType.verbal],
          answers: {
            'currentDanger': AnswerValue.no,
            'seriousThreat': AnswerValue.no,
            'repeated': AnswerValue.no,
          },
          frequency: 'isolated',
          status: 'completed',
          isAnonymous: true,
        );

        final result = riskEngine.evaluateAssessment(assessment);

        expect(result.severity, ViolenceSeverity.level1Preoccupante);
        expect(result.level, RiskLevel.attention);
        expect(result.detectedRedFlags.isEmpty, true);
        expect(result.initialGuidance.isNotEmpty, true);
      },
    );

    test(
      '6. ProtectionOrientationEngine generates proper specialty recommendations',
      () {
        final orientation = orientationEngine.generateOrientation(
          severity: ViolenceSeverity.level3Accompagnement,
          categories: {ViolenceType.childAbuse},
          wilaya: '06',
        );

        expect(orientation.requiredSpecialty, 'Spécialiste de l’enfance');
        expect(orientation.urgencyLevel, 'LEVEL_3');
        expect(orientation.wilaya, '06');
      },
    );

    test('7. Backward compatibility assess() method remains functional', () {
      final legacyAssessment = riskEngine.assess(
        id: 'legacy-1',
        reportId: 'report-1',
        answers: {'currentDanger': AnswerValue.yes},
      );

      expect(legacyAssessment.level, RiskLevel.immediate);
      expect(legacyAssessment.emergencyFlags.contains('currentDanger'), true);
    });
  });
}
