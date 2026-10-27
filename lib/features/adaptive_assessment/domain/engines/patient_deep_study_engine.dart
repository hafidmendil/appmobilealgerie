import 'package:projetmascara/generated/l10n/app_localizations.dart';
import '../models/assessment_result.dart';
import '../models/assessment_axis.dart';

class PatientDeepStudyEngine {
  String generateDetailedAnalysis(AssessmentResult result, AppLocalizations l10n, bool isAr) {
    final buffer = StringBuffer();

    // 1. Introduction structurelle
    buffer.writeln(isAr ? "التحليل البنيوي للحالة النفسية:" : "Analyse structurelle de l'état psychologique :");
    buffer.writeln("--------------------------------");

    // 2. Analyse des axes dominants
    final sortedNeeds = result.axisNeeds.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sortedNeeds.take(3)) {
      if (entry.value > 0.4) {
        buffer.writeln(_getAxisDetailedAnalysis(entry.key, entry.value, isAr));
      }
    }

    // 3. Recommandations de développement psychologique
    buffer.writeln("\n" + (isAr ? "خطوات لتطوير الحالة النفسية للأفضل:" : "Étapes pour développer l'état psychologique vers le mieux-être :"));
    
    if (result.axisNeeds[AssessmentAxis.stressAnxiety]! > 0.5) {
      buffer.writeln(isAr 
        ? "- البدء في ممارسة التنفس الواعي (4-7-8) يومياً لخفض الاستثارة العصبية."
        : "- Pratiquer la respiration consciente (4-7-8) quotidiennement pour réduire l'excitabilité nerveuse.");
    }
    
    if (result.axisNeeds[AssessmentAxis.selfConfidence]! > 0.4) {
      buffer.writeln(isAr
        ? "- تدوين ثلاثة إنجازات يومية، مهما كانت بسيطة، لتعزيز التقدير الذاتي."
        : "- Noter trois réussites quotidiennes, même minimes, pour renforcer l'estime de soi.");
    }

    if (result.axisNeeds[AssessmentAxis.socialSupport]! > 0.5) {
      buffer.writeln(isAr
        ? "- البحث عن بيئات اجتماعية إيجابية أو التواصل مع شخص موثوق لكسر العزلة."
        : "- Rechercher des environnements sociaux positifs ou contacter une personne de confiance pour briser l'isolement.");
    }

    return buffer.toString();
  }

  String _getAxisDetailedAnalysis(AssessmentAxis axis, double score, bool isAr) {
    switch (axis) {
      case AssessmentAxis.stressAnxiety:
        return isAr 
          ? "• محور الضغط: مستوى الاستثارة العصبية مرتفع، مما قد يؤدي إلى استنزاف طاقي سريع."
          : "• Axe Stress : Niveau d'excitabilité nerveuse élevé, pouvant mener à un épuisement énergétique rapide.";
      case AssessmentAxis.selfConfidence:
        return isAr
          ? "• محور الثقة: هشاشة في التقدير الذاتي تتطلب عملاً على قبول الذات والتعاطف معها."
          : "• Axe Confiance : Fragilité de l'estime de soi nécessitant un travail sur l'acceptation et la compassion envers soi-même.";
      case AssessmentAxis.sleepEnergy:
        return isAr
          ? "• محور النوم: اضطراب في الدورات البيولوجية يؤثر مباشرة على القدرة على التنظيم الانفعالي."
          : "• Axe Sommeil : Perturbation des cycles biologiques impactant directement la régulation émotionnelle.";
      default:
        return "";
    }
  }
}
