import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/admin/admin_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/auth/user_role.dart';

class HiveAdminRepository implements AdminRepository {
  Box<UserModel> get _usersBox => Hive.box<UserModel>(HiveConfig.usersBox);

  @override
  Future<Map<String, dynamic>> getGlobalStatistics() async {
    final users = _usersBox.values.toList();
    return {
      'total_users': users.length,
      'total_professionals': users.where((u) => u.role == UserRole.psychologist).length,
      'pending_approvals': users.where((u) => u.status == 'pending').length,
    };
  }

  @override
  Future<List<UserModel>> getUsers() async {
    return _usersBox.values.where((u) => u.role == UserRole.user).toList();
  }

  @override
  Future<List<UserModel>> getProfessionals() async {
    return _usersBox.values.where((u) => u.role == UserRole.psychologist).toList();
  }

  @override
  Future<void> updateProfessionalStatus(String userId, String status) async {
    final user = _usersBox.get(userId);
    if (user != null) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await _usersBox.put(userId, updated);
    }
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    final user = _usersBox.get(userId);
    if (user != null) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await _usersBox.put(userId, updated);
    }
  }
}
