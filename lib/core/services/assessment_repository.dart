import 'package:projetmascara/features/assessment/assessment_record.dart';

abstract class AssessmentRepository {
  Future<List<AssessmentRecord>> getAssessments(String? userId);
  Future<void> saveAssessment(AssessmentRecord record);
  Future<void> syncAssessments(String userId);
  Future<void> migrateGuestAssessments(String userId);
}
