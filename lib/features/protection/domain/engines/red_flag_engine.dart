import '../models/protection_models.dart';

class RedFlagEngine {
  static const List<RedFlag> knownRedFlags = [
    RedFlag(
      id: 'rf_current_danger',
      code: 'currentDanger',
      titleFr: 'Danger physique immédiat',
      titleAr: 'خطر جسدي مباشر',
      descriptionFr:
          'La personne se trouve en situation de danger direct et actuel.',
      descriptionAr: 'الشخص في حالة خطر مباشر وحالي.',
      severity: ViolenceSeverity.level4GravePrioriteSecurite,
      triggerCondition: 'currentDanger == yes',
    ),
    RedFlag(
      id: 'rf_serious_threat',
      code: 'seriousThreat',
      titleFr: 'Menace grave récente',
      titleAr: 'تهديد خطير حديث',
      descriptionFr:
          'Menace directe d’atteinte à l’intégrité physique ou psychique.',
      descriptionAr: 'تهديد مباشر بالمساس بالسلامة الجسدية أو النفسية.',
      severity: ViolenceSeverity.level4GravePrioriteSecurite,
      triggerCondition: 'seriousThreat == yes',
    ),
    RedFlag(
      id: 'rf_dangerous_means',
      code: 'dangerousMeans',
      titleFr: 'Présence d’armes ou moyens dangereux',
      titleAr: 'وجود أسلحة أو وسيلة خطيرة',
      descriptionFr:
          'Possession ou utilisation de moyens dangereux par l’auteur.',
      descriptionAr: 'حيازة أو استخدام وسائل خطيرة من طرف الفاعل.',
      severity: ViolenceSeverity.level4GravePrioriteSecurite,
      triggerCondition: 'dangerousMeans == yes',
    ),
    RedFlag(
      id: 'rf_confinement',
      code: 'confinement',
      titleFr: 'Séquestration ou privation de liberté',
      titleAr: 'احتجاز أو حرمان من الحرية',
      descriptionFr:
          'Enfermement, contrainte physique ou interdiction absolue de se déplacer.',
      descriptionAr: 'احتجاز، إكراه جسدي أو منع مطلق من التنقل.',
      severity: ViolenceSeverity.level4GravePrioriteSecurite,
      triggerCondition: 'confinement == yes || lockedIn == yes',
    ),
    RedFlag(
      id: 'rf_child_risk',
      code: 'childAtSeriousRisk',
      titleFr: 'Danger grave concernant un enfant',
      titleAr: 'خطر جسيم يهدد طفلاً',
      descriptionFr:
          'Enfant directement exposé à de la violence grave ou maltraitance.',
      descriptionAr: 'طفل معرض بشكل مباشر لعنف جسيم أو إساءة معاملة.',
      severity: ViolenceSeverity.level4GravePrioriteSecurite,
      triggerCondition: 'childAtSeriousRisk == yes',
    ),
    RedFlag(
      id: 'rf_digital_blackmail',
      code: 'digitalBlackmailCritical',
      titleFr: 'Chantage numérique critique',
      titleAr: 'ابتزاز رقمي حرج',
      descriptionFr:
          'Menace de diffusion imminente de contenu intime ou compromettant.',
      descriptionAr: 'تهديد بنشر وشيك لمحتوى خاص أو حساس.',
      severity: ViolenceSeverity.level3Accompagnement,
      triggerCondition: 'digitalBlackmail == yes && digitalSharing == yes',
    ),
  ];

  const RedFlagEngine();

  List<RedFlag> evaluate(Map<String, AnswerValue> answers) {
    final active = <RedFlag>[];
    for (final rf in knownRedFlags) {
      final code = rf.code;
      if (answers[code] == AnswerValue.yes) {
        active.add(rf);
      } else if (code == 'confinement' &&
          (answers['lockedIn'] == AnswerValue.yes ||
              answers['confinement'] == AnswerValue.yes)) {
        if (!active.contains(rf)) active.add(rf);
      } else if (code == 'digitalBlackmailCritical' &&
          answers['digitalBlackmail'] == AnswerValue.yes &&
          answers['digitalSharing'] == AnswerValue.yes) {
        if (!active.contains(rf)) active.add(rf);
      }
    }
    return active;
  }

  bool hasCriticalRedFlag(Map<String, AnswerValue> answers) {
    return evaluate(
      answers,
    ).any((rf) => rf.severity == ViolenceSeverity.level4GravePrioriteSecurite);
  }
}
