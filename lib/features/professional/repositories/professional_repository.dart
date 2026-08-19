import '../../../core/api/api_client.dart';
import '../models/professional_model.dart';
import '../models/center_model.dart';
import '../models/wilaya_model.dart';
import '../models/session_request_model.dart';

class ProfessionalRepository {
  final ApiClient apiClient;

  ProfessionalRepository({required this.apiClient});

  Future<List<WilayaModel>> getWilayas() async {
    final response = await apiClient.get('/wilayas');
    return (response as List).map((json) => WilayaModel.fromJson(json)).toList();
  }

  Future<List<ProfessionalModel>> searchProfessionals({required int wilayaId}) async {
    final response = await apiClient.get('/professionals?wilaya_id=$wilayaId&verification_status=VERIFIED&is_active=1');
    return (response as List).map((json) => ProfessionalModel.fromJson(json)).toList();
  }

  Future<List<CenterModel>> searchCenters({required int wilayaId}) async {
    final response = await apiClient.get('/centers?wilaya_id=$wilayaId&verification_status=VERIFIED&is_active=1');
    return (response as List).map((json) => CenterModel.fromJson(json)).toList();
  }

  Future<SessionRequestModel> submitSessionRequest(SessionRequestModel request) async {
    final response = await apiClient.post('/session-requests', request.toJson());
    return SessionRequestModel.fromJson(response);
  }

  Future<List<SessionRequestModel>> getUserRequests(int userId) async {
    final response = await apiClient.get('/session-requests/user/$userId');
    return (response as List).map((json) => SessionRequestModel.fromJson(json)).toList();
  }
  
  Future<void> updateRequestStatus(int requestId, SessionRequestStatus status) async {
    await apiClient.post('/session-requests/$requestId/status', {'status': status.name});
  }
}
