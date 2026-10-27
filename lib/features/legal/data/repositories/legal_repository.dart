import 'package:hive/hive.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import '../../domain/models/legal_models.dart';

class HiveLegalRepository {
  Box<dynamic> get _articlesBox =>
      Hive.box<dynamic>(HiveConfig.legalArticlesBox);
  Box<dynamic> get _assessmentsBox =>
      Hive.box<dynamic>(HiveConfig.legalAssessmentsBox);
  Box<dynamic> get _consentBox => Hive.box<dynamic>(HiveConfig.consentBox);
  Box<dynamic> get _reportsBox => Hive.box<dynamic>(HiveConfig.reportsBox);
  Box<SecurityLog> get _logsBox =>
      Hive.box<SecurityLog>(HiveConfig.securityLogsBox);

  // Additional keys for categories, sources, procedures, versions inside _articlesBox
  static const String _categoriesKey = '__legal_categories__';
  static const String _sourcesKey = '__legal_sources__';
  static const String _proceduresKey = '__legal_procedures__';
  static const String _versionsKey = '__legal_versions__';

  Future<void> initSeedDataIfNeeded() async {
    try {
      final existingCategories = getCategories();
      if (existingCategories.isEmpty) {
        await _seedInitialLegalData();
      }
    } catch (e) {
      logger.e('Failed to initialize legal seed data: $e');
    }
  }

