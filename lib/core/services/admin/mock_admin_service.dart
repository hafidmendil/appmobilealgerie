import '../../models/user_model.dart';
import '../../../features/adaptive_assessment/domain/models/assessment_question.dart';
import 'admin_repository.dart';

class MockAdminService implements AdminRepository {
  @override
  Future<Map<String, dynamic>> getGlobalStatistics() async => {};
  @override
  Future<List<UserModel>> getUsers() async => [];
  @override
  Future<List<UserModel>> getProfessionals() async => [];
  @override
  Future<void> updateProfessionalStatus(String userId, String status) async {}
  @override
  Future<void> updateUserStatus(String userId, String status) async {}

  @override
  Future<List<AssessmentQuestion>> getQuestions() async => [];
  @override
  Future<void> saveQuestion(AssessmentQuestion question) async {}
  @override
  Future<void> deleteQuestion(String id) async {}
  @override
  Future<void> resetAlgorithm() async {}
}
