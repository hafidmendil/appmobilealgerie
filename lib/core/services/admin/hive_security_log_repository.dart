import '../../models/admin/security_log.dart';
import 'security_log_repository.dart';
import 'package:hive/hive.dart';
import '../../data/hive_config.dart';

class HiveSecurityLogRepository implements SecurityLogRepository {
  Box<SecurityLog> _getBox() {
    return Hive.box<SecurityLog>(HiveConfig.securityLogsBox);
  }

  @override
  Future<List<SecurityLog>> getLogs() async {
    final box = _getBox();
    final logs = box.values.toList();
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  @override
  Future<void> logEvent(SecurityLog log) async {
    final box = _getBox();
    await box.put(log.id, log);
  }

  @override
  Future<void> clearAllLogs() async {
    throw UnsupportedError(
      'Les journaux d’audit ne peuvent pas être supprimés depuis l’application.',
    );
  }
}
