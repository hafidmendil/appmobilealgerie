import 'package:flutter/material.dart';

enum ReporterMode { anonymous, identified, deferred }

enum ProtectionReportStatus {
  draft,
  submitted,
  underReview,
  referred,
  inFollowUp,
  resolved,
  closed,
}

enum RiskLevel { none, attention, moderate, high, immediate }

enum AnswerValue { yes, no, preferNotToAnswer }

enum ViolenceType {
  physical,
  psychological,
  verbal,
  threatIntimidation,
  economic,
  digital,
  harassment,
  discrimination,
  family,
  school,
  workplace,
  sexual,
  childAbuse,
  exploitation,
  domestic,
  groupThreat,
  other,
}

enum ViolenceSeverity {
  level1Preoccupante,
  level2Vigilance,
  level3Accompagnement,
  level4GravePrioriteSecurite,
}

extension ViolenceSeverityExtension on ViolenceSeverity {
  String get code {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return 'LEVEL_1';
      case ViolenceSeverity.level2Vigilance:
        return 'LEVEL_2';
      case ViolenceSeverity.level3Accompagnement:
        return 'LEVEL_3';
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return 'LEVEL_4';
    }
  }

  String labelFr(BuildContext context) {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return 'Niveau 1 : Situation préoccupante / auto-orientation';
      case ViolenceSeverity.level2Vigilance:
        return 'Niveau 2 : Vigilance / accompagnement recommandé';
      case ViolenceSeverity.level3Accompagnement:
        return 'Niveau 3 : Accompagnement spécialisé recommandé';
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return 'Niveau 4 : Situation grave / priorité sécurité';
    }
  }

  String titleFr() {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return 'Situation préoccupante';
      case ViolenceSeverity.level2Vigilance:
        return 'Vigilance et accompagnement suggéré';
      case ViolenceSeverity.level3Accompagnement:
        return 'Besoin d’accompagnement spécialisé';
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return 'Urgence et Priorité Sécurité';
    }
  }

  String titleAr() {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return 'وضعية تستدعي الاهتمام';
      case ViolenceSeverity.level2Vigilance:
        return 'يقظة ومرافقة مقترحة';
      case ViolenceSeverity.level3Accompagnement:
        return 'حاجة لمرافقة متخصصة';
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return 'طوارئ وأولوية أمنية قصوى';
    }
  }

  String explanationFr() {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return 'Certains indicateurs suggèrent une situation qui mérite votre attention pour prévenir une dégradation.';
      case ViolenceSeverity.level2Vigilance:
        return 'La situation présente des risques modérés. Un soutien psychologique ou social est conseillé.';
      case ViolenceSeverity.level3Accompagnement:
        return 'Des indicateurs de violence sont confirmés. Une mise en relation avec des professionnels est fortement recommandée.';
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return 'Le danger semble immédiat ou très élevé. Votre sécurité est la priorité absolue.';
    }
  }

  String explanationAr() {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return 'تشير بعض المؤشرات إلى وضعية تستحق اهتمامك لتجنب أي تدهور مستقبلي.';
      case ViolenceSeverity.level2Vigilance:
        return 'تظهر الوضعية مخاطر متوسطة. ينصح بالحصول على دعم نفسي أو اجتماعي.';
      case ViolenceSeverity.level3Accompagnement:
        return 'تم تأكيد مؤشرات وجود عنف. نوصي بشدة بالتواصل مع مختصين مؤهلين.';
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return 'يبدو أن الخطر داهم أو مرتفع جداً. سلامتك هي الأولوية القصوى والوحيدة حالياً.';
    }
  }

  RiskLevel toRiskLevel() {
    switch (this) {
      case ViolenceSeverity.level1Preoccupante:
        return RiskLevel.attention;
      case ViolenceSeverity.level2Vigilance:
        return RiskLevel.moderate;
      case ViolenceSeverity.level3Accompagnement:
        return RiskLevel.high;
      case ViolenceSeverity.level4GravePrioriteSecurite:
        return RiskLevel.immediate;
    }
  }

  static ViolenceSeverity fromRiskLevel(RiskLevel level) {
    switch (level) {
      case RiskLevel.none:
      case RiskLevel.attention:
        return ViolenceSeverity.level1Preoccupante;
      case RiskLevel.moderate:
        return ViolenceSeverity.level2Vigilance;
      case RiskLevel.high:
        return ViolenceSeverity.level3Accompagnement;
      case RiskLevel.immediate:
        return ViolenceSeverity.level4GravePrioriteSecurite;
    }
  }
}

