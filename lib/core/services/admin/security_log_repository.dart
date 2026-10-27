import '../../models/admin/security_log.dart';

abstract class SecurityLogRepository {
  Future<List<SecurityLog>> getLogs();
  Future<void> logEvent(SecurityLog log);
  Future<void> clearAllLogs();
}
