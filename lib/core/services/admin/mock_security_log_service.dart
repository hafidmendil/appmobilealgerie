import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/services/admin/security_log_repository.dart';
import 'package:projetmascara/core/data/hive_config.dart';

class MockSecurityLogService implements SecurityLogRepository {
  static const String _boxName = 'security_logs';

  Future<Box<SecurityLog>> _getBox() async {
    final encryptionCipher = await HiveConfig.getEncryptionCipher();
    return await Hive.openBox<SecurityLog>(_boxName, encryptionCipher: encryptionCipher);
  }

  @override
  Future<void> logEvent(SecurityLog log) async {
    final box = await _getBox();
    await box.put(log.id, log);
  }

  @override
  Future<List<SecurityLog>> getLogs({
    String? actorId,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final box = await _getBox();
    var logs = box.values.toList();

    if (actorId != null) {
      logs = logs.where((l) => l.actorId == actorId).toList();
    }
    if (action != null) {
      logs = logs.where((l) => l.action == action).toList();
    }
    if (startDate != null) {
      logs = logs.where((l) => l.timestamp.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      logs = logs.where((l) => l.timestamp.isBefore(endDate)).toList();
    }

    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return logs;
  }

  @override
  Future<void> clearLogs() async {
    final box = await _getBox();
    await box.clear();
  }
}
