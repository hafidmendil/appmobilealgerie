import 'package:hive/hive.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/services/professional_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';
import 'package:projetmascara/core/services/sync_service.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:uuid/uuid.dart';

class HiveProfessionalRepository implements ProfessionalRepository {
  final SyncService _syncService;
  final _uuid = const Uuid();

  HiveProfessionalRepository(this._syncService);

  Box<AccessRequest> get _requestsBox => Hive.box<AccessRequest>(HiveConfig.accessRequestsBox);
  Box<ProfessionalProfile> get _profilesBox => Hive.box<ProfessionalProfile>(HiveConfig.profilesBox);
  Box<UserModel> get _usersBox => Hive.box<UserModel>(HiveConfig.usersBox);
  Box<AssessmentRecord> get _assessmentsBox => Hive.box<AssessmentRecord>(HiveConfig.assessmentsBox);

  @override
  Future<List<AccessRequest>> getRequestsForUser(String userId) async {
    return _requestsBox.values.where((r) => r.userId == userId).toList();
  }

  @override
  Future<List<AccessRequest>> getRequestsForPsychologist(String psychologistId) async {
    return _requestsBox.values.where((r) => r.professionalId == psychologistId).toList();
  }

  @override
  Future<void> sendRequest({required String userId, required String professionalId}) async {
    final request = AccessRequest(
      id: _uuid.v4(),
      userId: userId,
      professionalId: professionalId,
      status: AccessRequestStatus.pending,
      createdAt: DateTime.now(),
    );
    await _requestsBox.put(request.id, request);
    
    await _syncService.addToQueue('access_request', SyncOperation.create, {
      'id': request.id,
      'userId': userId,
      'professionalId': professionalId,
      'status': request.status.name,
      'createdAt': request.createdAt.toIso8601String(),
    });
  }

  @override
  Future<void> respondToRequest(String requestId, AccessRequestStatus status) async {
    final request = _requestsBox.get(requestId);
    if (request != null) {
      final updated = request.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await _requestsBox.put(requestId, updated);
      
      await _syncService.addToQueue('access_request', SyncOperation.update, {
        'id': requestId,
        'status': status.name,
        'updatedAt': updated.updatedAt?.toIso8601String(),
      });
    }
  }

  @override
  Future<List<UserModel>> getAuthorizedPatients(String psychologistId) async {
    final authorizedUserIds = _requestsBox.values
        .where((r) => r.professionalId == psychologistId && r.status == AccessRequestStatus.accepted)
        .map((r) => r.userId)
        .toSet();

    return _usersBox.values.where((u) => authorizedUserIds.contains(u.id)).toList();
  }

  @override
  Future<UserModel?> getPatientById(String psychologistId, String patientId) async {
    final isAuthorized = _requestsBox.values.any((r) =>
        r.professionalId == psychologistId &&
        r.userId == patientId &&
        r.status == AccessRequestStatus.accepted);

    if (!isAuthorized) return null;
    return _usersBox.get(patientId);
  }

  @override
  Future<List<AssessmentRecord>> getPatientAssessments(String psychologistId, String patientId) async {
    final isAuthorized = _requestsBox.values.any((r) =>
        r.professionalId == psychologistId &&
        r.userId == patientId &&
        r.status == AccessRequestStatus.accepted);

    if (!isAuthorized) return [];
    return _assessmentsBox.values.where((a) => a.userId == patientId).toList();
  }

  @override
  Future<List<ProfessionalProfile>> getAllProfessionals() async {
    return _profilesBox.values.toList();
  }
}
