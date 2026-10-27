import 'package:flutter_test/flutter_test.dart';
import 'package:projetmascara/features/legal/domain/engines/legal_orientation_engine.dart';
import 'package:projetmascara/features/legal/domain/engines/procedure_recommendation_engine.dart';
import 'package:projetmascara/features/legal/domain/models/legal_models.dart';

void main() {
  group('LegalOrientationEngine & ProcedureRecommendationEngine Tests', () {
    late LegalOrientationEngine engine;
    late List<LegalCategory> categories;
    late List<LegalArticle> articles;
    late List<LegalProcedure> procedures;

    setUp(() {
      engine = LegalOrientationEngine(
        procedureEngine: ProcedureRecommendationEngine(),
      );

      categories = [
        const LegalCategory(
          id: 'cat_violence_physique',
          code: 'PHYSICAL_VIOLENCE',
          titleFr: 'Violences physiques',
          titleAr: 'عنف جسدي',
          descriptionFr: 'Coups et blessures',
          descriptionAr: 'ضرب وجرح',
        ),
        const LegalCategory(
          id: 'cat_violence_conjugale',
          code: 'DOMESTIC_VIOLENCE',
          titleFr: 'Violences conjugales',
          titleAr: 'عنف أسري',
          descriptionFr: 'Violences dans le couple',
          descriptionAr: 'عنف في محيط الزوجية',
        ),
        const LegalCategory(
          id: 'cat_cyber_violence',
          code: 'CYBER_VIOLENCE',
          titleFr: 'Cyber-violences',
          titleAr: 'عنف رقمي',
          descriptionFr: 'Chantage en ligne',
          descriptionAr: 'ابتزاز إلكتروني',
        ),
        const LegalCategory(
          id: 'cat_protection_mineur',
          code: 'CHILD_PROTECTION',
          titleFr: 'Protection de l’enfant',
          titleAr: 'حماية الطفل',
          descriptionFr: 'Situation de danger concernant un mineur',
          descriptionAr: 'وضعية خطر تخص قاصرًا',
        ),
      ];

      articles = [
        LegalArticle(
          id: 'art_264_cp',
          titre: 'Coups et blessures',
          reference: 'Article 264 CP',
          texte: 'Texte officiel article 264',
          explicationSimplifiee: 'Explication simplifiée coups et blessures',
          categoriesConcernees: ['cat_violence_physique'],
          proceduresAssociees: ['proc_depot_plainte'],
          sourceOfficielle: 'src_code_penal',
          dateValidite: DateTime(2026, 1, 1),
          version: 'v2026.1',
          statutValidation: ValidationStatus.validated,
          validatedBy: 'Comité de Validation',
          validatedAt: DateTime(2026, 1, 1),
        ),
        LegalArticle(
          id: 'art_obsolete_test',
          titre: 'Ancien texte abrogé',
          reference: 'Article Obso',
          texte: 'Ancien texte',
          explicationSimplifiee: 'Texte périmé',
          categoriesConcernees: ['cat_violence_physique'],
          proceduresAssociees: ['proc_depot_plainte'],
          sourceOfficielle: 'src_code_penal',
          dateValidite: DateTime(2020, 1, 1),
          version: 'v2020.1',
          statutValidation: ValidationStatus.obsolete,
          validatedBy: 'Ancien Comité',
          validatedAt: DateTime(2020, 1, 1),
        ),
      ];

      procedures = [
        const LegalProcedure(
          id: 'proc_depot_plainte',
          titleFr: 'Dépôt de plainte',
          titleAr: 'إيداع شكوى',
          descriptionFr: 'Procédure standard de dépôt de plainte',
          descriptionAr: 'إجراءات الشكوى',
          competentAuthorities: ['Police', 'Procureur'],
          stepsFr: ['Rédaction', 'Dépôt'],
          stepsAr: ['كتابة', 'إيداع'],
          requiredEvidenceFr: ['Témoignage'],
          isEmergency: false,
        ),
        const LegalProcedure(
          id: 'proc_urgence',
          titleFr: 'Signalement d\'urgence',
          titleAr: 'إبلاغ استعجالي',
          descriptionFr: 'Intervention d\'urgence',
          descriptionAr: 'تدخل عاجل',
          competentAuthorities: ['1548', '1055'],
          stepsFr: ['Appel 1548'],
          stepsAr: ['اتصال 1548'],
          requiredEvidenceFr: [],
          isEmergency: true,
          helplines: ['1548'],
        ),
      ];
    });

    test(
      'Orientation Engine produces indicative non-definitive qualification',
      () {
        final answers = {
          'nature_facts': 'physical_violence',
          'relationship': 'spouse',
          'context': 'family_home',
          'situation_current': 'safe_for_now',
        };

        final result = engine.evaluate(
          userAnswers: answers,
          allCategories: categories,
          allArticles: articles,
          allProcedures: procedures,
        );

        expect(result.candidateCategories, isNotEmpty);
        expect(
          result.qualificationIndicativeFr,
          contains('Qualification indicative'),
        );
        expect(
          result.qualificationIndicativeFr,
          contains('susceptibles de relever'),
        );
        expect(
          result.qualificationIndicativeFr,
          isNot(contains('Vous êtes coupable')),
        );
        expect(
          result.qualificationIndicativeFr,
          isNot(contains('avec certitude')),
        );
      },
    );

    test('Orientation Engine ignores obsolete articles', () {
      final answers = {'nature_facts': 'physical_violence'};

      final result = engine.evaluate(
        userAnswers: answers,
        allCategories: categories,
        allArticles: articles,
        allProcedures: procedures,
      );

      final articleIds = result.applicableArticles.map((a) => a.id).toList();
      expect(articleIds, contains('art_264_cp'));
      expect(articleIds, isNot(contains('art_obsolete_test')));
    });

    test('child-related answers trigger child-protection orientation', () {
      final result = engine.evaluate(
        userAnswers: {
          'person_age_group': 'minor',
          'child_exposure': 'yes',
          'situation_current': 'safe_for_now',
        },
        allCategories: categories,
        allArticles: articles,
        allProcedures: procedures,
      );

      expect(
        result.candidateCategories.map((category) => category.id),
        contains('cat_protection_mineur'),
      );
    });

    test(
      'Orientation Engine handles absence of matching reference gracefully',
      () {
        final answers = {'nature_facts': 'unknown_unmapped_fact'};

        final result = engine.evaluate(
          userAnswers: answers,
          allCategories: categories,
          allArticles: articles,
          allProcedures: procedures,
        );

        expect(result.declaredFactsSummary, isNotEmpty);
        expect(result.disclaimerFr, contains('AVERTISSEMENT JURIDIQUE'));
      },
    );

    test(
      'Procedure Recommendation Engine recommends emergency procedure on immediate danger',
      () {
        final answers = {
          'threats': 'death_threats_weapon',
          'situation_current': 'immediate_danger',
        };

        final recEngine = ProcedureRecommendationEngine();
        final recommended = recEngine.recommendProcedures(
          declaredFacts: answers,
          candidateCategories: categories,
          applicableArticles: articles,
          availableProcedures: procedures,
        );

        expect(recommended.any((p) => p.isEmergency), isTrue);
      },
    );

    test('ConsentRecord creation and checksum trace', () {
      final consent = ConsentRecord(
        id: 'consent_123',
        dataTypes: ['Faits déclarés'],
        purpose: 'Signalement',
        recipientInstitution: 'Procureur',
        transmittedFields: ['Résumé'],
        retentionPeriod: '12 mois',
        actionToBePerformed: 'Transmission sécurisée',
        grantedAt: DateTime.now(),
        consentVersion: '1.0',
        checksum: 'sha256_abcdef123456',
      );

      expect(consent.recipientInstitution, equals('Procureur'));
      expect(consent.checksum, startsWith('sha256_'));
      expect(consent.isRevoked, isFalse);
    });

    test('ReportDraft modification and user confirmation lifecycle', () {
      final draft = ReportDraft(
        id: 'rep_123',
        declaredFacts: {'fait_1': 'Agression verbale'},
        summaryText: 'Résumé initial',
        recipient: const ReportRecipient(
          id: 'rec_1',
          name: 'Commissariat',
          type: 'police',
          contactInfo: 'Sûreté urbaine',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(draft.status, equals(LegalReportStatus.draft));

      final updated = draft.copyWith(
        summaryText: 'Résumé modifié par l\'utilisateur',
        status: LegalReportStatus.userConfirmed,
        consentId: 'consent_123',
      );

      expect(updated.summaryText, equals('Résumé modifié par l\'utilisateur'));
      expect(updated.status, equals(LegalReportStatus.userConfirmed));
      expect(updated.consentId, equals('consent_123'));
    });
  });
}
