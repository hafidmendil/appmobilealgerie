import 'package:hive/hive.dart';
import '../../../features/adaptive_assessment/domain/models/assessment_axis.dart';

part 'content_models.g.dart';

@HiveType(typeId: 30)
class QuranVerseModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final int surahNumber;
  @HiveField(2)
  final int verseNumber;
  @HiveField(3)
  final String textAr;
  @HiveField(4)
  final String textFr;
  @HiveField(5)
  final String theme;
  @HiveField(6)
  final String? context;
  @HiveField(7)
  final String? reflection;
  @HiveField(8)
  final List<int> associatedAxesIndices;

  QuranVerseModel({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    required this.textAr,
    required this.textFr,
    required this.theme,
    this.context,
    this.reflection,
    this.associatedAxesIndices = const [],
  });
}

@HiveType(typeId: 31)
class HadithModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String collection;
  @HiveField(2)
  final String number;
  @HiveField(3)
  final String textAr;
  @HiveField(4)
  final String textFr;
  @HiveField(5)
  final String theme;
  @HiveField(6)
  final String? source;
  @HiveField(7)
  final List<int> associatedAxesIndices;

  HadithModel({
    required this.id,
    required this.collection,
    required this.number,
    required this.textAr,
    required this.textFr,
    required this.theme,
    this.source,
    this.associatedAxesIndices = const [],
  });
}
