import '../domain/engines/adaptive_protection_question_engine.dart';
import '../domain/models/protection_models.dart';

class ProtectionQuestionBank {
  static const List<ProtectionQuestion> questions = [
    ProtectionQuestion(
      id: 'currentDanger',
      textFr: 'Êtes-vous en danger immédiat en ce moment ?',
      textAr: 'هل أنت في خطر مباشر في الوقت الحالي؟',
      priority: 1000,
      isRedFlagCandidate: true,
    ),
    ProtectionQuestion(
      id: 'emprise',
      textFr: 'Avez-vous le sentiment d’être sous l’emprise psychologique d’un tiers (sentiment de peur constante, impossibilité de dire non) ?',
      textAr: 'هل تشعر بوقوعك تحت هيمنة نفسية من طرف آخر (خوف مستمر، عجز عن الرفض)؟',
      priority: 920,
      isRedFlagCandidate: true,
    ),
    ProtectionQuestion(
      id: 'dissociation',
      textFr: 'Ressentez-vous des moments d’absence ou de déconnexion de la réalité suite aux événements (dissociation) ?',
      textAr: 'هل تشعر بلحظات من الانفصال عن الواقع أو الشرود الذهني عقب الأحداث؟',
      priority: 890,
    ),
    ProtectionQuestion(
      id: 'reviviscences',
      textFr: 'Revivez-vous les scènes de manière forcée (flashbacks, cauchemars répétitifs) ?',
      textAr: 'هل تسترجع المشاهد بشكل قسري (ذكريات مقتحمة، كوابيس متكررة)؟',
      priority: 870,
    ),
    ProtectionQuestion(
      id: 'dangerousMeans',
      textFr: 'La personne menaçante a-t-elle accès à un moyen dangereux ou une arme ?',
      textAr: 'هل يمكن للشخص المهدد الوصول إلى وسيلة خطيرة أو سلاح؟',
      priority: 900,
      isRedFlagCandidate: true,
    ),
    ProtectionQuestion(
      id: 'confinement',
      textFr: 'Avez-vous été retenu(e) ou empêché(e) de quitter un lieu contre votre gré ?',
      textAr: 'هل تم احتجازك أو منعك من مغادرة مكان رغماً عنك؟',
      priority: 880,
      isRedFlagCandidate: true,
    ),
    ProtectionQuestion(
      id: 'physicalHarm',
      textFr: 'Y a-t-il eu des contacts physiques violents ou des blessures ?',
      textAr: 'هل حدث تلامس جسدي عنيف أو إصابات؟',
      priority: 850,
      isRedFlagCandidate: true,
    ),
    ProtectionQuestion(
      id: 'childAtRisk',
      textFr: 'Un enfant au sein du foyer est-il directement exposé ou menacé ?',
      textAr: 'هل هناك طفل داخل الأسرة معرض للخطر المباشر أو التهديد؟',
      priority: 800,
      isRedFlagCandidate: true,
      categories: {ViolenceType.childAbuse, ViolenceType.family},
    ),
    ProtectionQuestion(
      id: 'isolation',
      textFr: 'Cherche-t-on à vous isoler de vos proches ou à contrôler vos déplacements ?',
      textAr: 'هل هناك محاولة لعزلك عن أقاربك أو التحكم في تنقلاتك؟',
      priority: 700,
    ),
    ProtectionQuestion(
      id: 'digitalControl',
      textFr: 'Vos comptes ou appareils sont-ils surveillés sans votre accord ?',
      textAr: 'هل يتم مراقبة حساباتك أو أجهزتك دون موافقتك؟',
      priority: 600,
      categories: {ViolenceType.digital},
    ),
    ProtectionQuestion(
      id: 'financialDeprivation',
      textFr: 'Êtes-vous privé(e) de vos propres ressources financières ou documents d’identité ?',
      textAr: 'هل يتم حرمانك من مواردك المالية الخاصة أو وثائق هويتك؟',
      priority: 650,
      categories: {ViolenceType.economic},
    ),
  ];
}
