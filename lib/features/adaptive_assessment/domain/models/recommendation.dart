import 'assessment_axis.dart';

enum RecommendationCategory {
  immediateAction,
  dailyHabit,
  socialSupport,
  professionalConsultation,
  spiritual,
  physicalActivity
}

class Recommendation {
  final String id;
  final String titleFr;
  final String titleAr;
  final String? titleDarja;
  final String descriptionFr;
  final String descriptionAr;
  final String? descriptionDarja;
  final AssessmentAxis axis;
  final RecommendationCategory category;
  final int priority;
  final Duration? estimatedDuration;
  final int difficulty; // 1 to 5

  const Recommendation({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    this.titleDarja,
    required this.descriptionFr,
    required this.descriptionAr,
    this.descriptionDarja,
    required this.axis,
    required this.category,
    this.priority = 0,
    this.estimatedDuration,
    this.difficulty = 1,
  });
}
