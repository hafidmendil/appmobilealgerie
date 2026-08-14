import 'package:projetmascara/features/professional/models/access_request.dart';

abstract class AccessRepository {
  Future<List<AccessRequest>> getRequestsForProfessional(String professionalId);
  Future<List<AccessRequest>> getRequestsForUser(String userId);
  Future<void> createRequest(AccessRequest request);
  Future<void> updateRequestStatus(String requestId, AccessRequestStatus status);
  Future<bool> hasAccess(String userId, String professionalId);
}
