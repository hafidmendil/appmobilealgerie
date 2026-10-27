import '../models/legal_models.dart';

class ProcedureRecommendationEngine {
  /// Recommends procedural options purely based on declared legal facts and candidate categories.
  /// NEVER relies solely on psychological scores.
  List<LegalProcedure> recommendProcedures({
    required Map<String, dynamic> declaredFacts,
    required List<LegalCategory> candidateCategories,
    required List<LegalArticle> applicableArticles,
    required List<LegalProcedure> availableProcedures,
  }) {
    final recommended = <LegalProcedure>[];
    final categoryIds = candidateCategories.map((c) => c.id).toSet();

    // Check emergency flags from declared facts
    final isEmergency =
        declaredFacts['threats'] == 'death_threats_weapon' ||
        declaredFacts['situation_current'] == 'immediate_danger' ||
        declaredFacts['consequences'] == 'severe_physical_injuries';

    // 1. If emergency, prioritize immediate emergency procedure
    if (isEmergency) {
      final emergencyProc = availableProcedures
          .where((p) => p.isEmergency)
          .toList();
      recommended.addAll(emergencyProc);
    }

    // 2. Map procedures associated with applicable articles
    for (final article in applicableArticles) {
      if (article.statutValidation != ValidationStatus.validated) continue;
      for (final procId in article.proceduresAssociees) {
        final found = availableProcedures.where((p) => p.id == procId);
        for (final p in found) {
          if (!recommended.any((existing) => existing.id == p.id)) {
            recommended.add(p);
          }
        }
      }
    }

    // 3. Child protection specific check
    if (categoryIds.contains('cat_protection_mineur') ||
        declaredFacts['context'] == 'minor_involved' ||
        declaredFacts['person_age_group'] == 'minor' ||
        declaredFacts['child_exposure'] == 'yes') {
      final emergencyProc = availableProcedures.where(
        (p) => p.id == 'proc_urgence_signalement',
      );
      for (final p in emergencyProc) {
        if (!recommended.any((existing) => existing.id == p.id)) {
          recommended.add(p);
        }
      }
    }

    // 4. Fallback to standard complaint & legal assistance if nothing matched
    if (recommended.isEmpty) {
      final stdProcedures = availableProcedures
          .where((p) => !p.isEmergency)
          .toList();
      recommended.addAll(stdProcedures);
    }

    return recommended;
  }
}
