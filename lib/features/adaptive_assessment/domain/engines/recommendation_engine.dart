import '../models/assessment_axis.dart';
import '../models/recommendation.dart';
import '../../data/recommendation_bank.dart';

class RecommendationEngine {
  List<Recommendation> getRecommendations(Map<AssessmentAxis, double> needs, int count) {
    final sortedAxes = needs.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final selected = <Recommendation>[];
    
    for (var entry in sortedAxes) {
      if (entry.value < 0.2) continue; // Ignore low needs

      final axisRecs = RecommendationBank.recommendations.where(
        (r) => r.axis == entry.key
      ).toList();

      // Add best recommendation for this axis
      if (axisRecs.isNotEmpty) {
        axisRecs.sort((a, b) => b.priority.compareTo(a.priority));
        selected.add(axisRecs.first);
      }

      if (selected.length >= count) break;
    }

    return selected;
  }
}
