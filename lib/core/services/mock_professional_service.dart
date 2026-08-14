import 'package:hive/hive.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/services/professional_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:uuid/uuid.dart';

import 'package:projetmascara/features/professional/models/professional_profile.dart';

class MockProfessionalService implements ProfessionalRepository {
  static const String _boxName = 'access_requests';
  static const String _userBoxName = 'users';
  static const String _assessmentBoxName = 'assessments';
  static const String _profileBoxName = 'professional_profiles';
  final _uuid = const Uuid();

  Future<Box<AccessRequest>> _getBox() async {
    try {
      final encryptionCipher = await HiveConfig.getEncryptionCipher();
      return await Hive.openBox<AccessRequest>(_boxName, encryptionCipher: encryptionCipher);
    } catch (e) {
      // Fallback for environments where secure storage is unavailable (e.g. some tests or desktop)
      return await Hive.openBox<AccessRequest>(_boxName);
    }
  }

  @override
  Future<List<AccessRequest>> getRequestsForUser(String userId) async {
    final box = await _getBox();
    return box.values.where((r) => r.userId == userId).toList();
  }

  @override
  Future<List<AccessRequest>> getRequestsForPsychologist(String psychologistId) async {
    final box = await _getBox();
    return box.values.where((r) => r.professionalId == psychologistId).toList();
  }

  @override
  Future<void> sendRequest({required String userId, required String professionalId}) async {
    final box = await _getBox();
    final request = AccessRequest(
      id: _uuid.v4(),
      userId: userId,
      professionalId: professionalId,
      status: AccessRequestStatus.pending,
      createdAt: DateTime.now(),
    );
    await box.put(request.id, request);
  }

  @override
  Future<void> respondToRequest(String requestId, AccessRequestStatus status) async {
    final box = await _getBox();
    final request = box.get(requestId);
    if (request != null) {
      final updated = request.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      await box.put(requestId, updated);
    }
  }

  @override
  Future<List<UserModel>> getAuthorizedPatients(String psychologistId) async {
    final requestBox = await _getBox();
    final authorizedUserIds = requestBox.values
        .where((r) => r.professionalId == psychologistId && r.status == AccessRequestStatus.accepted)
        .map((r) => r.userId)
        .toSet();

    final userBox = await Hive.openBox<UserModel>(_userBoxName);
    return userBox.values.where((u) => authorizedUserIds.contains(u.id)).toList();
  }

  @override
  Future<UserModel?> getPatientById(String psychologistId, String patientId) async {
    final requestBox = await _getBox();
    final isAuthorized = requestBox.values.any((r) =>
        r.professionalId == psychologistId &&
        r.userId == patientId &&
        r.status == AccessRequestStatus.accepted);

    if (!isAuthorized) return null;

    final userBox = await Hive.openBox<UserModel>(_userBoxName);
    return userBox.get(patientId);
  }

  @override
  Future<List<AssessmentRecord>> getPatientAssessments(String psychologistId, String patientId) async {
    final requestBox = await _getBox();
    final isAuthorized = requestBox.values.any((r) =>
        r.professionalId == psychologistId &&
        r.userId == patientId &&
        r.status == AccessRequestStatus.accepted);

    if (!isAuthorized) return [];

    final assessmentBox = await Hive.openBox<AssessmentRecord>(_assessmentBoxName);
    return assessmentBox.values.where((a) => a.userId == patientId).toList();
  }

  @override
  Future<List<ProfessionalProfile>> getAllProfessionals() async {
    final box = await Hive.openBox<ProfessionalProfile>(_profileBoxName);
    if (box.isEmpty) {
      // Seed some data for the demo
      final demoProfiles = [
        ProfessionalProfile(
          id: 'prof_1',
          userId: 'user_psy_1',
          fullName: 'Dr. Sarah Ahmed',
          specialty: ProfessionalSpecialty.psychologist,
          description: 'Spécialisée en gestion du stress et trauma.',
          location: 'Alger',
          languages: ['Français', 'Arabe'],
          isApproved: true,
          createdAt: DateTime.now(),
        ),
        ProfessionalProfile(
          id: 'prof_2',
          userId: 'user_psy_2',
          fullName: 'Dr. Karim Benali',
          specialty: ProfessionalSpecialty.neurologist,
          description: 'Expert en troubles du sommeil.',
          location: 'Oran',
          languages: ['Français', 'Arabe', 'Anglais'],
          isApproved: true,
          createdAt: DateTime.now(),
        ),
      ];
      for (var p in demoProfiles) {
        await box.put(p.id, p);
      }
    }
    return box.values.toList();
  }
}