enum ContextType { family, couple, school, work, neighborhood, online, other }

enum OccurrencePattern { isolated, repeated, escalating, unknown }

class ViolenceCategory {
  final ViolenceType id;
  final String code;
  final String labelFr;
  final String labelAr;
  final String descriptionFr;
  final String descriptionAr;
  final bool isEnabled;

  const ViolenceCategory({
    required this.id,
    required this.code,
    required this.labelFr,
    required this.labelAr,
    required this.descriptionFr,
    required this.descriptionAr,
    this.isEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id.name,
    'code': code,
    'labelFr': labelFr,
    'labelAr': labelAr,
    'descriptionFr': descriptionFr,
    'descriptionAr': descriptionAr,
    'isEnabled': isEnabled,
  };

  factory ViolenceCategory.fromJson(Map<String, dynamic> json) =>
      ViolenceCategory(
        id: ViolenceType.values.byName(json['id'] as String),
        code: json['code'] as String,
        labelFr: json['labelFr'] as String,
        labelAr: json['labelAr'] as String,
        descriptionFr: json['descriptionFr'] as String,
        descriptionAr: json['descriptionAr'] as String,
        isEnabled: json['isEnabled'] as bool? ?? true,
      );
}

class ViolenceCategoryRegistry {
  static final List<ViolenceCategory> _categories = [
    const ViolenceCategory(
      id: ViolenceType.physical,
      code: 'PHYSICAL',
      labelFr: 'Violence physique',
      labelAr: 'عنف جسدي',
      descriptionFr: 'Coups, blessures ou contraintes physiques.',
      descriptionAr: 'ضرب أو إيذاء أو إكراه جسدي.',
    ),
    const ViolenceCategory(
      id: ViolenceType.psychological,
      code: 'PSYCHOLOGICAL',
      labelFr: 'Violence psychologique',
      labelAr: 'عنف نفسي',
      descriptionFr: 'Humiliation, dévalorisation, contrôle ou manipulation.',
      descriptionAr: 'إهانة، تقليل من القدر، سيطرة أو تلاعب نفسي.',
    ),
    const ViolenceCategory(
      id: ViolenceType.verbal,
      code: 'VERBAL',
      labelFr: 'Violence verbale',
      labelAr: 'عنف لفظي',
      descriptionFr: 'Insultes, cris, injures ou propos dégradants.',
      descriptionAr: 'شتم، صراخ، إهانات أو كلام مسيء.',
    ),
    const ViolenceCategory(
      id: ViolenceType.threatIntimidation,
      code: 'THREAT',
      labelFr: 'Menace / Intimidation',
      labelAr: 'تهديد / ترهيب',
      descriptionFr: 'Menaces directes, chantages ou comportement intimidant.',
      descriptionAr: 'تهديدات مباشرة، ابتزاز أو سلوك ترهيبي.',
    ),
    const ViolenceCategory(
      id: ViolenceType.economic,
      code: 'ECONOMIC',
      labelFr: 'Violence économique',
      labelAr: 'عنف اقتصادي',
      descriptionFr:
          'Privation de ressources, contrôle financier ou interdiction de travailler.',
      descriptionAr: 'حرمان من الموارد، سيطرة مالية أو منع من العمل.',
    ),
    const ViolenceCategory(
      id: ViolenceType.digital,
      code: 'DIGITAL',
      labelFr: 'Violence numérique',
      labelAr: 'عنف رقمي',
      descriptionFr:
          'Cyberharcèlement, surveillance en ligne, chantage photo/vidéo.',
      descriptionAr: 'مضايقة عبر الإنترنت، مراقبة رقمية، ابتزاز إلكتروني.',
    ),
    const ViolenceCategory(
      id: ViolenceType.harassment,
      code: 'HARASSMENT',
      labelFr: 'Harcèlement',
      labelAr: 'مضايقة / تحرش',
      descriptionFr:
          'Agissements répétés visant à dégrader les conditions de vie.',
      descriptionAr: 'سلوكيات متكررة تهدف إلى التضييق ومس بالكرامة.',
    ),
    const ViolenceCategory(
      id: ViolenceType.discrimination,
      code: 'DISCRIMINATION',
      labelFr: 'Discrimination ou comportements assimilés',
      labelAr: 'تمييز أو سلوكيات مشابهة',
      descriptionFr: 'Rejet, stigmatisation ou traitement inéquitable.',
      descriptionAr: 'رفض، وصم أو معاملة غير عادلة.',
    ),
    const ViolenceCategory(
      id: ViolenceType.family,
      code: 'FAMILY',
      labelFr: 'Violence familiale / conjugale',
      labelAr: 'عنف أسري / زوجي',
      descriptionFr: 'Tensions ou violences au sein du foyer ou de la famille.',
      descriptionAr: 'عنف أو توترات داخل الأسرة أو بين الزوجين.',
    ),
    const ViolenceCategory(
      id: ViolenceType.school,
      code: 'SCHOOL',
      labelFr: 'Violence scolaire',
      labelAr: 'عنف مدرسي',
      descriptionFr: 'Tensions, intimidations ou violences en milieu scolaire.',
      descriptionAr: 'مضايقات أو عنف في المحيط المدرسي.',
    ),
    const ViolenceCategory(
      id: ViolenceType.workplace,
      code: 'WORKPLACE',
      labelFr: 'Violence professionnelle',
      labelAr: 'عنف مهني',
      descriptionFr:
          'Pression abusive, intimidation ou harcèlement au travail.',
      descriptionAr: 'ضغط تعسفي، ترهيب أو مضايقة في مكان العمل.',
    ),
    const ViolenceCategory(
      id: ViolenceType.sexual,
      code: 'SEXUAL',
      labelFr: 'Violence sexuelle',
      labelAr: 'عنف جنسي',
      descriptionFr: 'Atteintes ou pressions sans consentement.',
      descriptionAr: 'سلوكيات أو ضغوط دون موافقة.',
    ),
    const ViolenceCategory(
      id: ViolenceType.childAbuse,
      code: 'CHILD_ABUSE',
      labelFr: 'Négligence ou maltraitance d’un enfant',
      labelAr: 'إهمال أو إساءة معاملة طفل',
      descriptionFr:
          'Situation préoccupante concernant la protection d’un enfant.',
      descriptionAr: 'وضع مقلق يخص حماية طفل.',
    ),
    const ViolenceCategory(
      id: ViolenceType.exploitation,
      code: 'EXPLOITATION',
      labelFr: 'Exploitation ou contrainte',
      labelAr: 'استغلال أو إكراه',
      descriptionFr: 'Soumission forced ou exploitation.',
      descriptionAr: 'إخضاع قسري أو استغلال.',
    ),
    const ViolenceCategory(
      id: ViolenceType.other,
      code: 'OTHER',
      labelFr: 'Autres situations validées',
      labelAr: 'حالات أخرى معتمدة',
      descriptionFr: 'Situation spécifique non répertoriée ci-dessus.',
      descriptionAr: 'حالة خاصة غير مدرجة أعلاه.',
    ),
  ];

