import '../../models/user_model.dart';
import '../../../features/adaptive_assessment/domain/models/assessment_question.dart';

abstract class AdminRepository {
  Future<Map<String, dynamic>> getGlobalStatistics();
  Future<List<UserModel>> getUsers();
  Future<List<UserModel>> getProfessionals();
  Future<void> updateProfessionalStatus(String userId, String status);
  Future<void> updateUserStatus(String userId, String status);

  // Question Management
  Future<List<AssessmentQuestion>> getQuestions();
  Future<void> saveQuestion(AssessmentQuestion question);
  Future<void> deleteQuestion(String id);
  Future<void> resetAlgorithm();
}
