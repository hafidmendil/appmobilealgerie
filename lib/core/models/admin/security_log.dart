import 'package:hive/hive.dart';

part 'security_log.g.dart';

@HiveType(typeId: 8)
class SecurityLog extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String actorId;
  
  @HiveField(2)
  final String actorRole;
  
  @HiveField(3)
  final String action; // login, logout, approve_pro, reject_pro, update_user, etc.
  
  @HiveField(4)
  final String? targetId;
  
  @HiveField(5)
  final DateTime timestamp;
  
  @HiveField(6)
  final String status; // success, failure
  
  @HiveField(7)
  final Map<String, String>? metadata;

  SecurityLog({
    required this.id,
    required this.actorId,
    required this.actorRole,
    required this.action,
    this.targetId,
    required this.timestamp,
    required this.status,
    this.metadata,
  });
}