  static List<ViolenceCategory> get all =>
      List.unmodifiable(_categories.where((c) => c.isEnabled));

  static ViolenceCategory? getById(ViolenceType id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  static void addCategory(ViolenceCategory category) {
    _categories.removeWhere((c) => c.id == category.id);
    _categories.add(category);
  }
}

const violenceCategories = <ViolenceCategory>[
  ViolenceCategory(
    id: ViolenceType.physical,
    code: 'PHYSICAL',
    labelFr: 'Violence physique',
    labelAr: 'عنف جسدي',
    descriptionFr: 'Coups ou blessures.',
    descriptionAr: 'الضرب أو الإيذاء الجسدي.',
  ),
  ViolenceCategory(
    id: ViolenceType.psychological,
    code: 'PSYCHOLOGICAL',
    labelFr: 'Violence psychologique ou verbale',
    labelAr: 'عنف نفسي أو لفظي',
    descriptionFr: 'Menaces, humiliations ou contrôle.',
    descriptionAr: 'التهديد أو الإهانة أو السيطرة.',
  ),
  ViolenceCategory(
    id: ViolenceType.verbal,
    code: 'VERBAL',
    labelFr: 'Violence verbale',
    labelAr: 'عنف لفظي',
    descriptionFr: 'Insultes et injures.',
    descriptionAr: 'شتم وإهانات.',
  ),
  ViolenceCategory(
    id: ViolenceType.threatIntimidation,
    code: 'THREAT',
    labelFr: 'Menace / Intimidation',
    labelAr: 'تهديد / ترهيب',
    descriptionFr: 'Menaces directes.',
    descriptionAr: 'تهديدات مباشرة.',
  ),
  ViolenceCategory(
    id: ViolenceType.economic,
    code: 'ECONOMIC',
    labelFr: 'Violence économique',
    labelAr: 'عنف اقتصادي',
    descriptionFr: 'Privation de ressources.',
    descriptionAr: 'الحرمان من الموارد.',
  ),
  ViolenceCategory(
    id: ViolenceType.digital,
    code: 'DIGITAL',
    labelFr: 'Violence numérique',
    labelAr: 'عنف رقمي',
    descriptionFr: 'Chantage en ligne.',
    descriptionAr: 'ابتزاز إلكتروني.',
  ),
  ViolenceCategory(
    id: ViolenceType.harassment,
    code: 'HARASSMENT',
    labelFr: 'Harcèlement',
    labelAr: 'مضايقة',
    descriptionFr: 'Actes répétés.',
    descriptionAr: 'أفعال متكررة.',
  ),
  ViolenceCategory(
    id: ViolenceType.discrimination,
    code: 'DISCRIMINATION',
    labelFr: 'Discrimination',
    labelAr: 'تمييز',
    descriptionFr: 'Traitement inéquitable.',
    descriptionAr: 'معاملة غير عادلة.',
  ),
  ViolenceCategory(
    id: ViolenceType.family,
    code: 'FAMILY',
    labelFr: 'Violence familiale',
    labelAr: 'عنف أسري',
    descriptionFr: 'Tensions au foyer.',
    descriptionAr: 'عنف داخل الأسرة.',
  ),
  ViolenceCategory(
    id: ViolenceType.school,
    code: 'SCHOOL',
    labelFr: 'Violence scolaire',
    labelAr: 'عنف مدرسي',
    descriptionFr: 'Cadre d’étude.',
    descriptionAr: 'في المحيط المدرسي.',
  ),
  ViolenceCategory(
    id: ViolenceType.workplace,
    code: 'WORKPLACE',
    labelFr: 'Violence professionnelle',
    labelAr: 'عنف مهني',
    descriptionFr: 'Cadre de travail.',
    descriptionAr: 'في مكان العمل.',
  ),
  ViolenceCategory(
    id: ViolenceType.sexual,
    code: 'SEXUAL',
    labelFr: 'Violence sexuelle',
    labelAr: 'عنف جنسي',
    descriptionFr: 'Actes sans consentement.',
    descriptionAr: 'أفعال دون موافقة.',
  ),
  ViolenceCategory(
    id: ViolenceType.childAbuse,
    code: 'CHILD_ABUSE',
    labelFr: 'Maltraitance d’enfant',
    labelAr: 'إساءة طفل',
    descriptionFr: 'Protection enfant.',
    descriptionAr: 'حماية طفل.',
  ),
  ViolenceCategory(
    id: ViolenceType.exploitation,
    code: 'EXPLOITATION',
    labelFr: 'Exploitation',
    labelAr: 'استغلال',
    descriptionFr: 'Contrainte.',
    descriptionAr: 'إكراه.',
  ),
  ViolenceCategory(
    id: ViolenceType.other,
    code: 'OTHER',
    labelFr: 'Autres',
    labelAr: 'أخرى',
    descriptionFr: 'Autre situation.',
    descriptionAr: 'وضعية أخرى.',
  ),
];

class ViolenceAnswer {
  final String questionId;
  final AnswerValue value;
  final DateTime timestamp;
  final String? questionCategory;

