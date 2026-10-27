import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/admin/admin_repository.dart';
import 'package:projetmascara/core/services/admin/security_log_repository.dart';
import 'package:projetmascara/core/services/admin/content_repository.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/models/admin/content_models.dart';
import 'package:projetmascara/features/adaptive_assessment/domain/models/assessment_question.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:projetmascara/core/providers/backend_providers.dart';

final adminStatisticsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
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

final adminQuranProvider = FutureProvider<List<QuranVerseModel>>((ref) async {
  return ref.watch(contentRepositoryProvider).getQuranVerses();
});

final adminHadithProvider = FutureProvider<List<HadithModel>>((ref) async {
  return ref.watch(contentRepositoryProvider).getHadiths();
});

final adminQuestionsProvider = FutureProvider<List<AssessmentQuestion>>((
  ref,
) async {
  return ref.watch(adminRepositoryProvider).getQuestions();
});

class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _adminRepo;
  final SecurityLogRepository _logRepo;
  final ContentRepository _contentRepo;
  final Ref _ref;

  AdminNotifier(this._adminRepo, this._logRepo, this._contentRepo, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> updateProfessionalStatus(String userId, String status) async {
    state = const AsyncValue.loading();
    try {
      await _adminRepo.updateProfessionalStatus(userId, status);

      final admin = _ref.read(currentUserProvider);
      if (admin != null) {
        await _logRepo.logEvent(
          SecurityLog(
            id: const Uuid().v4(),
            actorId: admin.id,
            actorRole: 'admin',
            action: 'professional_status_change',
            targetId: userId,
            timestamp: DateTime.now(),
            status: 'success',
            metadata: {'new_status': status},
          ),
        );
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
      final admin = _ref.read(currentUserProvider);
      if (admin?.id == userId) {
        throw Exception(
          'Un administrateur ne peut pas désactiver son propre compte',
        );
      }
      await _adminRepo.updateUserStatus(userId, status);

      if (admin != null) {
        await _logRepo.logEvent(
          SecurityLog(
            id: const Uuid().v4(),
            actorId: admin.id,
            actorRole: 'admin',
            action: 'user_status_change',
            targetId: userId,
            timestamp: DateTime.now(),
            status: 'success',
            metadata: {'new_status': status},
          ),
        );
      }

      _ref.invalidate(adminStatisticsProvider);
      _ref.invalidate(adminUsersProvider);
      _ref.invalidate(securityLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> clearAllLogs() async {
    state = const AsyncValue.loading();
    try {
      await _logRepo.clearAllLogs();
      _ref.invalidate(securityLogsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Quran Management
  Future<void> saveQuranVerse(QuranVerseModel verse) async {
    state = const AsyncValue.loading();
    try {
      await _contentRepo.saveQuranVerse(verse);
      _ref.invalidate(adminQuranProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteQuranVerse(String id) async {
    state = const AsyncValue.loading();
    try {
      await _contentRepo.deleteQuranVerse(id);
      _ref.invalidate(adminQuranProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Hadith Management
  Future<void> saveHadith(HadithModel hadith) async {
    state = const AsyncValue.loading();
    try {
      await _contentRepo.saveHadith(hadith);
      _ref.invalidate(adminHadithProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteHadith(String id) async {
    state = const AsyncValue.loading();
    try {
      await _contentRepo.deleteHadith(id);
      _ref.invalidate(adminHadithProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Question Management
  Future<void> saveQuestion(AssessmentQuestion question) async {
    state = const AsyncValue.loading();
    try {
      await _adminRepo.saveQuestion(question);
      _ref.invalidate(adminQuestionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteQuestion(String id) async {
    state = const AsyncValue.loading();
    try {
      await _adminRepo.deleteQuestion(id);
      _ref.invalidate(adminQuestionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> resetAlgorithm() async {
    state = const AsyncValue.loading();
    try {
      await _adminRepo.resetAlgorithm();
      _ref.invalidate(adminQuestionsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final adminNotifierProvider =
    StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
      return AdminNotifier(
        ref.watch(adminRepositoryProvider),
        ref.watch(securityLogRepositoryProvider),
        ref.watch(contentRepositoryProvider),
        ref,
      );
    });
