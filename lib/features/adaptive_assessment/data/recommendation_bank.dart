import '../domain/models/assessment_axis.dart';
import '../domain/models/recommendation.dart';

class RecommendationBank {
  static const List<Recommendation> recommendations = [
    Recommendation(
      id: "R_STRESS_01",
      titleFr: "Pause respiratoire",
      titleAr: "استراحة تنفس",
      titleDarja: "ريح شوية واتنفس",
      descriptionFr: "Prends 5 minutes pour fermer les yeux et respirer profondément.",
      descriptionAr: "خذ 5 دقائق لإغلاق عينيك والتنفس بعمق.",
      descriptionDarja: "غمض عينيك وريح 5 دقايق واتنفس بالعقل.",
      axis: AssessmentAxis.stressAnxiety,
      category: RecommendationCategory.immediateAction,
      priority: 10,
    ),
    Recommendation(
      id: "R_SLEEP_01",
      titleFr: "Routine du soir",
      titleAr: "روتين المساء",
      titleDarja: "روتين تاع الليل",
      descriptionFr: "Évite les écrans 30 minutes avant de dormir.",
      descriptionAr: "تجنب الشاشات قبل النوم بـ 30 دقيقة.",
      descriptionDarja: "نقص التلفون نص ساعة قبل ما ترقد.",
      axis: AssessmentAxis.sleepEnergy,
      category: RecommendationCategory.dailyHabit,
      priority: 8,
    ),
    // ... more recommendations ...
  ];
}
