import 'assessment_axis.dart';

class QuranVerse {
  final String id;
  final int surahNumber;
  final int verseNumber;
  final String textAr;
  final String textFr;
  final String theme;
  final String? context;
  final String? reflection;
  final List<AssessmentAxis> associatedAxes;

  const QuranVerse({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    required this.textAr,
    required this.textFr,
    required this.theme,
    this.context,
    this.reflection,
    this.associatedAxes = const [],
  });
}
