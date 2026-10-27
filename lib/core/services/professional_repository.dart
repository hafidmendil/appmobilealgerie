import '../models/user_model.dart';
import '../../features/professional/models/access_request.dart';
import '../../features/professional/models/professional_profile.dart';
import '../../features/assessment/assessment_record.dart';
import '../../features/professional/models/session_request_model.dart';
import '../../features/professional/models/professional_model.dart';

abstract class ProfessionalRepository {
  Future<List<ProfessionalProfile>> getAllProfessionals();
  Future<List<ProfessionalModel>> getDirectoryProfessionals();
  Future<void> addProfessionalForMessaging({
    required String userId,
    required int professionalAccountId,
    String? message,
  });
  Future<void> sendRequest(AccessRequest request);
  Future<List<AccessRequest>> getRequestsForPsychologist(String professionalId);
  Future<List<AccessRequest>> getRequestsForUser(String userId);
  Future<void> respondToRequest(String requestId, AccessRequestStatus status);
  Future<List<UserModel>> getAuthorizedPatients(String professionalId);
  Future<UserModel?> getPatientById(String professionalId, String patientId);
  Future<List<AssessmentRecord>> getPatientAssessments(
    String professionalId,
    String patientId,
  );

  // Session / Appointment Management
  Future<void> submitSessionRequest(SessionRequestModel request);
  Future<List<SessionRequestModel>> getSessionRequests(String professionalId);
  Future<List<SessionRequestModel>> getSessionRequestsForUser(int userId);
  Future<void> updateSessionStatus(int sessionId, SessionRequestStatus status);
}
