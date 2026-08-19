import 'package:projetmascara/features/health/models/health_knowledge_item.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';

class EducationalRecommendationEngine {
  static List<String> getHealthRecommendations(
    Map<QuestionModule, int> moduleScores,
    List<HealthKnowledgeItem> allItems,
  ) {
    final recommendations = <String>[];

    // Simple mapping: if stress is high, recommend lifestyle/sleep articles
    if ((moduleScores[QuestionModule.stress] ?? 0) >= 3) {
      recommendations.addAll(
        allItems.where((i) => i.category == HealthCategory.sleepHabits || i.category == HealthCategory.lifestyle)
                .map((i) => i.id)
      );
    }

    // If nutrition/health module was high in assessment (if we add one)
    // For now, recommend general nutrition if wellbeing is low
    if ((moduleScores[QuestionModule.wellbeing] ?? 0) >= 3) {
      recommendations.addAll(
        allItems.where((i) => i.category == HealthCategory.nutrition)
                .map((i) => i.id)
      );
    }

    return recommendations.toSet().toList().take(3).toList();
  }
}
