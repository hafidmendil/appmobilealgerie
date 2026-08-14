import 'assessment_axis.dart';

enum OrientationLevel {
  level1, // Soutien préventif
  level2, // Auto-accompagnement renforcé
  level3, // Il peut être utile de parler à un professionnel
  level4  // Besoin d'aide humaine rapide
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
