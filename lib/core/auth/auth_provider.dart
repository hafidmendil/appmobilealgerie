import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/auth_repository.dart';
import 'package:projetmascara/core/services/mock_auth_service.dart';
import 'package:projetmascara/core/auth/user_role.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthService();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).value;
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _repository.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password, UserRole role) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.register(email: email, password: password, role: role);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider), ref);
});

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(authRepositoryProvider).getAllUsers();
});
