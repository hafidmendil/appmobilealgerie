import 'assessment_axis.dart';

class Hikma {
  final String id;
  final String textAr;
  final String textFr;
  final String authorAr;
  final String authorFr;
  final List<AssessmentAxis> associatedAxes;
  final List<dynamic> associatedStates;
  final String? contextFr;

  const Hikma({
    required this.id,
    required this.textAr,
    required this.textFr,
    required this.authorAr,
    required this.authorFr,
    this.associatedAxes = const [],
    this.associatedStates = const [],
    this.contextFr,
  });
}
