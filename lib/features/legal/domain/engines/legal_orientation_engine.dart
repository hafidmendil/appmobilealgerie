import '../models/legal_models.dart';
import 'procedure_recommendation_engine.dart';

class LegalOrientationResult {
  final List<String> declaredFactsSummary;
  final List<String> declaredFactsSummaryAr;
  final List<LegalCategory> candidateCategories;
  final List<LegalArticle> applicableArticles;
  final List<LegalProcedure> recommendedProcedures;
  final String qualificationIndicativeFr;
  final String qualificationIndicativeAr;
  final String disclaimerFr;
  final String disclaimerAr;
  final List<String> competentOrganizations;
  final List<String> competentOrganizationsAr;

  const LegalOrientationResult({
    required this.declaredFactsSummary,
    required this.declaredFactsSummaryAr,
    required this.candidateCategories,
    required this.applicableArticles,
    required this.recommendedProcedures,
    required this.qualificationIndicativeFr,
    required this.qualificationIndicativeAr,
    required this.disclaimerFr,
    required this.disclaimerAr,
    required this.competentOrganizations,
    required this.competentOrganizationsAr,
  });
}

class LegalOrientationEngine {
  final ProcedureRecommendationEngine _procedureEngine;

  LegalOrientationEngine({ProcedureRecommendationEngine? procedureEngine})
    : _procedureEngine = procedureEngine ?? ProcedureRecommendationEngine();

  /// Constants for Legal Disclaimer
  static const String mandatoryDisclaimerFr =
      'AVERTISSEMENT JURIDIQUE : Cet outil est un assistant numérique d\'orientation juridique indicatif. '
      'Il ne constitue pas un conseil juridique personnalisé, une consultation d\'avocat ou un jugement. '
      'Seules les autorités judiciaires compétentes sont habilitées à établir officiellement les faits et les responsabilités.';

  static const String mandatoryDisclaimerAr =
      'تنبيه قانوني: هذه أداة رقمية للتوجيه القانوني الاسترشادي فقط. '
      'ولا تعتبر استشارة قانونية شخصية أو حكماً قضائياً. '
      'السلطات القضائية المختصة هي الوحيدة المخولة رسمياً بإثبات الوقائع وتحديد المسؤوليات.';

  /// Evaluates user answers from the legal questionnaire and produces a structured LegalOrientationResult
  LegalOrientationResult evaluate({
    required Map<String, dynamic> userAnswers,
    required List<LegalCategory> allCategories,
    required List<LegalArticle> allArticles,
    required List<LegalProcedure> allProcedures,
  }) {
    // 1. Fact Extraction & Summarization
    final declaredFactsSummary = _extractFactsSummary(userAnswers);
    final declaredFactsSummaryAr = _extractFactsSummaryAr(userAnswers);

    // 2. Map Answers to Candidate Legal Categories
    final candidateCategories = _identifyCandidateCategories(
      userAnswers,
      allCategories,
    );

    // 3. Find Applicable Legal References (Only validated, active articles)
    final candidateCatIds = candidateCategories.map((c) => c.id).toSet();
    final applicableArticles = allArticles.where((article) {
      if (article.statutValidation != ValidationStatus.validated) return false;
      return article.categoriesConcernees.any(
        (catId) => candidateCatIds.contains(catId),
      );
    }).toList();

    // 4. Procedure Recommendation via ProcedureRecommendationEngine
    final recommendedProcedures = _procedureEngine.recommendProcedures(
      declaredFacts: userAnswers,
      candidateCategories: candidateCategories,
      applicableArticles: applicableArticles,
      availableProcedures: allProcedures,
    );

    // 5. Generate Indicative Legal Qualifications (Strict non-definitive wording)
    final qualificationFr = _buildIndicativeQualificationFr(
      candidateCategories,
    );
    final qualificationAr = _buildIndicativeQualificationAr(
      candidateCategories,
    );

    // 6. Identify Competent Organizations
    final competentOrganizations = _identifyCompetentOrganizations(
      userAnswers,
      recommendedProcedures,
    );
    final competentOrganizationsAr = _identifyCompetentOrganizationsAr(
      userAnswers,
    );

    return LegalOrientationResult(
      declaredFactsSummary: declaredFactsSummary,
      declaredFactsSummaryAr: declaredFactsSummaryAr,
      candidateCategories: candidateCategories,
      applicableArticles: applicableArticles,
      recommendedProcedures: recommendedProcedures,
      qualificationIndicativeFr: qualificationFr,
      qualificationIndicativeAr: qualificationAr,
      disclaimerFr: mandatoryDisclaimerFr,
      disclaimerAr: mandatoryDisclaimerAr,
      competentOrganizations: competentOrganizations,
      competentOrganizationsAr: competentOrganizationsAr,
    );
  }

