import '../models/protection_models.dart';

abstract class ProtectionRepository {
  Future<void> saveReport(ViolenceReport report);
  Future<List<ViolenceReport>> getReports({String? userId});
  Future<void> deleteReport(String id);
  Future<void> saveRiskAssessment(RiskAssessment assessment);
  Future<RiskAssessment?> getRiskAssessment(String id);

  Future<void> saveAssessment(ViolenceAssessment assessment);
  Future<ViolenceAssessment?> getAssessment(String id);
  Future<List<ViolenceAssessment>> getAssessments({String? userId});
  Future<void> saveAssessmentResult(ViolenceAssessmentResult result);
  Future<ViolenceAssessmentResult?> getAssessmentResult(String id);
}