  const ViolenceAnswer({
    required this.questionId,
    required this.value,
    required this.timestamp,
    this.questionCategory,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'value': value.name,
    'timestamp': timestamp.toIso8601String(),
    'questionCategory': questionCategory,
  };

  factory ViolenceAnswer.fromJson(Map<String, dynamic> json) => ViolenceAnswer(
    questionId: json['questionId'] as String,
    value: AnswerValue.values.byName(json['value'] as String),
    timestamp: DateTime.parse(json['timestamp'] as String),
    questionCategory: json['questionCategory'] as String?,
  );
}

class ViolenceIndicator {
  final String id;
  final String labelFr;
  final String labelAr;
  final int weight;
  final bool isRedFlag;
  final ViolenceType category;

  const ViolenceIndicator({
    required this.id,
    required this.labelFr,
    required this.labelAr,
    required this.weight,
    required this.isRedFlag,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'labelFr': labelFr,
    'labelAr': labelAr,
    'weight': weight,
    'isRedFlag': isRedFlag,
    'category': category.name,
  };

  factory ViolenceIndicator.fromJson(Map<String, dynamic> json) =>
      ViolenceIndicator(
        id: json['id'] as String,
        labelFr: json['labelFr'] as String,
        labelAr: json['labelAr'] as String,
        weight: json['weight'] as int,
        isRedFlag: json['isRedFlag'] as bool,
        category: ViolenceType.values.byName(json['category'] as String),
      );
}

class RiskFactor {
  final String id;
  final String labelFr;
  final String labelAr;
  final String category;
  final int weight;
  final bool isCritical;

