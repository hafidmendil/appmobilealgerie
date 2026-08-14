import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';

abstract class ProfessionalRepository {
  Future<List<AccessRequest>> getRequestsForUser(String userId);
  Future<List<AccessRequest>> getRequestsForPsychologist(String psychologistId);
  Future<void> sendRequest({required String userId, required String professionalId});
  Future<void> respondToRequest(String requestId, AccessRequestStatus status); // accepted, rejected, revoked
  
  // New methods for Phase 2
  Future<List<UserModel>> getAuthorizedPatients(String psychologistId);
  Future<UserModel?> getPatientById(String psychologistId, String patientId);
  Future<List<AssessmentRecord>> getPatientAssessments(String psychologistId, String patientId);
  
  // Professional Directory
  Future<List<ProfessionalProfile>> getAllProfessionals();
}
