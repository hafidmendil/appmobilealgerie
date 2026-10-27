import 'assessment_axis.dart';

enum OrientationLevel {
  level0, // Stable - Bien-être général
  level1, // Soutien préventif / Vigilance légère
  level2, // Auto-accompagnement renforcé / Consultation conseillée
  level3, // Besoin de support élevé / Contact professionnel recommandé
  level4, // Besoin de support immédiat / Aide urgente requise
}

class AssessmentResult {
  final String sessionId;
  final Map<AssessmentAxis, double> axisNeeds;
  final OrientationLevel orientationLevel;
  final List<String> identifiedThemes;
  final List<String> recommendationIds;
  final List<String> exerciseIds;
  final List<String> spiritualContentIds;
  final String? userFreeMessage;
  final DateTime createdAt;

  const AssessmentResult({
    required this.sessionId,
    required this.axisNeeds,
    required this.orientationLevel,
    required this.identifiedThemes,
    required this.recommendationIds,
    required this.exerciseIds,
    required this.spiritualContentIds,
    this.userFreeMessage,
    required this.createdAt,
  });
}
