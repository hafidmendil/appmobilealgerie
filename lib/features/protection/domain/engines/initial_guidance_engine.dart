import '../models/protection_models.dart';

class GuidanceItem {
  final String id;
  final String
  category; // 'trusted_contact', 'professional', 'legal', 'emergency', 'resources'
  final String titleFr;
  final String titleAr;
  final String textFr;
  final String textAr;
  final ViolenceSeverity minSeverity;
  final bool isEmergencyAction;

  const GuidanceItem({
    required this.id,
    required this.category,
    required this.titleFr,
    required this.titleAr,
    required this.textFr,
    required this.textAr,
    this.minSeverity = ViolenceSeverity.level1Preoccupante,
    this.isEmergencyAction = false,
  });
}

class InitialGuidanceEngine {
  static final List<GuidanceItem> _configurableItems = [
    const GuidanceItem(
      id: 'guidance_emergency_help',
      category: 'emergency',
      titleFr: 'Mise en sécurité et assistance urgente',
      titleAr: 'الحماية الفورية وطلب المساعدة العاجلة',
      textFr:
          'Si vous êtes en danger direct, éloignez-vous du danger et contactez immédiatement un service d’urgence ou une personne refuge.',
      textAr:
          'إذا كنت في خطر مباشر، ابتعد عن مصدر الخطر واتصل فوراً برقم الطوارئ أو بشخص موثوق للحماية.',
      minSeverity: ViolenceSeverity.level4GravePrioriteSecurite,
      isEmergencyAction: true,
    ),
    const GuidanceItem(
      id: 'guidance_trusted_contact',
      category: 'trusted_contact',
      titleFr: 'Chercher du soutien auprès d’une personne de confiance',
      titleAr: 'طلب الدعم من شخص موثوق',
      textFr:
          'Partagez ce que vous vivez avec un membre de votre entoure de confiance afin de ne pas rester isolé(e).',
      textAr: 'شارك ما تمر به مع شخص مقرب وموثوق لعدم البقاء في عزلة.',
      minSeverity: ViolenceSeverity.level1Preoccupante,
    ),
    const GuidanceItem(
      id: 'guidance_professional',
      category: 'professional',
      titleFr: 'Contacter un professionnel qualifié',
      titleAr: 'التواصل مع مختص مؤهل',
      textFr:
          'Prenez contact avec un psychologue ou un accompagnateur spécialisé dans l’annuaire pour un espace d’écoute sécurisé.',
      textAr:
          'تواصل مع أخصائي نفسي أو مرافِق متخصص عبر الدليل الوطني لضمان مساحة استماع آمنة.',
      minSeverity: ViolenceSeverity.level2Vigilance,
    ),
    const GuidanceItem(
      id: 'guidance_legal_prep',
      category: 'legal',
      titleFr: 'Consulter les options d’information juridique',
      titleAr: 'الاطلاع على الخيارات والمعلومات القانونية',
      textFr:
          'Gardez trace des éléments factuels (dates, écrits, faits) en vue de consultations juridiques ultérieures si vous le souhaitez.',
      textAr:
          'احتفظ بتدوين إرشادي للوقائع والتواريخ لاستخدامها في الاستشارات القانونية المستقبلي عند الحاجة.',
      minSeverity: ViolenceSeverity.level2Vigilance,
    ),
    const GuidanceItem(
      id: 'guidance_resources',
      category: 'resources',
      titleFr: 'Consulter les ressources et guides disponibles',
      titleAr: 'الاطلاع على الموارد والدلائل المتاحة',
      textFr:
          'Accédez aux fiches d’information et exercices de sécurité pour mieux appréhender et gérer la situation.',
      textAr:
          'تصفح البطاقات التوجيهية وتطبيقات السلامة لفهم الوضعية والتعامل معها بوعي.',
      minSeverity: ViolenceSeverity.level1Preoccupante,
    ),
  ];

  const InitialGuidanceEngine();

  List<GuidanceItem> generateGuidance({
    required ViolenceSeverity severity,
    required List<ViolenceType> categories,
    required bool hasRedFlag,
  }) {
    final results = <GuidanceItem>[];

    for (final item in _configurableItems) {
      if (hasRedFlag && item.isEmergencyAction) {
        results.add(item);
        continue;
      }

      if (severity.index >= item.minSeverity.index) {
        results.add(item);
      }
    }

    return results;
  }

  static void addCustomGuidance(GuidanceItem item) {
    _configurableItems.removeWhere((existing) => existing.id == item.id);
    _configurableItems.add(item);
  }
}
