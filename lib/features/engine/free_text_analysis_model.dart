import '../assessment/assessment_models.dart';

enum DeclaredState {
  calm,
  stress,
  anxious,
  sad,
  isolated,
  familyConflict,
  socialDifficulty,
  lackOfMotivation,
  overload,
  academicDifficulty,
  professionalDifficulty,
  relationalProblem,
  relationalConflict,
  isolation,
  seekingMeaning,
  needSupport,
  needOrientation,
  urgentSituation,
  medicalCondition,
  alreadyFollowed
}

class FreeTextAnalysis {
  final List<QuestionModule> identifiedDomains;
  final List<DeclaredState> identifiedStates;
  final List<String> identifiedConcerns;
  final bool spiritualPreference;
  final String? wilaya;
  final bool safetyFlag;
  final double confidence;
  final String rawText;
  final DateTime analyzedAt;
  final String source = "User Declaration";

  FreeTextAnalysis({
    required this.identifiedDomains,
    required this.identifiedStates,
    required this.identifiedConcerns,
    this.spiritualPreference = false,
    this.wilaya,
    this.safetyFlag = false,
    this.confidence = 1.0,
    required this.rawText,
    required this.analyzedAt,
  });
}

class Hikma {
  final String id;
  final String textAr;
  final String textFr;
  final String? authorAr;
  final String? authorFr;
  final List<QuestionModule> associatedDomains;
  final List<DeclaredState> associatedStates;
  final String? contextFr;
  final String? contextAr;

  Hikma({
    required this.id,
    required this.textAr,
    required this.textFr,
    this.authorAr,
    this.authorFr,
    required this.associatedDomains,
    this.associatedStates = const [],
    this.contextFr,
    this.contextAr,
  });
}
