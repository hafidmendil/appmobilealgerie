import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/data/local_database.dart';
import 'package:projetmascara/core/data/sync/sync_queue_service.dart';
import 'package:projetmascara/core/data/sync/conflict_resolver.dart';
import 'package:projetmascara/core/data/migration/database_migration_service.dart';
import 'package:projetmascara/core/services/assessment_repository.dart';
import 'package:projetmascara/core/services/hive_assessment_repository.dart';
import 'package:projetmascara/core/services/professional_repository.dart';
import 'package:projetmascara/core/services/hive_professional_repository.dart';
import 'package:projetmascara/core/services/admin/admin_repository.dart';
import 'package:projetmascara/core/services/admin/hive_admin_repository.dart';
import 'package:projetmascara/core/services/admin/security_log_repository.dart';
import 'package:projetmascara/core/services/admin/hive_security_log_repository.dart';
import 'package:projetmascara/core/services/admin/content_repository.dart';
import 'package:projetmascara/core/services/hive_message_repository.dart';
import 'package:projetmascara/core/services/institutional_readiness_service.dart';
import 'package:projetmascara/features/protection/domain/repositories/protection_repository.dart';
import 'package:projetmascara/features/protection/data/repositories/hive_protection_repository.dart';

final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase.instance;
});

final conflictResolverProvider = Provider<ConflictResolver>((ref) {
  return const ConflictResolver();
});

final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  final db = ref.watch(localDatabaseProvider);
  final resolver = ref.watch(conflictResolverProvider);
  final service = SyncQueueService(database: db, resolver: resolver);
  service.init();
  ref.onDispose(() => service.dispose());
  return service;
});

final databaseMigrationServiceProvider = Provider<DatabaseMigrationService>((
  ref,
) {
  final db = ref.watch(localDatabaseProvider);
  return DatabaseMigrationService(database: db);
});

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return HiveAssessmentRepository();
});

final professionalRepositoryProvider = Provider<ProfessionalRepository>((ref) {
  return HiveProfessionalRepository();
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return HiveAdminRepository();
});

final securityLogRepositoryProvider = Provider<SecurityLogRepository>((ref) {
  return HiveSecurityLogRepository();
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return HiveContentRepository();
});

final messageRepositoryProvider = Provider<HiveMessageRepository>((ref) {
  return HiveMessageRepository();
});

final institutionalReadinessServiceProvider =
    Provider<InstitutionalReadinessService>((ref) {
      return InstitutionalReadinessService();
    });

final protectionRepositoryProvider = Provider<ProtectionRepository>((ref) {
  return HiveProtectionRepository();
});
