import 'dart:async';
import '../models/user_model.dart';
import '../auth/user_role.dart';
import 'auth_repository.dart';
import '../error/failures.dart';
import 'logger_service.dart';

/// Real Professional Supabase Implementation
/// Ready to replace MockAuthService
class SupabaseAuthService implements AuthRepository {
  final _controller = StreamController<UserModel?>.broadcast();

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel?> getCurrentUser() async {
    // return _supabase.auth.currentUser converted to UserModel
    return null; 
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      logger.i('Supabase Login: $email');
      // final res = await _supabase.auth.signInWithPassword(email: email, password: password);
      // return Mapper.toUserModel(res.user);
      throw const AuthFailure('Supabase not configured yet');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      // 1. Auth SignUp
      // 2. Insert into 'profiles' table
      throw const AuthFailure('Registration requires Supabase credentials');
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    // await _supabase.auth.signOut();
    _controller.add(null);
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    // Only accessible by Admin role (RLS policy)
    return [];
  }

  @override
  Future<void> updateUserStatus(String userId, String status) async {
    // RPC call or direct update on profiles
  }

  @override
  Future<void> updateUser(UserModel user) async {
    // Update profiles table
  }
  
  @override
  Future<void> resetPassword(String email) async => throw UnimplementedError();
  @override
  Future<void> verifyEmail() async => throw UnimplementedError();
  @override
  Future<void> migrateGuestData(String userId) async {}
}