  const RiskFactor({
    required this.id,
    required this.labelFr,
    required this.labelAr,
    required this.category,
    required this.weight,
    required this.isCritical,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'labelFr': labelFr,
    'labelAr': labelAr,
    'category': category,
    'weight': weight,
    'isCritical': isCritical,
  };

  factory RiskFactor.fromJson(Map<String, dynamic> json) => RiskFactor(
    id: json['id'] as String,
    labelFr: json['labelFr'] as String,
    labelAr: json['labelAr'] as String,
    category: json['category'] as String,
    weight: json['weight'] as int,
    isCritical: json['isCritical'] as bool,
  );
}

class RedFlag {
  final String id;
  final String code;
  final String titleFr;
  final String titleAr;
  final String descriptionFr;
  final String descriptionAr;
  final ViolenceSeverity severity;
  final String triggerCondition;

  const RedFlag({
    required this.id,
    required this.code,
    required this.titleFr,
    required this.titleAr,
    required this.descriptionFr,
    required this.descriptionAr,
    required this.severity,
    required this.triggerCondition,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'titleFr': titleFr,
    'titleAr': titleAr,
    'descriptionFr': descriptionFr,
    'descriptionAr': descriptionAr,
    'severity': severity.name,
    'triggerCondition': triggerCondition,
  };

  factory RedFlag.fromJson(Map<String, dynamic> json) => RedFlag(
    id: json['id'] as String,
    code: json['code'] as String,
    titleFr: json['titleFr'] as String,
    titleAr: json['titleAr'] as String,
    descriptionFr: json['descriptionFr'] as String,
    descriptionAr: json['descriptionAr'] as String,
    severity: ViolenceSeverity.values.byName(json['severity'] as String),
    triggerCondition: json['triggerCondition'] as String,
  );
}

class OrientationDetails {
  final String requiredSpecialty;
  final String urgencyLevel;
  final String wilaya;
  final bool remoteConsultationPossible;
  final bool inPersonPossible;
  final List<String> recommendedSpecialists;

  const OrientationDetails({
    required this.requiredSpecialty,
    required this.urgencyLevel,
    required this.wilaya,
    this.remoteConsultationPossible = true,
    this.inPersonPossible = true,
    this.recommendedSpecialists = const [],
  });

  Map<String, dynamic> toJson() => {
    'requiredSpecialty': requiredSpecialty,
    'urgencyLevel': urgencyLevel,
    'wilaya': wilaya,
    'remoteConsultationPossible': remoteConsultationPossible,
    'inPersonPossible': inPersonPossible,
    'recommendedSpecialists': recommendedSpecialists,
  };

