import 'dart:async';
import '../models/user_model.dart';
import '../auth/user_role.dart';
import 'auth_repository.dart';
import 'auth_repository_impl.dart';

/// Now renamed to LocalAuthService but keeping class name for compatibility if used by providers
class HybridAuthService implements AuthRepository {
  final HiveAuthRepository _hiveAuth;
  final _controller = StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;

  HybridAuthService(this._hiveAuth) {
    _hiveAuth.authStateChanges.listen((user) {
      _currentUser = user;
      _controller.add(user);
    });
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser ?? await _hiveAuth.getCurrentUser();
  }

  @override
  Future<UserModel> login(
    String email,
    String password, {
    String? secondFactorCode,
  }) async {
    final user = await _hiveAuth.login(
      email,
      password,
      secondFactorCode: secondFactorCode,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final user = await _hiveAuth.register(
      email: email,
      password: password,
      role: role,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> initializeOfflineAdministrator({
    required String email,
    required String password,
  }) async {
    final user = await _hiveAuth.initializeOfflineAdministrator(
      email: email,
      password: password,
    );
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await _hiveAuth.logout();
    _controller.add(null);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    return await _hiveAuth.getAllUsers();
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    await _hiveAuth.updateUserStatus(userId, status);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _hiveAuth.updateUser(user);
  }

  @override
  Future<void> deleteCurrentUserData() async {
    await _hiveAuth.deleteCurrentUserData();
    _currentUser = null;
    _controller.add(null);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _hiveAuth.resetPassword(email);
  }

  @override
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) => _hiveAuth.changePassword(
    userId: userId,
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  @override
  Future<void> adminResetPassword({
    required String adminId,
    required String userId,
    required String temporaryPassword,
  }) => _hiveAuth.adminResetPassword(
    adminId: adminId,
    userId: userId,
    temporaryPassword: temporaryPassword,
  );

  @override
  Future<void> setMfaRequirement({
    required String adminId,
    required String userId,
    required bool required,
    String? enrollmentCode,
  }) => _hiveAuth.setMfaRequirement(
    adminId: adminId,
    userId: userId,
    required: required,
    enrollmentCode: enrollmentCode,
  );

  @override
  Future<void> verifyEmail() async {
    await _hiveAuth.verifyEmail();
  }

  @override
  Future<void> migrateGuestData(String userId) async {
    await _hiveAuth.migrateGuestData(userId);
  }
}
