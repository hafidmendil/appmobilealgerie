import 'package:projetmascara/features/assessment/assessment_models.dart';
import 'package:projetmascara/features/content/quran_library.dart';
import 'package:projetmascara/features/content/hadith_library.dart';
import 'package:projetmascara/features/content/hikma_library.dart';
import 'package:projetmascara/features/content/resource_library.dart';
import 'package:projetmascara/features/content/micro_action_library.dart';
import 'package:projetmascara/features/engine/free_text_analysis_model.dart';
import 'package:projetmascara/features/engine/understanding_engine.dart';

class ResourceRecommendationEngine {
  static List<OrientationRecommendation> getRecommendations(
    OrientationResult result,
    Map<String, int> answers,
    Map<QuestionModule, int> moduleScores,
    String? finalMessage,
  ) {
    final recommendations = <OrientationRecommendation>[];
    final isSpiritualAllowed = answers['pref_spiritual'] == 1;

    // Analyze free text if available
    FreeTextAnalysis? analysis;
    if (finalMessage != null && finalMessage.isNotEmpty) {
      analysis = UnderstandingEngine.analyze(finalMessage, spiritualEnabled: isSpiritualAllowed);
    }

    // 1. Safety Recommendations
    if (result.isRedFlagTriggered) {
      recommendations.add(OrientationRecommendation(
        titleKey: 'summary_urgent_help',
        descriptionKey: 'rec_safety_protocol',
        isEmergency: true,
        resourceIds: ['res_emergency_services'],
      ));
      return recommendations;
    }

    // 2. Psychological & Practical Recommendations
    final combinedDomains = {...moduleScores.keys};
    if (analysis != null) {
      combinedDomains.addAll(analysis.identifiedDomains);
    }

    for (final module in combinedDomains) {
      final score = moduleScores[module] ?? 0;
      final isIdentifiedInText = analysis?.identifiedDomains.contains(module) ?? false;

      if (score >= 3 || isIdentifiedInText) {
        // Find psychological resources for this module
        final psychologicalRes = psychologicalResources
            .where((r) => r.domain == module)
            .map((r) => r.id)
            .toList();

        if (psychologicalRes.isNotEmpty) {
          recommendations.add(OrientationRecommendation(
            titleKey: 'rec_title_$module',
            descriptionKey: isIdentifiedInText ? 'rec_desc_text_$module' : 'rec_desc_$module',
            resourceIds: psychologicalRes,
          ));
        }

        // Add Spiritual context if allowed
        if (isSpiritualAllowed) {
          final verses = quranLibrary
              .where((v) => v.associatedDomains.contains(module))
              .map((v) => v.id)
              .toList();
          
          final hadiths = hadithLibrary
              .where((h) => h.associatedDomains.contains(module))
              .map((h) => h.id)
              .toList();
          
          final hikmas = hikmaLibrary
              .where((hik) => hik.associatedDomains.contains(module))
              .map((hik) => hik.id)
              .toList();

          if (verses.isNotEmpty || hadiths.isNotEmpty || hikmas.isNotEmpty) {
            recommendations.add(OrientationRecommendation(
              titleKey: 'rec_spiritual_title_$module',
              descriptionKey: 'rec_spiritual_desc_$module',
              resourceIds: [...verses, ...hadiths, ...hikmas],
            ));
          }
        }
      }
    }

    // 3. Micro-actions
    final applicableActions = microActions
        .where((a) => moduleScores[a.domain] != null && moduleScores[a.domain]! >= 2)
        .map((a) => a.id)
        .toList();

    if (applicableActions.isNotEmpty) {
      recommendations.add(OrientationRecommendation(
        titleKey: 'rec_actions_title',
        descriptionKey: 'rec_actions_desc',
        resourceIds: applicableActions.take(3).toList(),
      ));
    }

    // 4. Fallback
    if (recommendations.isEmpty) {
      recommendations.add(OrientationRecommendation(
        titleKey: 'level1Title',
        descriptionKey: 'summary_self_care',
        resourceIds: ['res_general_wellness'],
      ));
    }

    return recommendations;
  }
}
