import 'package:hive/hive.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/admin/admin_repository.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/data/hive_config.dart';

class MockAdminService implements AdminRepository {
  static const String _usersBoxName = 'users_box';
  static const String _assessmentsBoxName = 'assessments';
  static const String _requestsBoxName = 'access_requests';

  Future<Box<T>> _getBox<T>(String name) async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    return await Hive.openBox<T>(name, encryptionCipher: encryptionCipher);
  }

  @override
  Future<Map<String, dynamic>> getGlobalStatistics() async {
    final usersBox = await _getBox<UserModel>(_usersBoxName);
    final assessmentsBox = await _getBox<AssessmentRecord>(_assessmentsBoxName);
    final requestsBox = await _getBox<AccessRequest>(_requestsBoxName);

    final users = usersBox.values.toList();
    final professionals = users.where((u) => u.role == UserRole.psychologist).toList();
    
    return {
      'totalUsers': users.length,
      'professionalsCount': professionals.length,
      'pendingProfessionals': professionals.where((p) => p.status == 'pending').length,
      'approvedProfessionals': professionals.where((p) => p.status == 'approved').length,
      'rejectedProfessionals': professionals.where((p) => p.status == 'rejected').length,
      'totalAssessments': assessmentsBox.length,
      'totalAccessRequests': requestsBox.length,
      'pendingAccessRequests': requestsBox.values.where((r) => r.status == AccessRequestStatus.pending).length,
    };
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final box = await _getBox<UserModel>(_usersBoxName);
    return box.values.toList();
  }

  @override
  Future<List<UserModel>> getProfessionals() async {
    final users = await getUsers();
    return users.where((u) => u.role == UserRole.psychologist).toList();
  }

  @override
  Future<void> updateProfessionalStatus(String userId, String status) async {
    final box = await _getBox<UserModel>(_usersBoxName);
    final user = box.get(userId);
    if (user != null && user.role == UserRole.psychologist) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await box.put(userId, updated);
    }
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    final box = await _getBox<UserModel>(_usersBoxName);
    final user = box.get(userId);
    if (user != null) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await box.put(userId, updated);
    }
  }
}
