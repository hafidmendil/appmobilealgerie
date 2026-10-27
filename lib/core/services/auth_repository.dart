import '../models/user_model.dart';
import '../auth/user_role.dart';

abstract class AuthRepository {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login(
    String email,
    String password, {
    String? secondFactorCode,
  });
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  });
  Future<UserModel> initializeOfflineAdministrator({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<List<UserModel>> getAllUsers();
  Future<void> updateUserStatus(String userId, String status);
  Future<void> updateUser(UserModel user);
  Future<void> deleteCurrentUserData();
  Future<void> resetPassword(String email);
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });
  Future<void> adminResetPassword({
    required String adminId,
    required String userId,
    required String temporaryPassword,
  });
  Future<void> setMfaRequirement({
    required String adminId,
    required String userId,
    required bool required,
    String? enrollmentCode,
  });
  Future<void> verifyEmail();
  Future<void> migrateGuestData(String userId);
}
