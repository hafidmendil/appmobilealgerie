import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'consent_model.g.dart';

@HiveType(typeId: 107)
class Consent extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? userId; // Null if anonymous
  @HiveField(2)
  final String? anonymousSessionId;
  @HiveField(3)
  final ConsentType type;
  @HiveField(4)
  final ConsentStatus status;
  @HiveField(5)
  final DateTime timestamp;
  @HiveField(6)
  final String version;
  @HiveField(7)
  final String? sourceContext; // Context where consent was given

  Consent({
    required this.id,
    this.userId,
    this.anonymousSessionId,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.version,
    this.sourceContext,
  });
}
