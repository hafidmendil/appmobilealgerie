import 'package:json_annotation/json_annotation.dart';

part 'health_knowledge_item.g.dart';

enum EvidenceLevel {
  @JsonValue('TRADITIONAL_SOURCE')
  traditionalSource,
  @JsonValue('RELIGIOUS_SOURCE')
  religiousSource,
  @JsonValue('ACADEMIC_RESEARCH')
  academicResearch,
  @JsonValue('CLINICAL_EVIDENCE')
  clinicalEvidence,
  @JsonValue('REVIEW')
  review,
  @JsonValue('UNCERTAIN')
  uncertain,
}

enum HealthCategory {
  nutrition,
  lifestyle,
  islamicNutrition,
  propheticMedicine,
  traditionalPlants,
  physicalWellbeing,
  psychologicalWellbeing,
  sleepHabits,
  prevention,
  scientificResearch,
  sources,
}

@JsonSerializable(explicitToJson: true)
class HealthKnowledgeItem {
  final String id;
  final String title;
  final String arabicTitle;
  final String description;
  final HealthCategory category;
  final String? author;
  final String? source;
  final int? publicationYear;
  final String? sourceUrl;
  final EvidenceLevel evidenceLevel;
  final String? scientificSummary;
  final String? traditionalContext;
  final List<String> benefits;
  final List<String> limitations;
  final List<String> warnings;
  final List<String> references;
  final String language;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? sourceStatus; // 'VERIFIED', 'UNVERIFIED'

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

  factory HealthKnowledgeItem.fromJson(Map<String, dynamic> json) => _$HealthKnowledgeItemFromJson(json);
  Map<String, dynamic> toJson() => _$HealthKnowledgeItemToJson(this);

  HealthKnowledgeItem copyWith({
    String? title,
    String? arabicTitle,
    String? description,
    HealthCategory? category,
    String? author,
    String? source,
    int? publicationYear,
    String? sourceUrl,
    EvidenceLevel? evidenceLevel,
    String? scientificSummary,
    String? traditionalContext,
    List<String>? benefits,
    List<String>? limitations,
    List<String>? warnings,
    List<String>? references,
    String? language,
    DateTime? updatedAt,
    String? sourceStatus,
  }) {
    return HealthKnowledgeItem(
      id: id,
      title: title ?? this.title,
      arabicTitle: arabicTitle ?? this.arabicTitle,
      description: description ?? this.description,
      category: category ?? this.category,
      author: author ?? this.author,
      source: source ?? this.source,
      publicationYear: publicationYear ?? this.publicationYear,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      evidenceLevel: evidenceLevel ?? this.evidenceLevel,
      scientificSummary: scientificSummary ?? this.scientificSummary,
      traditionalContext: traditionalContext ?? this.traditionalContext,
      benefits: benefits ?? this.benefits,
      limitations: limitations ?? this.limitations,
      warnings: warnings ?? this.warnings,
      references: references ?? this.references,
      language: language ?? this.language,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceStatus: sourceStatus ?? this.sourceStatus,
    );
  }
}
