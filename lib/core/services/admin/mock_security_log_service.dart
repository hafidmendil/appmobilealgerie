import '../../models/admin/security_log.dart';
import 'security_log_repository.dart';

class MockSecurityLogService implements SecurityLogRepository {
  @override
  Future<List<SecurityLog>> getLogs() async => [];
  @override
  Future<void> logEvent(SecurityLog log) async {}
  @override
  Future<void> clearAllLogs() async {}
}
