import '../models/user_model.dart';
import '../../features/professional/models/access_request.dart';
import '../../features/professional/models/professional_profile.dart';
import '../../features/assessment/assessment_record.dart';
import '../../features/professional/models/session_request_model.dart';
import 'professional_repository.dart';
import 'package:hive/hive.dart';
import '../data/hive_config.dart';
import '../data/neurosync_data.dart';
import '../auth/user_role.dart';
import 'package:uuid/uuid.dart';
import '../../features/professional/models/professional_model.dart';

class HiveProfessionalRepository implements ProfessionalRepository {
  Box<T> _getBox<T>(String name) {
    return Hive.box<T>(name);
  }

  @override
  Future<List<ProfessionalProfile>> getAllProfessionals() async {
    final box = _getBox<ProfessionalProfile>(HiveConfig.profilesBox);
    return box.values.where((p) => p.isApproved).toList();
  }

  @override
  Future<List<ProfessionalModel>> getDirectoryProfessionals() async {
    final usersBox = _getBox<UserModel>(HiveConfig.usersBox);
    final profilesBox = _getBox<ProfessionalProfile>(HiveConfig.profilesBox);
    final profilesByUserId = {
      for (final profile in profilesBox.values.where(
        (profile) => profile.isApproved,
      ))
        profile.userId: profile,
    };

    return neuroSyncAccounts
        .where((account) {
          final userId = const Uuid().v5(Uuid.NAMESPACE_URL, account.email);
          final user = usersBox.get(userId);
          return user?.role == UserRole.psychologist &&
              user?.status == 'approved' &&
              profilesByUserId.containsKey(userId);
        })
        .map((account) {
          final userId = const Uuid().v5(Uuid.NAMESPACE_URL, account.email);
          final profile = profilesByUserId[userId]!;
          return ProfessionalModel(
            id: account.id,
            fullName: profile.fullName,
            title: 'Dr.',
            specialty: 'Psychologue Clinicien',
            wilayaId: int.parse(account.wilayaCode),
            city: account.wilaya,
            address: 'Cabinet NeuroSync - ${account.wilaya}',
            phone: account.phone,
            email: account.email,
            languages: profile.languages,
            biography: profile.description,
            verificationStatus: 'VERIFIED',
          );
        })
        .toList();
  }

  @override
  Future<void> addProfessionalForMessaging({
    required String userId,
    required int professionalAccountId,
    String? message,
  }) async {
    final account = neuroSyncAccounts.firstWhere(
      (item) => item.id == professionalAccountId,
      orElse: () => throw StateError('Psychologue introuvable.'),
    );
    final professionalId = const Uuid().v5(Uuid.NAMESPACE_URL, account.email);
    final requestsBox = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    final alreadyRequested = requestsBox.values.any(
      (request) =>
          request.userId == userId &&
          request.professionalId == professionalId &&
          (request.status == AccessRequestStatus.pending ||
              request.status == AccessRequestStatus.accepted),
    );
    if (alreadyRequested) return;

    final requestId = const Uuid().v4();
    await requestsBox.put(
      requestId,
      AccessRequest(
        id: requestId,
        userId: userId,
        professionalId: professionalId,
        status: AccessRequestStatus.pending,
        createdAt: DateTime.now(),
        message: message ?? 'Demande de suivi et de communication.',
      ),
    );
  }

  @override
  Future<void> sendRequest(AccessRequest request) async {
    final box = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    await box.put(request.id, request);
  }

  @override
  Future<List<AccessRequest>> getRequestsForPsychologist(
    String professionalId,
  ) async {
    final box = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    return box.values.where((r) => r.professionalId == professionalId).toList();
  }

  @override
  Future<List<AccessRequest>> getRequestsForUser(String userId) async {
    final box = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    return box.values.where((r) => r.userId == userId).toList();
  }

  @override
  Future<void> respondToRequest(
    String requestId,
    AccessRequestStatus status,
  ) async {
    final box = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    final request = box.get(requestId);
    if (request != null) {
      final updated = AccessRequest(
        id: request.id,
        userId: request.userId,
        professionalId: request.professionalId,
        status: status,
        createdAt: request.createdAt,
        message: request.message,
      );
      await box.put(requestId, updated);
    }
  }

  @override
  Future<List<UserModel>> getAuthorizedPatients(String professionalId) async {
    final requestsBox = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    final acceptedRequests = requestsBox.values.where(
      (r) =>
          r.professionalId == professionalId &&
          r.status == AccessRequestStatus.accepted,
    );

    if (acceptedRequests.isEmpty) return [];

    final usersBox = _getBox<UserModel>(HiveConfig.usersBox);
    final List<UserModel> patients = [];
    for (var req in acceptedRequests) {
      final patient = usersBox.get(req.userId);
      if (patient != null) {
        patients.add(patient);
      }
    }
    return patients;
  }

  @override
  Future<UserModel?> getPatientById(
    String professionalId,
    String patientId,
  ) async {
    final requestsBox = _getBox<AccessRequest>(HiveConfig.accessRequestsBox);
    final hasAccess = requestsBox.values.any(
      (r) =>
          r.professionalId == professionalId &&
          r.userId == patientId &&
          r.status == AccessRequestStatus.accepted,
    );

    if (!hasAccess) return null;

    final usersBox = _getBox<UserModel>(HiveConfig.usersBox);
    return usersBox.get(patientId);
  }

  @override
  Future<List<AssessmentRecord>> getPatientAssessments(
    String professionalId,
    String patientId,
  ) async {
    final patient = await getPatientById(professionalId, patientId);
    if (patient == null) return [];

    final box = _getBox<AssessmentRecord>(HiveConfig.assessmentResultsBox);
    return box.values.where((a) => a.userId == patientId).toList();
  }

  @override
  Future<void> submitSessionRequest(SessionRequestModel request) async {
    final box = _getBox<SessionRequestModel>(HiveConfig.sessionRequestsBox);
    await box.put(request.id, request);
  }

  @override
  Future<List<SessionRequestModel>> getSessionRequests(
    String professionalId,
  ) async {
    final box = _getBox<SessionRequestModel>(HiveConfig.sessionRequestsBox);
    final usersBox = _getBox<UserModel>(HiveConfig.usersBox);
    final professional = usersBox.get(professionalId);
    if (professional == null) return [];

    final account = neuroSyncAccounts.cast<NeuroSyncAccount?>().firstWhere(
      (candidate) =>
          candidate?.email.toLowerCase() == professional.email.toLowerCase(),
      orElse: () => null,
    );
    if (account == null) return [];
    return box.values.where((s) => s.professionalId == account.id).toList();
  }

  @override
  Future<List<SessionRequestModel>> getSessionRequestsForUser(
    int userId,
  ) async {
    final box = _getBox<SessionRequestModel>(HiveConfig.sessionRequestsBox);
    final requests = box.values
        .where((request) => request.userId == userId)
        .toList();
    requests.sort((a, b) => b.requestedDate.compareTo(a.requestedDate));
    return requests;
  }

  @override
  Future<void> updateSessionStatus(
    int sessionId,
    SessionRequestStatus status,
  ) async {
    final box = _getBox<SessionRequestModel>(HiveConfig.sessionRequestsBox);
    final request = box.get(sessionId);
    if (request != null) {
      final updated = request.copyWith(status: status);
      await box.put(sessionId, updated);
    }
  }
}