  List<String> _extractFactsSummary(Map<String, dynamic> answers) {
    final summary = <String>[];

    final nature = answers['nature_facts'];
    if (nature != null && nature.toString().isNotEmpty) {
      summary.add(
        'Nature des faits déclarés : ${_formatFactLabel(nature.toString())}',
      );
    }

    final relationship = answers['relationship'];
    if (relationship != null && relationship.toString().isNotEmpty) {
      summary.add(
        'Lien avec la personne : ${_formatFactLabel(relationship.toString())}',
      );
    }

    final context = answers['context'];
    if (context != null && context.toString().isNotEmpty) {
      summary.add('Cadre / Contexte : ${_formatFactLabel(context.toString())}');
    }

    final frequency = answers['frequency'];
    if (frequency != null && frequency.toString().isNotEmpty) {
      summary.add(
        'Fréquence des événements : ${_formatFactLabel(frequency.toString())}',
      );
    }

    final threats = answers['threats'];
    if (threats != null && threats != 'none') {
      summary.add(
        'Menaces ou intimidations : ${_formatFactLabel(threats.toString())}',
      );
    }

    final digital = answers['digital_context'];
    if (digital != null && digital != 'none') {
      summary.add(
        'Composante numérique / en ligne : ${_formatFactLabel(digital.toString())}',
      );
    }

    final evidence = answers['evidence_documents'];
    if (evidence != null && evidence != 'none') {
      summary.add(
        'Documents ou éléments enregistrés disponibles : ${_formatFactLabel(evidence.toString())}',
      );
    }

    final consequences = answers['consequences'];
    if (consequences != null && consequences.toString().isNotEmpty) {
      summary.add(
        'Impacts / Conséquences constatées : ${_formatFactLabel(consequences.toString())}',
      );
    }

    final location = answers['location'];
    if (location != null && location.toString().isNotEmpty) {
      summary.add(
        'Lieu des événements : ${_formatFactLabel(location.toString())}',
      );
    }

    final temporality = answers['temporality'];
    if (temporality != null && temporality.toString().isNotEmpty) {
      summary.add(
        'Période / Temporalité : ${_formatFactLabel(temporality.toString())}',
      );
    }

    final currentSituation = answers['situation_current'];
    if (currentSituation != null && currentSituation.toString().isNotEmpty) {
      summary.add(
        'Situation actuelle déclarée : ${_formatFactLabel(currentSituation.toString())}',
      );
    }

    final ageGroup = answers['person_age_group'];
    if (ageGroup != null && ageGroup.toString().isNotEmpty) {
      summary.add(
        'Protection d’un enfant : ${_formatFactLabel(ageGroup.toString())}',
      );
    }

    if (summary.isEmpty) {
      summary.add('Aucun détail spécifique renseigné pour les faits.');
    }

    return summary;
  }

  List<String> _extractFactsSummaryAr(Map<String, dynamic> answers) {
    final summary = <String>[];
    void add(String key, String label, {bool skipNone = false}) {
      final value = answers[key];
      if (value != null &&
          value.toString().isNotEmpty &&
          (!skipNone || value != 'none')) {
        summary.add('$label: ${_formatFactLabelAr(value.toString())}');
      }
    }

    add('nature_facts', 'طبيعة الوقائع المصرح بها');
    add('relationship', 'العلاقة مع الشخص المعني');
    add('context', 'الإطار أو السياق');
    add('frequency', 'تكرار الوقائع');
    add('threats', 'التهديدات أو الترهيب', skipNone: true);
    add('digital_context', 'العنصر الرقمي أو عبر الإنترنت', skipNone: true);
    add('evidence_documents', 'الأدلة أو الوثائق المتاحة', skipNone: true);
    add('consequences', 'الآثار أو العواقب الملحوظة');
    add('location', 'مكان الوقائع');
    add('temporality', 'الفترة الزمنية');
    add('situation_current', 'الوضع الحالي');
    add('person_age_group', 'حماية طفل');

    return summary.isEmpty
        ? const ['لا توجد تفاصيل محددة مسجلة حول الوقائع.']
        : summary;
  }