  factory OrientationDetails.fromJson(Map<String, dynamic> json) =>
      OrientationDetails(
        requiredSpecialty: json['requiredSpecialty'] as String,
        urgencyLevel: json['urgencyLevel'] as String,
        wilaya: json['wilaya'] as String? ?? '01',
        remoteConsultationPossible:
            json['remoteConsultationPossible'] as bool? ?? true,
        inPersonPossible: json['inPersonPossible'] as bool? ?? true,
        recommendedSpecialists: List<String>.from(
          json['recommendedSpecialists'] as List? ?? [],
        ),
      );
}

class LegalContextPreparation {
  final bool hasDocumentedTimeline;
  final List<String> legalRelevantIndicators;
  final String recommendationForLegalModule;

  const LegalContextPreparation({
    required this.hasDocumentedTimeline,
    required this.legalRelevantIndicators,
    required this.recommendationForLegalModule,
  });

  Map<String, dynamic> toJson() => {
    'hasDocumentedTimeline': hasDocumentedTimeline,
    'legalRelevantIndicators': legalRelevantIndicators,
    'recommendationForLegalModule': recommendationForLegalModule,
  };

  factory LegalContextPreparation.fromJson(Map<String, dynamic> json) =>
      LegalContextPreparation(
        hasDocumentedTimeline: json['hasDocumentedTimeline'] as bool? ?? false,
        legalRelevantIndicators: List<String>.from(
          json['legalRelevantIndicators'] as List? ?? [],
        ),
        recommendationForLegalModule:
            json['recommendationForLegalModule'] as String? ?? '',
      );
}

class ViolenceAssessment {
  final String id;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ViolenceType> categories;
  final Map<String, AnswerValue> answers;
  final String? frequency;
  final String? duration;
  final String? contextType;
  final String? relationshipToAuthor;
  final String? resultId;
  final String status; // 'draft', 'completed', 'interruptedByRedFlag'
  final bool isAnonymous;

