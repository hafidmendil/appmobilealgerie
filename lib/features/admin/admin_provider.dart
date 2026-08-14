import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/admin/admin_repository.dart';
import 'package:projetmascara/core/services/admin/mock_admin_service.dart';
import 'package:projetmascara/core/services/admin/security_log_repository.dart';
import 'package:projetmascara/core/services/admin/mock_security_log_service.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:uuid/uuid.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return MockAdminService();
});

final securityLogRepositoryProvider = Provider<SecurityLogRepository>((ref) {
  return MockSecurityLogService();
});

final adminStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(adminRepositoryProvider).getGlobalStatistics();
});

final adminUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(adminRepositoryProvider).getUsers();
});

final adminProfessionalsProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(adminRepositoryProvider).getProfessionals();
});

final securityLogsProvider = FutureProvider<List<SecurityLog>>((ref) async {
  return ref.watch(securityLogRepositoryProvider).getLogs();
});

class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _adminRepo;
  final SecurityLogRepository _logRepo;
  final Ref _ref;

  AdminNotifier(this._adminRepo, this._logRepo, this._ref) : super(const AsyncValue.data(null));

  Future<void> updateProfessionalStatus(String userId, String status) async {
    state = const AsyncValue.loading();
    try {
      await _adminRepo.updateProfessionalStatus(userId, status);
      
      final admin = _ref.read(currentUserProvider);
      if (admin != null) {
        await _logRepo.logEvent(SecurityLog(
          id: const Uuid().v4(),
          actorId: admin.id,
          actorRole: 'admin',
          action: 'professional_status_change',
          targetId: userId,
          timestamp: DateTime.now(),
          status: 'success',
          metadata: {'new_status': status},
        ));
      }
      
      _ref.invalidate(adminStatisticsProvider);
      _ref.invalidate(adminProfessionalsProvider);
      _ref.invalidate(securityLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUserStatus(String userId, String status) async {
    state = const AsyncValue.loading();
    try {
      await _adminRepo.updateUserStatus(userId, status);
      
      final admin = _ref.read(currentUserProvider);
      if (admin != null) {
        await _logRepo.logEvent(SecurityLog(
          id: const Uuid().v4(),
          actorId: admin.id,
          actorRole: 'admin',
          action: 'user_status_change',
          targetId: userId,
          timestamp: DateTime.now(),
          status: 'success',
          metadata: {'new_status': status},
        ));
      }
      
      _ref.invalidate(adminStatisticsProvider);
      _ref.invalidate(adminUsersProvider);
      _ref.invalidate(securityLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminNotifierProvider = StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  return AdminNotifier(
    ref.watch(adminRepositoryProvider),
    ref.watch(securityLogRepositoryProvider),
    ref,
  );
});