  List<LegalCategory> _identifyCandidateCategories(
    Map<String, dynamic> answers,
    List<LegalCategory> categories,
  ) {
    final matchedIds = <String>{};

    final nature = answers['nature_facts']?.toString();
    final context = answers['context']?.toString();
    final relationship = answers['relationship']?.toString();
    final threats = answers['threats']?.toString();
    final digital = answers['digital_context']?.toString();

    if (nature == 'physical_violence' || nature == 'assault') {
      matchedIds.add('cat_violence_physique');
    }
    if (relationship == 'spouse' ||
        relationship == 'ex_spouse' ||
        context == 'family_home') {
      matchedIds.add('cat_violence_conjugale');
    }
    if (nature == 'psychological_harassment' || nature == 'verbal_abuse') {
      matchedIds.add('cat_harcelement_moral');
    }
    if (digital != null && digital != 'none' && digital.isNotEmpty) {
      matchedIds.add('cat_cyber_violence');
    }
    if (threats != null && threats != 'none' && threats.isNotEmpty) {
      matchedIds.add('cat_menace_injure');
    }
    if (context == 'minor_involved' ||
        answers['is_minor'] == true ||
        answers['person_age_group'] == 'minor' ||
        answers['child_exposure'] == 'yes') {
      matchedIds.add('cat_protection_mineur');
    }

    // Default to at least one category matching nature if available
    if (matchedIds.isEmpty && categories.isNotEmpty) {
      matchedIds.add(categories.first.id);
    }

    return categories
        .where((c) => matchedIds.contains(c.id) && c.isEnabled)
        .toList();
  }

  String _buildIndicativeQualificationFr(List<LegalCategory> categories) {
    if (categories.isEmpty) {
      return 'Qualification indicative : Éléments déclarés nécessitant une clarification auprès d\'un professionnel.';
    }
    final categoryNames = categories.map((c) => c.titleFr).join(' ; ');
    return 'Qualification indicative (sur la base des faits déclarés) : Faits susceptibles de relever du domaine : $categoryNames.';
  }

  String _buildIndicativeQualificationAr(List<LegalCategory> categories) {
    if (categories.isEmpty) {
      return 'التكييف الاسترشادي: البيانات المصرح بها تتطلب توضيحاً إضافياً من مختص.';
    }
    final categoryNames = categories.map((c) => c.titleAr).join(' ؛ ');
    return 'التكييف الاسترشادي (بناءً على الوقائع المصرح بها): أفعال يحتمل أن تندرج تحت نطاق: $categoryNames.';
  }

  List<String> _identifyCompetentOrganizations(
    Map<String, dynamic> answers,
    List<LegalProcedure> procedures,
  ) {
    final orgs = <String>{
      'Commissariat de Police de la Sûreté Urbaine / Brigade de Gendarmerie Nationale',
      'Procureur de la République près le tribunal territorialement compétent',
    };

    if (answers['threats'] == 'death_threats_weapon' ||
        answers['situation_current'] == 'immediate_danger') {
      orgs.add('Numéro Vert de la Police (1548) et Gendarmerie (1055)');
    }

    if (answers['context'] == 'minor_involved' ||
        answers['is_minor'] == true ||
        answers['person_age_group'] == 'minor' ||
        answers['child_exposure'] == 'yes') {
      orgs.add(
        'Organe National de Protection et de Promotion de l\'Enfance (Ligne 111)',
      );
    }

    orgs.add('Bureau d\'Assistance Juridictionnelle (Tribunal local)');
    orgs.add('Cellule d\'écoute et d\'accompagnement social et psychologique');

    return orgs.toList();
  }

  List<String> _identifyCompetentOrganizationsAr(Map<String, dynamic> answers) {
    final orgs = <String>{
      'مفوضية الشرطة أو فرقة الدرك الوطني',
      'وكيل الجمهورية لدى المحكمة المختصة إقليمياً',
      'مكتب المساعدة القضائية لدى المحكمة المحلية',
      'خلية الاستماع والمرافقة الاجتماعية والنفسية',
    };
    if (answers['threats'] == 'death_threats_weapon' ||
        answers['situation_current'] == 'immediate_danger') {
      orgs.add('الرقم الأخضر للشرطة 1548 والدرك الوطني 1055');
    }
    if (answers['context'] == 'minor_involved' ||
        answers['is_minor'] == true ||
        answers['person_age_group'] == 'minor' ||
        answers['child_exposure'] == 'yes') {
      orgs.add('الهيئة الوطنية لحماية وترقية الطفولة (الخط 111)');
    }
    return orgs.toList();
  }