  const ViolenceAssessment({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.categories,
    required this.answers,
    this.frequency,
    this.duration,
    this.contextType,
    this.relationshipToAuthor,
    this.resultId,
    required this.status,
    required this.isAnonymous,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'categories': categories.map((c) => c.name).toList(),
    'answers': answers.map((k, v) => MapEntry(k, v.name)),
    'frequency': frequency,
    'duration': duration,
    'contextType': contextType,
    'relationshipToAuthor': relationshipToAuthor,
    'resultId': resultId,
    'status': status,
    'isAnonymous': isAnonymous,
  };

  factory ViolenceAssessment.fromJson(Map<String, dynamic> json) =>
      ViolenceAssessment(
        id: json['id'] as String,
        userId: json['userId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        categories: (json['categories'] as List)
            .map((c) => ViolenceType.values.byName(c as String))
            .toList(),
        answers: (json['answers'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, AnswerValue.values.byName(v as String)),
        ),
        frequency: json['frequency'] as String?,
        duration: json['duration'] as String?,
        contextType: json['contextType'] as String?,
        relationshipToAuthor: json['relationshipToAuthor'] as String?,
        resultId: json['resultId'] as String?,
        status: json['status'] as String,
        isAnonymous: json['isAnonymous'] as bool? ?? true,
      );
}

class ViolenceAssessmentResult {
  final String id;
  final String assessmentId;
  final DateTime assessedAt;
  final ViolenceSeverity severity;
  final RiskLevel level;
  final List<RedFlag> detectedRedFlags;
  final List<String> influencingFactors;
  final List<ViolenceType> identifiedTypes;
  final List<String> initialGuidance;
  final List<String>? initialGuidanceAr;
  final List<String>? initialGuidanceFr;
  final OrientationDetails orientation;
  final LegalContextPreparation legalPreparation;
  final String disclaimer;
  final String? disclaimerAr;
  final String? disclaimerFr;

  const ViolenceAssessmentResult({
    required this.id,
    required this.assessmentId,
    required this.assessedAt,
    required this.severity,
    required this.level,
    required this.detectedRedFlags,
    required this.influencingFactors,
    required this.identifiedTypes,
    required this.initialGuidance,
    this.initialGuidanceAr,
    this.initialGuidanceFr,
    required this.orientation,
    required this.legalPreparation,
    required this.disclaimer,
    this.disclaimerAr,
    this.disclaimerFr,
  });

  List<String> guidanceFor(bool isRtl) =>
      isRtl ? (initialGuidanceAr ?? initialGuidance) : (initialGuidanceFr ?? initialGuidance);

  String disclaimerFor(bool isRtl) =>
      isRtl ? (disclaimerAr ?? disclaimer) : (disclaimerFr ?? disclaimer);

  Map<String, dynamic> toJson() => {
    'id': id,
    'assessmentId': assessmentId,
    'assessedAt': assessedAt.toIso8601String(),
    'severity': severity.name,
    'level': level.name,
    'detectedRedFlags': detectedRedFlags.map((r) => r.toJson()).toList(),
    'influencingFactors': influencingFactors,
    'identifiedTypes': identifiedTypes.map((t) => t.name).toList(),
    'initialGuidance': initialGuidance,
    'initialGuidanceAr': initialGuidanceAr,
    'initialGuidanceFr': initialGuidanceFr,
    'orientation': orientation.toJson(),
    'legalPreparation': legalPreparation.toJson(),
    'disclaimer': disclaimer,
    'disclaimerAr': disclaimerAr,
    'disclaimerFr': disclaimerFr,
  };

  factory ViolenceAssessmentResult.fromJson(Map<String, dynamic> json) =>
      ViolenceAssessmentResult(
        id: json['id'] as String,
        assessmentId: json['assessmentId'] as String,
        assessedAt: DateTime.parse(json['assessedAt'] as String),
        severity: ViolenceSeverity.values.byName(json['severity'] as String),
        level: RiskLevel.values.byName(json['level'] as String),
        detectedRedFlags: (json['detectedRedFlags'] as List)
            .map((r) => RedFlag.fromJson(Map<String, dynamic>.from(r as Map)))
            .toList(),
        influencingFactors: List<String>.from(
          json['influencingFactors'] as List,
        ),
        identifiedTypes: (json['identifiedTypes'] as List)
            .map((t) => ViolenceType.values.byName(t as String))
            .toList(),
        initialGuidance: List<String>.from(json['initialGuidance'] as List),
        initialGuidanceAr: json['initialGuidanceAr'] != null
            ? List<String>.from(json['initialGuidanceAr'] as List)
            : null,
        initialGuidanceFr: json['initialGuidanceFr'] != null
            ? List<String>.from(json['initialGuidanceFr'] as List)
            : null,
        orientation: OrientationDetails.fromJson(
          Map<String, dynamic>.from(json['orientation'] as Map),
        ),
        legalPreparation: LegalContextPreparation.fromJson(
          Map<String, dynamic>.from(json['legalPreparation'] as Map),
        ),
        disclaimer: json['disclaimer'] as String,
        disclaimerAr: json['disclaimerAr'] as String?,
        disclaimerFr: json['disclaimerFr'] as String?,
      );

  RiskAssessment toRiskAssessment({required String reportId}) {
    return RiskAssessment(
      id: id,
      reportId: reportId,
      assessedAt: assessedAt,
      level: level,
      factors: influencingFactors,
      emergencyFlags: detectedRedFlags.map((r) => r.code).toList(),
      recommendedActions: initialGuidance,
      engineVersion: 'neurosync-violence-risk-2.0',
      assessedBy: 'ViolenceRiskEngine',
      humanReviewRequired:
          severity == ViolenceSeverity.level3Accompagnement ||
          severity == ViolenceSeverity.level4GravePrioriteSecurite,
    );
  }
}

class ViolenceReport {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReporterMode reporterMode;
  final List<ViolenceType> violenceTypes;
  final ContextType contextType;
  final OccurrencePattern occurrencePattern;
  final String? riskAssessmentId;
  final ProtectionReportStatus status;
  final String consentVersion;
  final String confidentialityLevel;
  final String? userId;
  final DateTime? approximateDate;
  final String? approximateLocation;
  final String? description;
  final String? victimAgeGroup;
  final String? relationshipToAuthor;
  final String? preferredReferralType;
  final List<String> attachmentReferences;
  final String? assignedProfessionalId;
  final DateTime? closedAt;
  final String? closureReason;

  const ViolenceReport({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.reporterMode,
    required this.violenceTypes,
    required this.contextType,
    required this.occurrencePattern,
    required this.riskAssessmentId,
    required this.status,
    required this.consentVersion,
    required this.confidentialityLevel,
    this.userId,
    this.approximateDate,
    this.approximateLocation,
    this.description,
    this.victimAgeGroup,
    this.relationshipToAuthor,
    this.preferredReferralType,
    this.attachmentReferences = const [],
    this.assignedProfessionalId,
    this.closedAt,
    this.closureReason,
  }) : assert(reporterMode != ReporterMode.anonymous || userId == null);
}

class RiskAssessment {
  final String id;
  final String reportId;
  final DateTime assessedAt;
  final RiskLevel level;
  final List<String> factors;
  final List<String> emergencyFlags;
  final List<String> recommendedActions;
  final String engineVersion;
  final String assessedBy;
  final bool humanReviewRequired;

  const RiskAssessment({
    required this.id,
    required this.reportId,
    required this.assessedAt,
    required this.level,
    required this.factors,
    required this.emergencyFlags,
    required this.recommendedActions,
    required this.engineVersion,
    required this.assessedBy,
    required this.humanReviewRequired,
  });
}

class Referral {
  final String id;
  final String reportId;
  final String referralType;
  final String destinationId;
  final String reason;
  final DateTime createdAt;
  final String createdBy;
  final String status;
  final bool consentRequired;
  final DateTime? consentGrantedAt;
  final DateTime? followUpDate;
  final DateTime? completedAt;

  const Referral({
    required this.id,
    required this.reportId,
    required this.referralType,
    required this.destinationId,
    required this.reason,
    required this.createdAt,
    required this.createdBy,
    required this.status,
    required this.consentRequired,
    this.consentGrantedAt,
    this.followUpDate,
    this.completedAt,
  });
}

class AuditEvent {
  final String id;
  final DateTime timestamp;
  final String? actorId;
  final String actorRole;
  final String action;
  final String targetType;
  final String targetId;
  final String reason;
  final bool success;
  final Map<String, String> technicalMetadata;

  const AuditEvent({
    required this.id,
    required this.timestamp,
    this.actorId,
    required this.actorRole,
    required this.action,
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.success,
    this.technicalMetadata = const {},
  });
}

class SafetyPlan {
  final String id;
  final String reportId;
  final DateTime createdAt;
  final List<String> safeContacts;
  final List<String> safePlaces;
  final List<String> emergencyActions;
  final String communicationPreferences;
  final DateTime? reviewDate;

  const SafetyPlan({
    required this.id,
    required this.reportId,
    required this.createdAt,
    this.safeContacts = const [],
    this.safePlaces = const [],
    this.emergencyActions = const [],
    this.communicationPreferences = '',
    this.reviewDate,
  });
}

class ConsentRecord {
  final String id;
  final String version;
  final DateTime recordedAt;
  final bool granted;
  final String context;
  final String? userId;

  const ConsentRecord({
    required this.id,
    required this.version,
    required this.recordedAt,
    required this.granted,
    required this.context,
    this.userId,
  });
}

class ProfessionalPartner {
  final String id;
  final String name;
  final String specialty;
  final String wilaya;
  final String commune;
  final String? approximateLocation;
  final String? phone;
  final String? email;
  final String availability;
  final bool verified;
  final DateTime? verificationDate;
  final String status;

  const ProfessionalPartner({
    required this.id,
    required this.name,
    required this.specialty,
    required this.wilaya,
    required this.commune,
    this.approximateLocation,
    this.phone,
    this.email,
    required this.availability,
    required this.verified,
    this.verificationDate,
    required this.status,
  });
}

class PreventionPartner {
  final String id;
  final String name;
  final String type;
  final String wilaya;
  final String contact;
  final bool verified;
  final DateTime? verificationDate;

  const PreventionPartner({
    required this.id,
    required this.name,
    required this.type,
    required this.wilaya,
    required this.contact,
    required this.verified,
    this.verificationDate,
  });
}

class VerifiedEmergencyNumber {
  final String number;
  final String country;
  final String zone;
  final String type;
  final DateTime verifiedAt;
  final String officialSource;
  final bool active;

  const VerifiedEmergencyNumber({
    required this.number,
    required this.country,
    required this.zone,
    required this.type,
    required this.verifiedAt,
    required this.officialSource,
    required this.active,
  });
}
