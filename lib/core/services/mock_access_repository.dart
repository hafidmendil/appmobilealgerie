import 'package:hive/hive.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/services/access_repository.dart';

class MockAccessRepository implements AccessRepository {
  static const String _boxName = 'access_requests';

  Future<Box<AccessRequest>> _getBox() async {
    return await Hive.openBox<AccessRequest>(_boxName);
  }

  @override
  Future<List<AccessRequest>> getRequestsForProfessional(String professionalId) async {
    final box = await _getBox();
    return box.values.where((r) => r.professionalId == professionalId).toList();
  }

  @override
  Future<List<AccessRequest>> getRequestsForUser(String userId) async {
    final box = await _getBox();
    return box.values.where((r) => r.userId == userId).toList();
  }

  @override
  Future<void> createRequest(AccessRequest request) async {
    final box = await _getBox();
    await box.put(request.id, request);
  }

  @override
  Future<void> updateRequestStatus(String requestId, AccessRequestStatus status) async {
    final box = await _getBox();
    final request = box.get(requestId);
    if (request != null) {
      await box.put(requestId, request.copyWith(status: status));
    }
  }

  @override
  Future<bool> hasAccess(String userId, String professionalId) async {
    final box = await _getBox();
    return box.values.any((r) => 
      r.userId == userId && 
      r.professionalId == professionalId && 
      r.status == AccessRequestStatus.accepted
    );
  }
}
