import 'package:hive/hive.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import '../../domain/models/protection_models.dart';
import '../../domain/repositories/protection_repository.dart';

class HiveProtectionRepository implements ProtectionRepository {
  Box<dynamic> get _reports =>
      Hive.box<dynamic>(HiveConfig.protectionReportsBox);
  Box<dynamic> get _assessments =>
      Hive.box<dynamic>(HiveConfig.protectionRiskAssessmentsBox);
  Box<dynamic> get _violenceAssessments =>
      Hive.box<dynamic>(HiveConfig.violenceAssessmentsBox);

  @override
  Future<void> saveReport(ViolenceReport report) async {
    await _reports.put(report.id, {
      'id': report.id,
      'createdAt': report.createdAt.toIso8601String(),
      'updatedAt': report.updatedAt.toIso8601String(),
      'reporterMode': report.reporterMode.name,
      'violenceTypes': report.violenceTypes.map((value) => value.name).toList(),
      'contextType': report.contextType.name,
      'occurrencePattern': report.occurrencePattern.name,
      'riskAssessmentId': report.riskAssessmentId,
      'status': report.status.name,
      'consentVersion': report.consentVersion,
      'confidentialityLevel': report.confidentialityLevel,
      'userId': report.reporterMode == ReporterMode.anonymous
          ? null
          : report.userId,
      'approximateDate': report.approximateDate?.toIso8601String(),
      'approximateLocation': report.approximateLocation,
      'description': report.description,
      'victimAgeGroup': report.victimAgeGroup,
      'relationshipToAuthor': report.relationshipToAuthor,
      'preferredReferralType': report.preferredReferralType,
      'attachmentReferences': report.attachmentReferences,
      'assignedProfessionalId': report.assignedProfessionalId,
      'closedAt': report.closedAt?.toIso8601String(),
      'closureReason': report.closureReason,
    });
  }

  @override
  Future<List<ViolenceReport>> getReports({String? userId}) async {
    return _reports.values
        .whereType<Map>()
        .map((value) => _reportFromMap(Map<String, dynamic>.from(value)))
        .where((report) => userId == null || report.userId == userId)
        .toList();
  }

  @override
  Future<void> deleteReport(String id) => _reports.delete(id);

  @override
  Future<void> saveRiskAssessment(RiskAssessment assessment) async {
    await _assessments.put(assessment.id, {
      'id': assessment.id,
      'reportId': assessment.reportId,
      'assessedAt': assessment.assessedAt.toIso8601String(),
      'level': assessment.level.name,
      'factors': assessment.factors,
      'emergencyFlags': assessment.emergencyFlags,
      'recommendedActions': assessment.recommendedActions,
      'engineVersion': assessment.engineVersion,
      'assessedBy': assessment.assessedBy,
      'humanReviewRequired': assessment.humanReviewRequired,
    });
  }

  @override
  Future<RiskAssessment?> getRiskAssessment(String id) async {
    final value = _assessments.get(id);
    if (value is! Map) return null;
    final map = Map<String, dynamic>.from(value);
    return RiskAssessment(
      id: map['id'] as String,
      reportId: map['reportId'] as String,
      assessedAt: DateTime.parse(map['assessedAt'] as String),
      level: RiskLevel.values.byName(map['level'] as String),
      factors: List<String>.from(map['factors'] as List),
      emergencyFlags: List<String>.from(map['emergencyFlags'] as List),
      recommendedActions: List<String>.from(map['recommendedActions'] as List),
      engineVersion: map['engineVersion'] as String,
      assessedBy: map['assessedBy'] as String,
      humanReviewRequired: map['humanReviewRequired'] as bool,
    );
  }

  @override
  Future<void> saveAssessment(ViolenceAssessment assessment) async {
    await _violenceAssessments.put(
      'assessment_${assessment.id}',
      assessment.toJson(),
    );
  }

  @override
  Future<ViolenceAssessment?> getAssessment(String id) async {
    final val = _violenceAssessments.get('assessment_$id');
    if (val is! Map) return null;
    return ViolenceAssessment.fromJson(Map<String, dynamic>.from(val));
  }

  @override
  Future<List<ViolenceAssessment>> getAssessments({String? userId}) async {
    return _violenceAssessments.values
        .whereType<Map>()
        .map(
          (map) => ViolenceAssessment.fromJson(Map<String, dynamic>.from(map)),
        )
        .where((assessment) => userId == null || assessment.userId == userId)
        .toList();
  }

  @override
  Future<void> saveAssessmentResult(ViolenceAssessmentResult result) async {
    await _violenceAssessments.put('result_${result.id}', result.toJson());
  }

  @override
  Future<ViolenceAssessmentResult?> getAssessmentResult(String id) async {
    final val = _violenceAssessments.get('result_$id');
    if (val is! Map) return null;
    return ViolenceAssessmentResult.fromJson(Map<String, dynamic>.from(val));
  }

  ViolenceReport _reportFromMap(Map<String, dynamic> map) => ViolenceReport(
    id: map['id'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    updatedAt: DateTime.parse(map['updatedAt'] as String),
    reporterMode: ReporterMode.values.byName(map['reporterMode'] as String),
    violenceTypes: (map['violenceTypes'] as List)
        .map((value) => ViolenceType.values.byName(value as String))
        .toList(),
    contextType: ContextType.values.byName(map['contextType'] as String),
    occurrencePattern: OccurrencePattern.values.byName(
      map['occurrencePattern'] as String,
    ),
    riskAssessmentId: map['riskAssessmentId'] as String?,
    status: ProtectionReportStatus.values.byName(map['status'] as String),
    consentVersion: map['consentVersion'] as String,
    confidentialityLevel: map['confidentialityLevel'] as String,
    userId: map['userId'] as String?,
    approximateDate: _date(map['approximateDate']),
    approximateLocation: map['approximateLocation'] as String?,
    description: map['description'] as String?,
    victimAgeGroup: map['victimAgeGroup'] as String?,
    relationshipToAuthor: map['relationshipToAuthor'] as String?,
    preferredReferralType: map['preferredReferralType'] as String?,
    attachmentReferences: List<String>.from(
      map['attachmentReferences'] as List,
    ),
    assignedProfessionalId: map['assignedProfessionalId'] as String?,
    closedAt: _date(map['closedAt']),
    closureReason: map['closureReason'] as String?,
  );

  DateTime? _date(Object? value) =>
      value is String ? DateTime.tryParse(value) : null;
}
