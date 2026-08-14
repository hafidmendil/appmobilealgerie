import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/user_role.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email, 
    required String password, 
    required UserRole role,
  });
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<void> verifyEmail();
  Future<void> migrateGuestData(String userId);
  Future<List<UserModel>> getAllUsers();
  Future<void> updateUserStatus(String userId, String status);
  Future<void> updateUser(UserModel user);
  Stream<UserModel?> get authStateChanges;
}
