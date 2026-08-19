import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/services/admin/security_log_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';

class HiveSecurityLogRepository implements SecurityLogRepository {
  Box<SecurityLog> get _box => Hive.box<SecurityLog>(HiveConfig.securityLogsBox);

  @override
  Future<void> logEvent(SecurityLog log) async {
    await _box.add(log);
  }

  @override
  Future<List<SecurityLog>> getLogs({
    String? actorId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var logs = _box.values.toList();
    
    if (actorId != null) logs = logs.where((l) => l.actorId == actorId).toList();
    if (action != null) logs = logs.where((l) => l.action == action).toList();
    if (startDate != null) logs = logs.where((l) => l.timestamp.isAfter(startDate)).toList();
    if (endDate != null) logs = logs.where((l) => l.timestamp.isBefore(endDate)).toList();

    return logs..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> clearLogs() async {
    await _box.clear();
  }
}
