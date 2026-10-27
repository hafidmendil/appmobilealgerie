import 'assessment_axis.dart';
import 'domain_state.dart';

class Hikma {
  final String id;
  final String textFr;
  final String textAr;
  final String? authorFr;
  final String? authorAr;
  final List<AssessmentAxis> associatedAxes;
  final List<DeclaredState> associatedStates;

  const Hikma({
    required this.id,
    required this.textFr,
    required this.textAr,
    this.authorFr,
    this.authorAr,
    required this.associatedAxes,
    required this.associatedStates,
  });
}
