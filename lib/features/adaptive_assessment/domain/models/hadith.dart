import 'assessment_axis.dart';

class Hadith {
  final String id;
  final String collection;
  final String number;
  final String textAr;
  final String textFr;
  final String theme;
  final String? source;
  final List<AssessmentAxis> associatedAxes;

  const Hadith({
    required this.id,
    required this.collection,
    required this.number,
    required this.textAr,
    required this.textFr,
    required this.theme,
    this.source,
    this.associatedAxes = const [],
  });
}
