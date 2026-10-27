import 'package:hive/hive.dart';

part 'health_knowledge_item.g.dart';

@HiveType(typeId: 20)
enum EvidenceLevel {
  @HiveField(0)
  traditionalSource,
  @HiveField(1)
  religiousSource,
  @HiveField(2)
  academicResearch,
  @HiveField(3)
  clinicalEvidence,
  @HiveField(4)
  review,
  @HiveField(5)
  uncertain,
}

@HiveType(typeId: 21)
enum HealthCategory {
  @HiveField(0)
  nutrition,
  @HiveField(1)
  lifestyle,
  @HiveField(2)
  islamicNutrition,
  @HiveField(3)
  propheticMedicine,
  @HiveField(4)
  traditionalPlants,
  @HiveField(5)
  physicalWellbeing,
  @HiveField(6)
  psychologicalWellbeing,
  @HiveField(7)
  sleepHabits,
  @HiveField(8)
  prevention,
  @HiveField(9)
  scientificResearch,
  @HiveField(10)
  sources,
}

@HiveType(typeId: 22)
class HealthKnowledgeItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String arabicTitle;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final HealthCategory category;

  @HiveField(5)
  final String? author;

  @HiveField(6)
  final String? source;

  @HiveField(7)
  final int? publicationYear;

  @HiveField(8)
  final String? sourceUrl;

  @HiveField(9)
  final EvidenceLevel evidenceLevel;

  @HiveField(10)
  final String? scientificSummary;

  @HiveField(11)
  final String? traditionalContext;

  @HiveField(12)
  final List<String> benefits;

  @HiveField(13)
  final List<String> limitations;

  @HiveField(14)
  final List<String> warnings;

  @HiveField(15)
  final List<String> references;

  @HiveField(16)
  final String language;

  @HiveField(17)
  final DateTime createdAt;

  @HiveField(18)
  final DateTime updatedAt;

  @HiveField(19)
  final String? sourceStatus;

  HealthKnowledgeItem({
    required this.id,
    required this.title,
    required this.arabicTitle,
    required this.description,
    required this.category,
    this.author,
    this.source,
    this.publicationYear,
    this.sourceUrl,
    required this.evidenceLevel,
    this.scientificSummary,
    this.traditionalContext,
    this.benefits = const [],
    this.limitations = const [],
    this.warnings = const [],
    this.references = const [],
    this.language = 'fr',
    required this.createdAt,
    required this.updatedAt,
    this.sourceStatus = 'UNVERIFIED',
  });

  factory HealthKnowledgeItem.fromJson(Map<String, dynamic> json) {
    return HealthKnowledgeItem(
      id: json['id'],
      title: json['title'],
      arabicTitle: json['arabicTitle'],
      description: json['description'],
      category: HealthCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => HealthCategory.nutrition,
      ),
      author: json['author'],
      source: json['source'],
      publicationYear: json['publicationYear'],
      sourceUrl: json['sourceUrl'],
      evidenceLevel: EvidenceLevel.values.firstWhere(
        (e) => e.name == json['evidenceLevel'],
        orElse: () => EvidenceLevel.uncertain,
      ),
      scientificSummary: json['scientificSummary'],
      traditionalContext: json['traditionalContext'],
      benefits: List<String>.from(json['benefits'] ?? []),
      limitations: List<String>.from(json['limitations'] ?? []),
      warnings: List<String>.from(json['warnings'] ?? []),
      references: List<String>.from(json['references'] ?? []),
      language: json['language'] ?? 'fr',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sourceStatus: json['sourceStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicTitle': arabicTitle,
      'description': description,
      'category': category.name,
      'author': author,
      'source': source,
      'publicationYear': publicationYear,
      'sourceUrl': sourceUrl,
      'evidenceLevel': evidenceLevel.name,
      'scientificSummary': scientificSummary,
      'traditionalContext': traditionalContext,
      'benefits': benefits,
      'limitations': limitations,
      'warnings': warnings,
      'references': references,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sourceStatus': sourceStatus,
    };
  }
}
