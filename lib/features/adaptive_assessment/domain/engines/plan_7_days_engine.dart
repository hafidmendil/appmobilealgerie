import '../models/assessment_axis.dart';

class Plan7DaysEngine {
  Map<int, String> generatePlan(Map<AssessmentAxis, double> needs, String lang) {
    if (needs.isEmpty) return _getDefaultPlan(lang);

    final sortedAxis = needs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final primary = sortedAxis.first.key;

    return {
      1: _getTask(1, primary, lang),
      2: _getTask(2, primary, lang),
      3: _getTask(3, primary, lang),
      4: _getTask(4, primary, lang),
      5: _getTask(5, primary, lang),
      6: _getTask(6, primary, lang),
      7: _getTask(7, primary, lang),
    };
  }

  Map<int, String> _getDefaultPlan(String lang) {
    return {
      1: lang == 'fr' ? "Prendre un moment pour soi." : "تخصيص وقت للنفس.",
      2: lang == 'fr' ? "Observer ses pensées." : "مراقبة الأفكار.",
      3: lang == 'fr' ? "Respirer calmement." : "التنفس بهدوء.",
      4: lang == 'fr' ? "Sourire à quelqu'un." : "الابتسام لشخص ما.",
      5: lang == 'fr' ? "Écrire une gratitude." : "كتابة شيء ممتن له.",
      6: lang == 'fr' ? "Se reposer tôt." : "النوم مبكراً.",
      7: lang == 'fr' ? "Bilan positif." : "تقييم إيجابي.",
    };
  }

  String _getTask(int day, AssessmentAxis axis, String lang) {
    switch (axis) {
      case AssessmentAxis.stressAnxiety:
        return _getStressTask(day, lang);
      case AssessmentAxis.selfConfidence:
        return _getConfidenceTask(day, lang);
      default:
        return _getGeneralTask(day, lang);
    }
  }

  String _getStressTask(int day, String lang) {
    final tasksFr = [
      "Identifier un déclencheur de stress.",
      "Pratiquer 5 min de respiration.",
      "Prioriser 3 tâches seulement.",
      "Prendre une pause sans écran.",
      "Parler de sa tension à un proche.",
      "Faire une activité relaxante.",
      "Bilan : qu'est-ce qui m'a apaisé ?"
    ];
    final tasksAr = [
      "تحديد مسبب واحد للتوتر.",
      "ممارسة 5 دقائق تنفس.",
      "تحديد 3 مهام أساسية فقط.",
      "أخذ استراحة بدون شاشات.",
      "التحدث عن ضغطك لشخص مقرب.",
      "القيام بنشاط مريح.",
      "التقييم: ما الذي ساعدني على الهدوء؟"
    ];
    return lang == 'fr' ? tasksFr[day - 1] : tasksAr[day - 1];
  }

  String _getConfidenceTask(int day, String lang) {
    final tasksFr = [
      "Noter une petite réussite.",
      "Se dire une phrase positive.",
      "Identifier une de ses forces.",
      "Arrêter de se comparer aujourd'hui.",
      "Faire quelque chose qui rend fier.",
      "Accepter un compliment.",
      "Bilan : je suis capable de..."
    ];
    final tasksAr = [
      "تدوين نجاح صغير.",
      "قول جملة إيجابية لنفسك.",
      "تحديد إحدى نقاط قوتك.",
      "التوقف عن المقارنة اليوم.",
      "القيام بشيء يجعلك فخوراً.",
      "قبول إطراء من شخص ما.",
      "التقييم: أنا قادر على..."
    ];
    return lang == 'fr' ? tasksFr[day - 1] : tasksAr[day - 1];
  }

  String _getGeneralTask(int day, String lang) {
    final tasksFr = [
      "Observer son humeur du jour.",
      "Boire assez d'eau et bien manger.",
      "Marcher 15 minutes.",
      "Appeler un ami.",
      "Écrire ses pensées.",
      "Se coucher à une heure fixe.",
      "Planifier un moment de joie demain."
    ];
    final tasksAr = [
      "مراقبة مزاجك اليوم.",
      "شرب الماء الكافي وأكل جيد.",
      "المشي لمدة 15 دقيقة.",
      "الاتصال بصديق.",
      "كتابة الأفكار.",
      "النوم في وقت محدد.",
      "التخطيط للحظة فرح غداً."
    ];
    return lang == 'fr' ? tasksFr[day - 1] : tasksAr[day - 1];
  }
}
