import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'legal_core_models.g.dart';

@HiveType(typeId: 112)
class LegalArticle extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String titleFr;
  @HiveField(2)
  final String titleAr;
  @HiveField(3)
  final String descriptionFr;
  @HiveField(4)
  final String descriptionAr;
  @HiveField(5)
  final String legalReference; // e.g., 'Code Pénal Algérien'
  @HiveField(6)
  final String articleReference; // e.g., 'Art 330'
  @HiveField(7)
  final String source; // url or official document ref
  @HiveField(8)
  final DateTime lastVerifiedAt;
  @HiveField(9)
  final LegalKnowledgeStatus status;
  @HiveField(10)
  final List<ViolenceType> applicableViolenceTypes;
  @HiveField(11)
  final String? procedureId; // Associated procedure if any

  LegalArticle({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.descriptionFr,
    required this.descriptionAr,
    required this.legalReference,
    required this.articleReference,
    required this.source,
    required this.lastVerifiedAt,
    required this.status,
    this.applicableViolenceTypes = const [],
    this.procedureId,
  });
}

@HiveType(typeId: 113)
class LegalProcedure extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String titleFr;
  @HiveField(2)
  final String titleAr;
  @HiveField(3)
  final String stepsFr;
  @HiveField(4)
  final String stepsAr;
  @HiveField(5)
  final InstitutionType competentAuthority;
  @HiveField(6)
  final DateTime lastVerifiedAt;

  LegalProcedure({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.stepsFr,
    required this.stepsAr,
    required this.competentAuthority,
    required this.lastVerifiedAt,
  });
}

@HiveType(typeId: 114)
class LegalGuidance extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String assessmentId;
  @HiveField(2)
  final List<String> potentialLegalClassifications; // e.g. ["Violences psychologiques", "Menaces"]
  @HiveField(3)
  final List<String> relevantLegalArticleIds;
  @HiveField(4)
  final List<String> possibleProcedureIds;
  @HiveField(5)
  final DateTime createdAt;

  LegalGuidance({
    required this.id,
    required this.assessmentId,
    required this.potentialLegalClassifications,
    required this.relevantLegalArticleIds,
    required this.possibleProcedureIds,
    required this.createdAt,
  });
}
