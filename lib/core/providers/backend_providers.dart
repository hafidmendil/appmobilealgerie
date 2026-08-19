import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/remote_data_source.dart';
import '../data/supabase_remote_data_source.dart';
import '../services/sync_service.dart';
import '../services/supabase_assessment_repository.dart';
import '../services/assessment_repository.dart';
import '../services/professional_repository.dart';
import '../services/supabase_professional_repository.dart';

final supabaseRemoteDataSourceProvider = Provider<SupabaseRemoteDataSource>((ref) {
  return SupabaseRemoteDataSource();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final remote = ref.watch(supabaseRemoteDataSourceProvider);
  return SyncService(
    _assessmentRemote: remote,
    _professionalRemote: remote,
  );
});

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return SupabaseAssessmentRepository(
    ref.watch(supabaseRemoteDataSourceProvider),
    ref.watch(syncServiceProvider),
  );
});

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return SupabaseProfessionalRepository(
    ref.watch(supabaseRemoteDataSourceProvider),
    ref.watch(syncServiceProvider),
  );
});
