import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../auth/user_role.dart';
import 'auth_repository.dart';
import 'supabase_auth_service.dart';
import 'auth_repository_impl.dart';
import 'logger_service.dart';

class HybridAuthService implements AuthRepository {
  final SupabaseAuthService _supabaseAuth = SupabaseAuthService();
  final HiveAuthRepository _hiveAuth;
  final _controller = StreamController<UserModel?>.broadcast();
  
  UserModel? _currentUser;

  HybridAuthService(this._hiveAuth) {
    // Merge both streams
    _supabaseAuth.authStateChanges.listen((user) {
      if (user != null) {
        _currentUser = user;
        _controller.add(user);
      }
    });
    
    _hiveAuth.authStateChanges.listen((user) {
      if (user != null) {
        _currentUser = user;
        _controller.add(user);
      }
    });
  }

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;
    return await _supabaseAuth.getCurrentUser() ?? await _hiveAuth.getCurrentUser();
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Try Supabase first
      logger.i('Trying Supabase Login for $email');
      return await _supabaseAuth.login(email, password);
    } catch (e) {
      logger.w('Supabase Login failed, falling back to Hive: $e');
      // 2. Fallback to Hive for seeded accounts
      return await _hiveAuth.login(email, password);
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // 1. Try real Supabase registration
      return await _supabaseAuth.register(email: email, password: password, role: role);
    } catch (e) {
      logger.e('Supabase Registration failed: $e');
      // 2. If Supabase fails (e.g. missing tables), fallback to local registration for testing
      return await _hiveAuth.register(email: email, password: password, role: role);
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await _supabaseAuth.logout();
    await _hiveAuth.logout();
    _controller.add(null);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final remote = await _supabaseAuth.getAllUsers().catchError((_) => <UserModel>[]);
    final local = await _hiveAuth.getAllUsers();
    // Unique list by email
    final seen = <String>{};
    return [...remote, ...local].where((u) => seen.add(u.email)).toList();
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    await _supabaseAuth.updateUserStatus(userId, status).catchError((_) {});
    await _hiveAuth.updateUserStatus(userId, status);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _supabaseAuth.updateUser(user).catchError((_) {});
    await _hiveAuth.updateUser(user);
  }

  @override
  Future<void> resetPassword(String email) async {
    await _supabaseAuth.resetPassword(email).catchError((_) {});
  }

  @override
  Future<void> verifyEmail() async {
    await _supabaseAuth.verifyEmail();
  }

  @override
  Future<void> migrateGuestData(String userId) async {
    await _supabaseAuth.migrateGuestData(userId);
  }
}
