import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, UserRole role);
  Future<void> logout();
  Future<void> resetPassword(String email);
}

abstract class AssessmentRemoteDataSource {
  Future<List<AssessmentRecord>> fetchAssessments(String userId);
  Future<void> uploadAssessment(AssessmentRecord record);
}

abstract class ProfessionalRemoteDataSource {
  Future<List<AccessRequest>> fetchAccessRequests(String professionalId);
  Future<void> updateAccessRequest(AccessRequest request);
  Future<void> sendAccessRequest(AccessRequest request);
}
