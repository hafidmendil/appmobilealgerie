import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/local_care_repository.dart';

final localCareRepositoryProvider = Provider<LocalCareRepository>((ref) {
  return LocalCareRepository();
});

final localPartnersProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, wilayaId) {
      return ref
          .watch(localCareRepositoryProvider)
          .partners(wilayaId: wilayaId);
    });

final localReferralsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
      return ref.watch(localCareRepositoryProvider).referralsForUser(userId);
    });

final localReportsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, userId) {
      return ref.watch(localCareRepositoryProvider).reportsForUser(userId);
    });

final localNotificationsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, userId) {
      return ref
          .watch(localCareRepositoryProvider)
          .notificationsForUser(userId);
    });

final localPartnerRelationshipsProvider =
    FutureProvider<List<LocalPartnerRelationship>>((ref) {
      return ref.watch(localCareRepositoryProvider).partnerRelationships();
    });
