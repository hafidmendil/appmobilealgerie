import 'package:projetmascara/core/models/admin/security_log.dart';

abstract class SecurityLogRepository {
  Future<void> logEvent(SecurityLog log);
  Future<List<SecurityLog>> getLogs({
    String? actorId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<void> clearLogs();
}
