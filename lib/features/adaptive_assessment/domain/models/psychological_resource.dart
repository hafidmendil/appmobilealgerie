import 'assessment_axis.dart';

enum ResourceCategory {
  psychological,
  practical,
  spiritual,
  educational,
}

class PsychologicalResource {
  final String id;
  final String titleKey;
  final String contentKey;
  final String? descriptionKey;
  final String duration;
  final AssessmentAxis axis;
  final ResourceCategory type;
  final List<String>? tags;

  const PsychologicalResource({
    required this.id,
    required this.titleKey,
    required this.contentKey,
    this.descriptionKey,
    required this.duration,
    required this.axis,
    required this.type,
    this.tags,
  });
}
