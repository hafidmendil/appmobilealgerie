import '../../features/assessment/assessment_record.dart';

abstract class AssessmentRepository {
  Future<void> saveAssessment(AssessmentRecord record);
  Future<List<AssessmentRecord>> getAssessments(String? userId);
  Future<void> migrateGuestAssessments(String userId);
  Future<void> deleteAssessment(String id);
}