  // CATEGORIES
  List<LegalCategory> getCategories() {
    final raw = _articlesBox.get(_categoriesKey);
    if (raw is! List) return [];
    return raw
        .map((e) => LegalCategory.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveCategory(
    LegalCategory category, {
    required String adminUser,
  }) async {
    final categories = getCategories();
    categories.removeWhere((c) => c.id == category.id);
    categories.add(category);
    await _articlesBox.put(
      _categoriesKey,
      categories.map((c) => c.toJson()).toList(),
    );
    await _logAudit(
      'LEGAL_CATEGORY_UPDATE',
      'Category updated/created: ${category.code}',
      adminUser,
    );
  }

  // ARTICLES
  List<LegalArticle> getArticles({bool includeObsolete = false}) {
    final list = <LegalArticle>[];
    for (final key in _articlesBox.keys) {
      if (key is String && !key.startsWith('__')) {
        final raw = _articlesBox.get(key);
        if (raw is Map) {
          final article = LegalArticle.fromJson(Map<String, dynamic>.from(raw));
          if (includeObsolete ||
              article.statutValidation != ValidationStatus.obsolete) {
            list.add(article);
          }
        }
      }
    }
    return list;
  }

  LegalArticle? getArticleById(String id) {
    final raw = _articlesBox.get(id);
    if (raw is! Map) return null;
    return LegalArticle.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> saveArticle(
    LegalArticle article, {
    required String adminUser,
  }) async {
    await _articlesBox.put(article.id, article.toJson());
    await _logAudit(
      'LEGAL_ARTICLE_SAVE',
      'Article saved: ${article.reference} (${article.titre})',
      adminUser,
    );
  }

  Future<void> deleteArticle(String id, {required String adminUser}) async {
    final article = getArticleById(id);
    await _articlesBox.delete(id);
    await _logAudit(
      'LEGAL_ARTICLE_DELETE',
      'Article deleted: $id (${article?.reference ?? ''})',
      adminUser,
    );
  }

  // SOURCES
  List<LegalSource> getSources() {
    final raw = _articlesBox.get(_sourcesKey);
    if (raw is! List) return [];
    return raw
        .map((e) => LegalSource.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveSource(
    LegalSource source, {
    required String adminUser,
  }) async {
    final list = getSources();
    list.removeWhere((s) => s.id == source.id);
    list.add(source);
    await _articlesBox.put(_sourcesKey, list.map((s) => s.toJson()).toList());
    await _logAudit(
      'LEGAL_SOURCE_SAVE',
      'Source saved: ${source.name}',
      adminUser,
    );
  }

  // PROCEDURES
  List<LegalProcedure> getProcedures() {
    final raw = _articlesBox.get(_proceduresKey);
    if (raw is! List) return [];
    return raw
        .map(
          (e) => LegalProcedure.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
  }

  Future<void> saveProcedure(
    LegalProcedure procedure, {
    required String adminUser,
  }) async {
    final list = getProcedures();
    list.removeWhere((p) => p.id == procedure.id);
    list.add(procedure);
    await _articlesBox.put(
      _proceduresKey,
      list.map((p) => p.toJson()).toList(),
    );
    await _logAudit(
      'LEGAL_PROCEDURE_SAVE',
      'Procedure saved: ${procedure.titleFr}',
      adminUser,
    );
  }

  // VERSIONS
  List<LegalVersion> getVersions() {
    final raw = _articlesBox.get(_versionsKey);
    if (raw is! List) return [];
    return raw
        .map((e) => LegalVersion.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> saveVersion(
    LegalVersion version, {
    required String adminUser,
  }) async {
    final list = getVersions();
    list.removeWhere((v) => v.id == version.id);
    list.add(version);
    await _articlesBox.put(_versionsKey, list.map((v) => v.toJson()).toList());
    await _logAudit(
      'LEGAL_VERSION_SAVE',
      'Version saved: ${version.versionCode}',
      adminUser,
    );
  }

  // ASSESSMENTS
  Future<void> saveAssessment(LegalAssessment assessment) async {
    await _assessmentsBox.put(assessment.id, assessment.toJson());
    await _logAudit(
      'LEGAL_ASSESSMENT_CREATE',
      'Assessment saved: ${assessment.id} (Guest: ${assessment.isGuest})',
      assessment.userId ?? 'guest',
    );
  }

  LegalAssessment? getAssessment(String id) {
    final raw = _assessmentsBox.get(id);
    if (raw is! Map) return null;
    return LegalAssessment.fromJson(Map<String, dynamic>.from(raw));
  }

  List<LegalAssessment> getAssessmentsForUser(String? userId) {
    final list = <LegalAssessment>[];
    for (final raw in _assessmentsBox.values) {
      if (raw is Map) {
        final a = LegalAssessment.fromJson(Map<String, dynamic>.from(raw));
        if (userId == null || a.userId == userId || a.isGuest) {
          list.add(a);
        }
      }
    }
    return list;
  }

  // CONSENT
  Future<void> saveConsent(ConsentRecord consent) async {
    await _consentBox.put(consent.id, consent.toJson());
    await _logAudit(
      'CONSENT_GRANTED',
      'Consent granted for institution: ${consent.recipientInstitution}',
      consent.userId ?? 'guest',
    );
  }

  ConsentRecord? getConsent(String id) {
    final raw = _consentBox.get(id);
    if (raw is! Map) return null;
    return ConsentRecord.fromJson(Map<String, dynamic>.from(raw));
  }

  List<ConsentRecord> getConsentsForUser(String? userId) {
    final list = <ConsentRecord>[];
    for (final raw in _consentBox.values) {
      if (raw is Map) {
        final c = ConsentRecord.fromJson(Map<String, dynamic>.from(raw));
        if (userId == null || c.userId == userId) {
          list.add(c);
        }
      }
    }
    return list;
  }

  // REPORTS
  Future<void> saveReportDraft(ReportDraft draft) async {
    await _reportsBox.put(draft.id, draft.toJson());
    await _logAudit(
      'REPORT_DRAFT_SAVE',
      'Report draft updated status: ${draft.status.name}',
      draft.userId ?? 'guest',
    );
  }

  ReportDraft? getReportDraft(String id) {
    final raw = _reportsBox.get(id);
    if (raw is! Map) return null;
    return ReportDraft.fromJson(Map<String, dynamic>.from(raw));
  }

  List<ReportDraft> getReportDraftsForUser(String? userId) {
    final list = <ReportDraft>[];
    for (final raw in _reportsBox.values) {
      if (raw is Map) {
        final r = ReportDraft.fromJson(Map<String, dynamic>.from(raw));
        if (userId == null || r.userId == userId) {
          list.add(r);
        }
      }
    }
    return list;
  }

  // PRIVATE AUDIT LOG
  Future<void> _logAudit(String action, String details, String userId) async {
    try {
      final log = SecurityLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        actorId: userId,
        actorRole: 'user',
        action: action,
        timestamp: DateTime.now(),
        status: 'success',
        metadata: {'details': details, 'ipAddress': 'local_offline'},
      );
      await _logsBox.add(log);
    } catch (e) {
      logger.w('Could not append audit log: $e');
    }
  }

  // Seed local legal references. Institutional publication requires human review.
  Future<void> _seedInitialLegalData() async {
    final sources = [
      const LegalSource(
        id: 'src_code_penal',
        name: 'Code Pénal Algérien',
        officialReference:
            'Ordonnance n° 66-156 modifiée et complétée (notamment par Loi 15-19)',
        url: 'https://www.joradp.dz',
        jurisdiction: 'DZ',
      ),
      const LegalSource(
        id: 'src_loi_enfant',
        name: 'Loi relative à la protection de l\'enfant',
        officialReference: 'Loi n° 15-12 du 15 juillet 2015',
        url: 'https://www.joradp.dz',
        jurisdiction: 'DZ',
      ),
      const LegalSource(
        id: 'src_loi_femme',
        name: 'Loi de protection des femmes contre la violence',
        officialReference: 'Loi n° 15-19 du 30 décembre 2015',
        url: 'https://www.joradp.dz',
        jurisdiction: 'DZ',
      ),
      const LegalSource(
        id: 'src_loi_donnees',
        name: 'Protection des données à caractère personnel',
        officialReference: 'Loi n° 18-07 du 10 juin 2018',
        url: 'https://www.joradp.dz/FTP/JO-FRANCAIS/2018/F2018034.pdf',
        jurisdiction: 'DZ',
      ),
      const LegalSource(
        id: 'src_loi_sante',
        name: 'Loi relative à la santé',
        officialReference: 'Loi n° 18-11 du 2 juillet 2018',
        url: 'https://www.joradp.dz/FTP/JO-FRANCAIS/2018/F2018046.pdf',
        jurisdiction: 'DZ',
      ),
    ];
    await _articlesBox.put(
      _sourcesKey,
      sources.map((s) => s.toJson()).toList(),
    );

    final versions = [
      LegalVersion(
        id: 'ver_2026_09',
        versionCode: 'v2026.09-DZ-pilote-local',
        releaseDate: DateTime(2026, 9, 3),
        changelog:
            'Références officielles ajoutées. Toute mise en service institutionnelle exige une revue juridique humaine des contenus et procédures.',
        isActive: true,
      ),
    ];
    await _articlesBox.put(
      _versionsKey,
      versions.map((v) => v.toJson()).toList(),
    );

    final categories = [
      const LegalCategory(
        id: 'cat_violence_physique',
        code: 'PHYSICAL_VIOLENCE',
        titleFr: 'Atteintes à l\'intégrité physique (Coups & Blessures)',
        titleAr: 'الاعتداء على السلامة الجسدية (الضرب والجرح)',
        descriptionFr:
            'Violences physiques volotaires, agressions, contraintes physiques.',
        descriptionAr: 'العنف الجسدي العمدي، الاعتداءات، والإكراه البدني.',
      ),
      const LegalCategory(
        id: 'cat_violence_conjugale',
        code: 'DOMESTIC_VIOLENCE',
        titleFr: 'Violences au sein du couple ou de la famille',
        titleAr: 'العنف الأسري والزوجي',
        descriptionFr:
            'Violences exercées par le conjoint, ex-conjoint ou ascendants/descendants.',
        descriptionAr: 'العنف الممارس من طرف الزوج، الزوج السابق، أو الأقارب.',
      ),
      const LegalCategory(
        id: 'cat_harcelement_moral',
        code: 'MORAL_HARASSMENT',
        titleFr: 'Harcèlement moral et contrainte psychologique',
        titleAr: 'المضايقة النفسية والتنكيل المعنوي',
        descriptionFr:
            'Propos répétés, comportements dégradants ou harcèlement au travail/foyer.',
        descriptionAr:
            'التصرفات المتكررة أو الكلام المسيء المؤدي لتدهور الحالة النفسية.',
      ),
      const LegalCategory(
        id: 'cat_cyber_violence',
        code: 'CYBER_VIOLENCE',
        titleFr: 'Cyber-violences, chantage & harcèlement numérique',
        titleAr: 'العنف الرقمي والابتزاز الإلكتروني',
        descriptionFr:
            'Publication non consentie d\'images, chantage en ligne, cyber-harcèlement.',
        descriptionAr:
            'نشر الصور دون موافقة، الابتزاز عبر الإنترنت، والمضايقة الرقمية.',
      ),
      const LegalCategory(
        id: 'cat_menace_injure',
        code: 'THREAT_INSULT',
        titleFr: 'Menaces de violence et injures publiques/privées',
        titleAr: 'التهديد والسب والشتم',
        descriptionFr:
            'Menaces d\'atteinte aux personnes, intimidation ou diffamation.',
        descriptionAr: 'التهديد بالاعتداء، الترهيب أو القذف والسب.',
      ),
      const LegalCategory(
        id: 'cat_protection_mineur',
        code: 'CHILD_PROTECTION',
        titleFr: 'Situation de danger ou maltraitance d\'un mineur',
        titleAr: 'حماية الطفل المعرض للخطر أو الإساءة',
        descriptionFr:
            'Négligence grave, maltraitance ou mise en danger d\'un enfant.',
        descriptionAr: 'الإهمال الجسيم، التعدي أو تعريض القاصر للخطر.',
      ),
    ];
    await _articlesBox.put(
      _categoriesKey,
      categories.map((c) => c.toJson()).toList(),
    );

    final procedures = [
      const LegalProcedure(
        id: 'proc_depot_plainte',
        titleFr: 'Dépôt de plainte officielle',
        titleAr: 'إيداع شكوى رسمية',
        descriptionFr:
            'Saisine du Procureur de la République ou dépôt au Commissariat/Gendarmerie.',
        descriptionAr:
            'تقديم شكوى أمام وكيل الجمهورية أو لدى مصالح الشرطة/الدرك الوطني.',
        competentAuthorities: [
          'Procureur de la République près le tribunal du lieu des faits',
          'Brigade de Gendarmerie Nationale',
          'Commissariat de Police de la Sûreté Urbaine',
        ],
        stepsFr: [
          'Rédiger la déclaration décrivant les faits (date, lieu, témoignages).',
          'Joindre les preuves disponibles (certificat médical, messages, enregistrements).',
          'Déposer la plainte directement ou par voie postale recommandée au tribunal.',
          'Conserver le récépissé de dépôt ou le numéro du procès-verbal.',
        ],
        stepsAr: [
          'تحرير بيان يوضح الوقائع (التاريخ، المكان، الشهود).',
          'إرفاق الأدلة المتاحة (شهادة طبية، رسائل نصية، تسجيلات).',
          'إيداع الشكوى مباشرة أو عبر البريد لدى المحكمة.',
          'الاحتفاظ ببتسلّم رصيد الإيداع أو رقم المحضر.',
        ],
        requiredEvidenceFr: [
          'Certificat médical constatant l\'incapacité (ITT)',
          'Captures d\'écran de messages / e-mails',
          'Témoignages écrits avec pièce d\'identité',
        ],
        isEmergency: false,
        helplines: ['1548', '1055'],
      ),
      const LegalProcedure(
        id: 'proc_urgence_signalement',
        titleFr: 'Signalement d\'urgence et mise en sécurité',
        titleAr: 'الإبلاغ الفوري وتوفير الحماية العاجلة',
        descriptionFr:
            'Intervention immédiate des forces de l\'ordre en cas de danger imminent.',
        descriptionAr: 'تدخل فوري لمصالح الأمن في حالة الخطر الداهم.',
        competentAuthorities: [
          'Police Nationale (1548)',
          'Gendarmerie Nationale (1055)',
          'Numéro Vert Protection Enfance (111)',
          'SAMU Social / Urgences Médicales (14)',
        ],
        stepsFr: [
          'Appeler les numéros d\'urgence gratuits (1548 / 1055).',
          'Indiquer l\'adresse exacte et la nature du danger immédiat.',
          'Se mettre à l\'abri dans un lieu sûr si possible.',
        ],
        stepsAr: [
          'الاتصال بالأرقام المجانية للتطوير الأمني (1548 / 1055).',
          'تحديد العنوان بدقة ونوع الخطر الفوري.',
          'الاحتماء في مكان آمن إن أمكن.',
        ],
        requiredEvidenceFr: ['Constat sur place par la police/gendarmerie'],
        isEmergency: true,
        helplines: ['1548', '1055', '111', '14'],
      ),
      const LegalProcedure(
        id: 'proc_assistance_juridique',
        titleFr: 'Demande d\'Assistance Juridictionnelle & Conseil',
        titleAr: 'طلب المساعدة القضائية والاستشارة',
        descriptionFr:
            'Obtention d\'un avocat désigné pour accompagner la victime.',
        descriptionAr: 'تعيين محامٍ لمرافقة الضحية والدفاع عن حقوقها.',
        competentAuthorities: [
          'Bureau d\'Assistance Juridictionnelle près le Tribunal',
          'Maison du Droit / Barreau des Avocats',
          'Associations agréées d\'aide aux victimes',
        ],
        stepsFr: [
          'Remplir le formulaire d\'assistance juridictionnelle au greffe du tribunal.',
          'Fournir les justificatifs de situation et la pièce d\'identité.',
          'Rencontrer l\'avocat désigné pour préparer le dossier.',
        ],
        stepsAr: [
          'ملء نموذج المساعدة القضائية كتابةً بالمحكمة.',
          'تقديم الوثائق الثبوتية والهوية.',
          'الاجتماع بالمحامي المنسق لإعداد الملف.',
        ],
        requiredEvidenceFr: ['Formulaire d\'assistance', 'Pièce d\'identité'],
        isEmergency: false,
        helplines: ['1548'],
      ),
    ];
    await _articlesBox.put(
      _proceduresKey,
      procedures.map((p) => p.toJson()).toList(),
    );

    final articles = [
      LegalArticle(
        id: 'art_264_cp',
        titre: 'Coups et blessures volontaires',
        titreAr: 'الضرب والجرح العمدي',
        reference: 'Article 264 du Code Pénal Algérien',
        referenceAr: 'المادة 264 من قانون العقوبات الجزائري',
        texte:
            'Quiconque, volontairement, fait des coups ou porte des blessures à autrui ou commet toute autre violence ou voie de fait... est puni d\'un emprisonnement et d\'une amende selon la gravité de la lésion.',
        texteAr:
            'كل من أحدث عمدا جروحا للغير أو ضربه أو ارتكب أي عمل آخر من أعمال العنف أو التعدي... يعاقب بالحبس وبغرامة حسب خطورة الإصابة.',
        explicationSimplifiee:
            'La loi punit sévèrement tout acte de violence physique ayant entraîné des blessures, une incapacité temporaire de travail (ITT) ou des ecchymoses.',
        explicationSimplifieeAr:
            'يعاقب القانون بصرامة على كل فعل من أفعال العنف الجسدي الذي يؤدي إلى جروح أو عجز مؤقت عن العمل أو كدمات.',
        categoriesConcernees: [
          'cat_violence_physique',
          'cat_violence_conjugale',
        ],
        proceduresAssociees: ['proc_depot_plainte', 'proc_urgence_signalement'],
        sourceOfficielle: 'src_code_penal',
        dateValidite: DateTime(2026, 1, 1),
        version: 'v2026.09-DZ-pilote-local',
        statutValidation: ValidationStatus.validated,
        validatedBy:
            'Référence officielle — revue juridique institutionnelle requise',
        validatedAt: DateTime(2026, 1, 10),
      ),
      LegalArticle(
        id: 'art_266_bis_cp',
        titre: 'Violences et agressions au sein du couple',
        titreAr: 'أعمال العنف والاعتداءات داخل الأسرة',
        reference: 'Article 266 bis du Code Pénal (Loi n° 15-19)',
        referenceAr: 'المادة 266 مكرر من قانون العقوبات (قانون رقم 15-19)',
        texte:
            'Quiconque porte volontairement des coups ou commet des violences contre son conjoint... est puni d\'emprisonnement de 2 ans à 5 ans. Si la violence entraîne une incapacité permanente, la peine est la réclusion.',
        texteAr:
            'يعاقب بالحبس من سنتين (2) إلى خمس (5) سنوات كل من أحدث عمدا جروحا أو ضربا بزوجه... وإذا أدى العنف إلى عجز دائم تكون العقوبة السجن.',
        explicationSimplifiee:
            'La loi prévoit des peines renforcées lorsque la violence physique ou psychologique est commise au sein du mariage ou par l\'époux.',
        explicationSimplifieeAr:
            'ينص القانون على عقوبات مشددة عندما يرتكب العنف الجسدي أو النفسي داخل إطار الزواج أو من طرف الزوج.',
        categoriesConcernees: [
          'cat_violence_conjugale',
          'cat_violence_physique',
        ],
        proceduresAssociees: [
          'proc_depot_plainte',
          'proc_assistance_juridique',
        ],
        sourceOfficielle: 'src_loi_femme',
        dateValidite: DateTime(2026, 1, 1),
        version: 'v2026.09-DZ-pilote-local',
        statutValidation: ValidationStatus.validated,
        validatedBy:
            'Référence officielle — revue juridique institutionnelle requise',
        validatedAt: DateTime(2026, 1, 12),
      ),
      LegalArticle(
        id: 'art_333_bis_cp',
        titre: 'Harcèlement et atteinte à la vie privée par voie numérique',
        titreAr: 'التحرش والمساس بالحياة الخاصة عبر الوسائل الرقمية',
        reference: 'Article 333 bis 2 du Code Pénal',
        referenceAr: 'المادة 333 مكرر 2 من قانون العقوبات',
        texte:
            'Est puni quiconque porte atteinte à la vie privée d\'autrui en captant, enregistrant ou diffusant des images, paroles ou documents sans le consentement de la personne concernée.',
        texteAr:
            'يعاقب كل من مساسا بالحياة الخاصة للغير بالتقاط أو تسجيل أو نقل كلمات أو صور أو وثائق دون رضا صاحبها.',
        explicationSimplifiee:
            'Publier des photos/vidéos sans accord ou utiliser des messages pour faire du chantage en ligne est un délit réprimé par la loi.',
        explicationSimplifieeAr:
            'نشر صور أو فيديوهات دون موافقة أو استخدام الرسائل للابتزاز عبر الإنترنت هو جنحة يعاقب عليها القانون.',
        categoriesConcernees: ['cat_cyber_violence', 'cat_harcelement_moral'],
        proceduresAssociees: ['proc_depot_plainte'],
        sourceOfficielle: 'src_code_penal',
        dateValidite: DateTime(2026, 1, 1),
        version: 'v2026.09-DZ-pilote-local',
        statutValidation: ValidationStatus.validated,
        validatedBy:
            'Référence officielle — revue juridique institutionnelle requise',
        validatedAt: DateTime(2026, 1, 15),
      ),
      LegalArticle(
        id: 'art_287_cp',
        titre: 'Menaces sous condition ou intimidations',
        titreAr: 'التهديد بشروط أو الترهيب',
        reference: 'Article 287 du Code Pénal Algérien',
        referenceAr: 'المادة 287 من قانون العقوبات الجزائري',
        texte:
            'Quiconque menace autrui d\'une atteinte aux personnes ou aux biens par écrit, image ou message... est puni d\'un emprisonnement et d\'amende.',
        texteAr:
            'كل من هدد غيره بارتكاب اعتداء على الأشخاص أو الأموال كتابة أو بالصور أو بالرسائل... يعاقب بالحبس وبالغرامة.',
        explicationSimplifiee:
            'Envoyer des menaces (par écrit, SMS ou orales) de causer du tort ou de faire souffrir est puni par la justice.',
        explicationSimplifieeAr:
            'إرسال تهديدات (كتابية أو عبر الرسائل القصيرة أو شفهية) بإلحاق ضرر أو تسبب في معاناة يعاقب عليه القضاء.',
        categoriesConcernees: ['cat_menace_injure', 'cat_cyber_violence'],
        proceduresAssociees: ['proc_depot_plainte'],
        sourceOfficielle: 'src_code_penal',
        dateValidite: DateTime(2026, 1, 1),
        version: 'v2026.09-DZ-pilote-local',
        statutValidation: ValidationStatus.validated,
        validatedBy:
            'Référence officielle — revue juridique institutionnelle requise',
        validatedAt: DateTime(2026, 1, 15),
      ),
      LegalArticle(
        id: 'art_14_loi_enfant',
        titre: 'Protection du mineur en danger',
        titreAr: 'حماية القاصر المعرض للخطر',
        reference:
            'Article 14 de la Loi n° 15-12 relative à la protection de l\'enfant',
        referenceAr: 'المادة 14 من قانون رقم 15-12 المتعلق بحماية الطفل',
        texte:
            'L\'enfant est considéré en danger lorsque sa santé, sa sécurité, sa moralité ou son éducation sont menacées ou compromises, notamment par la maltraitance physique ou psychologique.',
        texteAr:
            'يعتبر الطفل في خطر عندما تكون صحته أو سلامته أو أخلاقه أو تربيته مهددة أو معرضة للخطر، لا سيما بسبب سوء المعاملة الجسدية أو المعنوية.',
        explicationSimplifiee:
            'Tout enfant victime de négligence ou de violence a droit à une protection immédiate de la part du juge des mineurs et des services sociaux.',
        explicationSimplifieeAr:
            'لكل طفل ضحية إهمال أو عنف الحق في حماية فورية من طرف قاضي الأحداث والمصالح الاجتماعية.',
        categoriesConcernees: ['cat_protection_mineur'],
        proceduresAssociees: ['proc_urgence_signalement', 'proc_depot_plainte'],
        sourceOfficielle: 'src_loi_enfant',
        dateValidite: DateTime(2026, 1, 1),
        version: 'v2026.09-DZ-pilote-local',
        statutValidation: ValidationStatus.validated,
        validatedBy:
            'Référence officielle — revue juridique institutionnelle requise',
        validatedAt: DateTime(2026, 1, 18),
      ),
      LegalArticle(
        id: 'art_7_loi_18_07',
        titre: 'Accord préalable pour le traitement des données personnelles',
        titreAr: 'الموافقة المسبقة لمعالجة البيانات الشخصية',
        reference: 'Article 7 de la Loi n° 18-07 du 10 juin 2018',
        referenceAr: 'المادة 7 من قانون رقم 18-07 مؤرخ في 10 يونيو 2018',
        texte:
            'Le traitement de données personnelles requiert en principe le consentement exprès de la personne concernée, sous réserve des exceptions prévues par la loi.',
        texteAr:
            'تتطلب معالجة المعطيات ذات الطابع الشخصي، كأصل عام، الحصول على الموافقة الصريحة للشخص المعني، مع مراعاة الاستثناءات المنصوص عليها في القانون.',
        explicationSimplifiee:
            'Dans cette version locale, les réponses sensibles ne sont conservées qu’après une acceptation explicite. Elles ne sont transmises à aucun tiers par l’application.',
        explicationSimplifieeAr:
            'في هذا الإصدار المحلي، لا تُحفظ الإجابات الحساسة إلا بعد موافقة صريحة. ولا تُنقل إلى أي طرف ثالث عبر التطبيق.',
        categoriesConcernees: const [],
        proceduresAssociees: const [],
        sourceOfficielle: 'src_loi_donnees',
        dateValidite: DateTime(2018, 6, 10),
        version: 'v2026.09-DZ-pilote-local',
        statutValidation: ValidationStatus.validated,
        validatedBy:
            'Référence officielle — revue juridique institutionnelle requise',
        validatedAt: DateTime(2026, 9, 3),
      ),
    ];

    for (final article in articles) {
      await _articlesBox.put(article.id, article.toJson());
    }

    logger.i(
      'Successfully seeded initial validated legal knowledge base into Hive.',
    );
  }
}
