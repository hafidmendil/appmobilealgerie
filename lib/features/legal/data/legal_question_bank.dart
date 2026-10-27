import '../domain/models/legal_models.dart';

class LegalQuestion {
  final String id;
  final String titleFr;
  final String titleAr;
  final String subtitleFr;
  final String subtitleAr;
  final List<LegalOption> options;
  final String? dependsOn;
  final List<String>? requiredValues;

  const LegalQuestion({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.subtitleFr,
    required this.subtitleAr,
    required this.options,
    this.dependsOn,
    this.requiredValues,
  });
}

class LegalOption {
  final String value;
  final String labelFr;
  final String labelAr;

  const LegalOption({
    required this.value,
    required this.labelFr,
    required this.labelAr,
  });
}

class LegalQuestionBank {
  static const List<LegalQuestion> questions = [
    LegalQuestion(
      id: 'nature_facts',
      titleFr: '1. Nature des faits déclarés',
      titleAr: '1. طبيعة الوقائع المصرح بها',
      subtitleFr: 'Sélectionnez la catégorie principale décrivant les événements.',
      subtitleAr: 'اختر الفئة الرئيسية التي تصف الوقائع.',
      options: [
        LegalOption(value: 'physical', labelFr: 'Violences physiques', labelAr: 'عنف جسدي'),
        LegalOption(value: 'harassment', labelFr: 'Harcèlement moral', labelAr: 'مضايقة نفسية'),
        LegalOption(value: 'cyber', labelFr: 'Cyber-violence', labelAr: 'عنف رقمي'),
        LegalOption(value: 'threats', labelFr: 'Menaces', labelAr: 'تهديدات'),
      ],
    ),
    LegalQuestion(
      id: 'digital_details',
      titleFr: '1 bis. Précisions sur l’espace numérique',
      titleAr: '1 مكرر. تفاصيل حول الفضاء الرقمي',
      subtitleFr: 'Quels outils ont été utilisés ?',
      subtitleAr: 'ما هي الوسائل المستخدمة؟',
      dependsOn: 'nature_facts',
      requiredValues: ['cyber'],
      options: [
        LegalOption(value: 'social_media', labelFr: 'Réseaux sociaux', labelAr: 'مواقع التواصل'),
        LegalOption(value: 'private_msg', labelFr: 'Messagerie privée', labelAr: 'رسائل خاصة'),
        LegalOption(value: 'other', labelFr: 'Autre', labelAr: 'وسائل أخرى'),
      ],
    ),
    // ... Additional professional questions here
  ];
}
