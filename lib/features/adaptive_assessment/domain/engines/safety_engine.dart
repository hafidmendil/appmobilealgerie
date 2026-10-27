import '../models/assessment_question.dart';
import '../../data/question_bank.dart';

enum SafetyStatus { none, attention, supportRecommended, urgentSupport }

class SafetyDecision {
  final SafetyStatus status;
  final String messageFr;
  final String messageAr;
  final bool shouldStopAssessment;
  final bool isNonDiagnostic;

  const SafetyDecision({
    required this.status,
    required this.messageFr,
    required this.messageAr,
    required this.shouldStopAssessment,
    this.isNonDiagnostic = true,
  });
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
        if (question.safetyLevel == SafetyLevel.high ||
            question.safetyLevel == SafetyLevel.urgent) {
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

  SafetyDecision evaluate(Map<String, int?> answers, {String locale = 'fr'}) {
    final status = determineSafetyStatus(answers);
    final shouldStop = status == SafetyStatus.urgentSupport;

    if (status == SafetyStatus.none) {
      return SafetyDecision(
        status: SafetyStatus.none,
        messageFr: '',
        messageAr: '',
        shouldStopAssessment: false,
      );
    }

    final messageFr = status == SafetyStatus.urgentSupport
        ? 'Vos réponses indiquent des signaux qui peuvent justifier un soutien immédiat. Ce questionnaire ne constitue pas un diagnostic. Consultez une personne de confiance, un professionnel qualifié ou les services d’urgence si nécessaire.'
        : 'Vos réponses montrent des indicateurs qui méritent une attention particulière. Ce questionnaire ne constitue pas un diagnostic et ne remplace pas l’évaluation d’un professionnel qualifié.';

    final messageAr = status == SafetyStatus.urgentSupport
        ? 'تشير إجاباتك إلى مؤشرات قد تستدعي دعمًا فوريًا. هذا الاستبيان لا يشكل تشخيصًا. تحدث إلى شخص تثق به أو إلى مختص مؤهل أو إلى خدمات الطوارئ عند الضرورة.'
        : 'تشير إجاباتك إلى مؤشرات تستحق اهتمامًا خاصًا. هذا الاستبيان لا يشكل تشخيصًا ولا يحل محل تقييم مختص مؤهل.';

    return SafetyDecision(
      status: status,
      messageFr: messageFr,
      messageAr: messageAr,
      shouldStopAssessment: shouldStop,
    );
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
            ? "تشير إجاباتك إلى مؤشرات قد تستدعي دعمًا فوريًا. هذا الاستبيان لا يشكل تشخيصًا، ومن المهم التحدث إلى شخص تثق به أو إلى مختص مؤهل أو خدمات الطوارئ عند الضرورة."
            : "تشير إجاباتك إلى مؤشرات تستحق اهتمامًا خاصًا. هذا الاستبيان لا يشكل تشخيصًا ولا يحل محل تقييم مختص مؤهل.";
      case 'fr':
      default:
        return status == SafetyStatus.urgentSupport
            ? "Vos réponses indiquent des signaux qui peuvent justifier un soutien immédiat. Ce questionnaire ne constitue pas un diagnostic. Consultez une personne de confiance, un professionnel qualifié ou les services d’urgence si nécessaire."
            : "Vos réponses montrent des indicateurs qui méritent une attention particulière. Ce questionnaire ne constitue pas un diagnostic et ne remplace pas l’évaluation d’un professionnel qualifié.";
    }
  }
}