  String _formatFactLabel(String key) {
    switch (key) {
      case 'physical_violence':
        return 'Violences physiques / agression';
      case 'psychological_harassment':
        return 'Harcèlement moral / pression psychologique';
      case 'cyber_violence':
        return 'Atteintes en ligne / chantage numérique';
      case 'verbal_abuse':
        return 'Injures et propos dégradants';
      case 'threats':
        return 'Menaces directes d\'agression';
      case 'spouse':
        return 'Conjoint ou époux(se)';
      case 'ex_spouse':
        return 'Ex-conjoint ou ex-partenaire';
      case 'family_member':
        return 'Membre de la famille proches';
      case 'colleague_supervisor':
        return 'Collègue ou supérieur hiérarchique';
      case 'stranger':
        return 'Tiers / Personne inconnue';
      case 'isolated':
        return 'Acte isolé / ponctuel';
      case 'repeated':
        return 'Actes répétés sur la durée';
      case 'escalating':
        return 'Actes en intensification croissante';
      case 'messages_chats':
        return 'SMS, discussions de messagerie, e-mails';
      case 'medical_certificate':
        return 'Certificat médical / ITT';
      case 'audio_video':
        return 'Enregistrements vocaux / vidéos';
      case 'immediate_danger':
        return 'En danger imminent / besoin d\'aide rapide';
      case 'safe_for_now':
        return 'Dans un endroit sûr actuellement';
      case 'minor':
        return 'Un enfant ou adolescent est concerné';
      case 'adult':
        return 'La personne concernée est majeure';
      default:
        return key.replaceAll('_', ' ');
    }
  }

  String _formatFactLabelAr(String key) {
    switch (key) {
      case 'physical_violence':
        return 'عنف جسدي أو اعتداء';
      case 'psychological_harassment':
        return 'مضايقة أو ضغط نفسي';
      case 'cyber_violence':
        return 'اعتداءات عبر الإنترنت أو ابتزاز رقمي';
      case 'verbal_abuse':
        return 'إهانات أو ألفاظ مهينة';
      case 'family_home':
        return 'المنزل الأسري أو الزوجي';
      case 'workplace':
        return 'مكان العمل';
      case 'school_university':
        return 'مؤسسة تعليمية أو جامعية';
      case 'online_digital':
        return 'فضاء رقمي أو شبكات اجتماعية';
      case 'public_space':
        return 'فضاء عام';
      case 'spouse':
        return 'الزوج أو الزوجة الحالي(ة)';
      case 'ex_spouse':
        return 'الزوج أو الشريك السابق';
      case 'family_member':
        return 'فرد من العائلة';
      case 'colleague_supervisor':
        return 'زميل أو مسؤول مباشر';
      case 'stranger':
        return 'شخص غير معروف';
      case 'isolated':
        return 'حادثة منفردة';
      case 'repeated':
        return 'وقائع متكررة';
      case 'escalating':
        return 'وقائع تتصاعد حدتها';
      case 'verbal_threats':
        return 'تهديدات لفظية أو ابتزاز';
      case 'death_threats_weapon':
        return 'تهديدات بالقتل أو وجود سلاح';
      case 'cyberbullying':
        return 'رسائل أو اتصالات مزعجة متكررة';
      case 'unauthorized_sharing':
        return 'نشر أو تهديد بنشر محتوى خاص';
      case 'stalking_geoloc':
        return 'مراقبة الأجهزة أو اختراق الحسابات';
      case 'minor':
        return 'طفل أو مراهق معني';
      case 'adult':
        return 'الشخص المعني بالغ';
      case 'messages_chats':
        return 'رسائل أو بريد إلكتروني';
      case 'medical_certificate':
        return 'شهادة طبية أو معاينة';
      case 'audio_video':
        return 'تسجيلات صوتية أو فيديوهات';
      case 'psychological_distress':
        return 'معاناة نفسية أو قلق شديد';
      case 'physical_injuries':
        return 'إصابات جسدية أو كدمات';
      case 'work_school_disruption':
        return 'تعطل العمل أو الدراسة';
      case 'financial_loss':
        return 'ضرر مالي أو حرمان من الموارد';
      case 'home':
        return 'في المنزل';
      case 'work_place':
        return 'في مكان العمل';
      case 'public':
        return 'في مكان عام';
      case 'virtual':
        return 'عبر الإنترنت فقط';
      case 'recent_24h':
        return 'خلال أقل من 24 ساعة';
      case 'recent_month':
        return 'خلال أقل من شهر';
      case 'past_year':
        return 'منذ أكثر من سنة';
      case 'immediate_danger':
        return 'خطر وشيك أو حاجة لمساعدة سريعة';
      case 'safe_for_now':
        return 'في مكان آمن حالياً';
      case 'seeking_information':
        return 'البحث عن معلومات وتوجيه وقائي';
      default:
        return key.replaceAll('_', ' ');
    }
  }
}
