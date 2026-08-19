import 'dart:async';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/services/auth_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/services/sync_service.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:uuid/uuid.dart';

class HiveAuthRepository implements AuthRepository {
  final SyncService _syncService;
  final AuthRemoteDataSource _remoteDataSource;
  final _uuid = const Uuid();
  final _authStateController = StreamController<UserModel?>.broadcast();
  
  UserModel? _currentUser;

  HiveAuthRepository(this._syncService, this._remoteDataSource) {
    _init();
  }

  Future<void> _init() async {
    final box = Hive.box(HiveConfig.authBox);
    _currentUser = box.get('current_user');
    _authStateController.add(_currentUser);
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final user = await _remoteDataSource.login(email, password);
    await _saveUserLocally(user);
    return user;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final user = await _remoteDataSource.register(email, password, role);
    await _saveUserLocally(user);
    return user;
  }

  Future<void> _saveUserLocally(UserModel user) async {
    _currentUser = user;
    final authBox = Hive.box(HiveConfig.authBox);
    await authBox.put('current_user', user);
    
    final usersBox = Hive.box<UserModel>(HiveConfig.usersBox);
    await usersBox.put(user.id, user);
    
    _authStateController.add(user);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    _currentUser = null;
    final authBox = Hive.box(HiveConfig.authBox);
    await authBox.delete('current_user');
    _authStateController.add(null);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _remoteDataSource.resetPassword(email);
  }

  @override
  Future<void> verifyEmail() async {
    // Implementation for email verification
  }

  @override
  Future<void> migrateGuestData(String userId) async {
    // Logic to migrate data like assessments, settings, etc.
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    return box.values.toList();
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    final user = box.get(userId);
    if (user != null) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await box.put(userId, updated);
      
      await _syncService.addToQueue('user', SyncOperation.update, {
        'id': userId,
        'status': status,
        'updatedAt': updated.updatedAt.toIso8601String(),
      });
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final box = Hive.box<UserModel>(HiveConfig.usersBox);
    await box.put(user.id, user);
    
    if (_currentUser?.id == user.id) {
      _currentUser = user;
      final authBox = Hive.box(HiveConfig.authBox);
      await authBox.put('current_user', user);
      _authStateController.add(user);
    }
    
    await _syncService.addToQueue('user', SyncOperation.update, {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'wilayaId': user.wilayaId,
      'prefSpiritual': user.prefSpiritual,
      'hasCompletedInitialAssessment': user.hasCompletedInitialAssessment,
      'updatedAt': user.updatedAt.toIso8601String(),
    });
  }
}
