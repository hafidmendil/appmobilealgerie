import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/services/auth_repository.dart';
import 'package:uuid/uuid.dart';

import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/core/data/hive_config.dart';

class MockAuthService implements AuthRepository {
  static const String _boxName = 'auth_box';
  static const String _userKey = 'current_user';
  
  UserModel? _currentUser;
  final _controller = StreamController<UserModel?>.broadcast();
  final _uuid = const Uuid();

  MockAuthService() {
    _init();
  }

  Future<void> _init() async {
    try {
      final encryptionCipher = await HiveConfig.getEncryptionCipher();
      final box = await Hive.openBox(_boxName, encryptionCipher: encryptionCipher);
      _currentUser = box.get(_userKey);
      _controller.add(_currentUser);
    } catch (e) {
      logger.e('Failed to initialize MockAuthService', e);
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    try {
      final encryptionCipher = await HiveConfig.getEncryptionCipher();
      final box = await Hive.openBox(_boxName, encryptionCipher: encryptionCipher);
      _currentUser = box.get(_userKey);
    } catch (e) {
      logger.e('Failed to get current user', e);
    }
    return _currentUser;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    logger.i('Attempting login for $email');
    await Future.delayed(const Duration(seconds: 1));
    
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final usersBox = await Hive.openBox<UserModel>('users_box', encryptionCipher: encryptionCipher);
    
    UserModel? user;
    try {
      user = usersBox.values.firstWhere((u) => u.email == email);
    } catch (_) {
      throw Exception('Utilisateur non trouvé. Veuillez vous inscrire.');
    }

    _currentUser = user;
    
    try {
      final box = await Hive.openBox(_boxName, encryptionCipher: encryptionCipher);
      // Create a copy to avoid HiveObject conflict
      final userBoxCopy = _currentUser!.copyWith();
      await box.put(_userKey, userBoxCopy);
      
      _controller.add(_currentUser);
      logger.i('Login successful for $email');
    } catch (e) {
      logger.e('Login failed for $email', e);
      rethrow;
    }
    return _currentUser!;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final usersBox = await Hive.openBox<UserModel>('users_box', encryptionCipher: encryptionCipher);

    // Check if user already exists
    if (usersBox.values.any((u) => u.email == email)) {
      throw Exception('Cet email est déjà utilisé.');
    }

    _currentUser = UserModel(
      id: _uuid.v4(),
      email: email,
      role: role,
      status: role == UserRole.psychologist ? 'pending' : 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      wilayaId: null,
      prefSpiritual: true,
      hasCompletedInitialAssessment: false,
      name: email.split('@').first,
    );
    
    final box = await Hive.openBox(_boxName, encryptionCipher: encryptionCipher);
    // Create copy for auth_box
    final authCopy = _currentUser!.copyWith();
    await box.put(_userKey, authCopy);

    // Create copy for users_box
    final userCopy = _currentUser!.copyWith();
    await usersBox.put(userCopy.id, userCopy);
    
    _controller.add(_currentUser);
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox(_boxName, encryptionCipher: encryptionCipher);
    await box.delete(_userKey);
    _controller.add(null);
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> verifyEmail() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> migrateGuestData(String userId) async {
    // This would typically call multiple repositories
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox<UserModel>('users_box', encryptionCipher: encryptionCipher);
    return box.values.toList();
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final box = await Hive.openBox<UserModel>('users_box', encryptionCipher: encryptionCipher);
    final user = box.get(userId);
    if (user != null) {
      final updated = user.copyWith(status: status, updatedAt: DateTime.now());
      await box.put(userId, updated);
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    final usersBox = await Hive.openBox<UserModel>('users_box', encryptionCipher: encryptionCipher);
    final authBox = await Hive.openBox(_boxName, encryptionCipher: encryptionCipher);

    final updated = user.copyWith(updatedAt: DateTime.now());
    
    await usersBox.put(updated.id, updated.copyWith());
    
    if (_currentUser?.id == updated.id) {
      _currentUser = updated;
      await authBox.put(_userKey, updated.copyWith());
      _controller.add(_currentUser);
    }
  }
}
