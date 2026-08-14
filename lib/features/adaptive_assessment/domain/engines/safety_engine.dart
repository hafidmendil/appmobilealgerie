import '../models/assessment_question.dart';
import '../../data/question_bank.dart';

enum SafetyStatus {
  none,
  attention,
  supportRecommended,
  urgentSupport
}

class SafetyEngine {
  /// Analyzes the current answers and determines the safety status.
  SafetyStatus determineSafetyStatus(Map<String, int?> answers) {
    int highSafetyTriggers = 0;
    int mediumSafetyTriggers = 0;

    for (var entry in answers.entries) {
      final questionId = entry.key;
      final answerValue = entry.value;

      if (answerValue == null) continue;

      final question = QuestionBank.questions.firstWhere(
        (q) => q.id == questionId,
        orElse: () => throw Exception('Question $questionId not found in bank'),
      );

      final option = question.options.firstWhere(
        (o) => o.value == answerValue,
        orElse: () => const AssessmentOption(textFr: '', textAr: ''),
      );

      if (option.isSafetyTrigger) {
        if (question.safetyLevel == SafetyLevel.high || question.safetyLevel == SafetyLevel.urgent) {
          highSafetyTriggers++;
        } else if (question.safetyLevel == SafetyLevel.medium) {
          mediumSafetyTriggers++;
        }
      }
    }

    if (highSafetyTriggers > 0) return SafetyStatus.urgentSupport;
    if (mediumSafetyTriggers >= 2) return SafetyStatus.supportRecommended;
    if (mediumSafetyTriggers == 1) return SafetyStatus.attention;
    
    return SafetyStatus.none;
  }

  /// Checks if any safety trigger has been activated that justifies stopping.
  bool isSafetyTriggered(Map<String, int?> answers) {
    return determineSafetyStatus(answers) == SafetyStatus.urgentSupport;
  }

  /// Provides an immediate safety message based on the status and language.
  String getSafetyMessage(SafetyStatus status, String langCode) {
    if (status == SafetyStatus.none) return "";

    switch (langCode) {
      case 'ar':
        return status == SafetyStatus.urgentSupport
            ? "لقد لاحظنا بعض الإشارات التي تشير إلى أنك قد تحتاج إلى دعم فوري. من المهم جداً أن تتواصل مع شخص تثق به أو مع المصالح المختصة."
            : "يبدو أنك تمر بفترة صعبة. نحن هنا لدعمك.";
      case 'darja':
        return status == SafetyStatus.urgentSupport
            ? "شفنا بلي راك محتاج مساعدة دركا. بزاف مهم تهدر مع واحد توثق فيه ولا تتصل بالحماية المدنية ولا طبيب."
            : "باين بلي راك تجوز في وقت واعر. رانا هنا باش نعاونوك.";
      case 'fr':
      default:
        return status == SafetyStatus.urgentSupport
            ? "Nous avons remarqué des signaux indiquant que vous pourriez avoir besoin d'un soutien immédiat. Il est très important de contacter une personne de confiance ou les services appropriés."
            : "Il semble que tu traverses une période difficile. Nous sommes là pour t'accompagner.";
    }
  }
}
