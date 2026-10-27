import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/auth_repository.dart';
import 'package:projetmascara/core/services/hybrid_auth_service.dart';
import 'package:projetmascara/core/services/auth_repository_impl.dart';
import 'package:projetmascara/core/auth/user_role.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final hiveAuth = HiveAuthRepository();
  return HybridAuthService(hiveAuth);
});

final authStateProvider = StreamProvider<UserModel?>((ref) async* {
  final repository = ref.watch(authRepositoryProvider);
  final currentUser = await repository.getCurrentUser();
  if (currentUser != null) {
    yield currentUser;
  }
  yield* repository.authStateChanges;
});

final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authStateProvider).value;
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AsyncValue.data(null)) {
    _restoreSession();
    _repository.authStateChanges.listen((user) {
      if (mounted) {
        state = AsyncValue.data(user);
      }
    });
  }

  Future<void> _restoreSession() async {
    try {
      final user = await _repository.getCurrentUser();
      if (mounted) {
        state = AsyncValue.data(user);
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<void> login(
    String email,
    String password, {
    String? secondFactorCode,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(
        email,
        password,
        secondFactorCode: secondFactorCode,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register(String email, String password, UserRole role) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        role: role,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> initializeOfflineAdministrator(
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.initializeOfflineAdministrator(
        email: email,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  Future<void> deleteCurrentUserData() async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteCurrentUserData();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
      return AuthNotifier(ref.watch(authRepositoryProvider));
    });

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(authRepositoryProvider).getAllUsers();
});
