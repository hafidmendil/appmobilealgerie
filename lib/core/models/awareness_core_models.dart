import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'awareness_core_models.g.dart';

@HiveType(typeId: 115)
class Resource extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String titleFr;
  @HiveField(2)
  final String titleAr;
  @HiveField(3)
  final String descriptionFr;
  @HiveField(4)
  final String descriptionAr;
  @HiveField(5)
  final String category; // e.g. psychological, legal, social, educational, prevention, safety
  @HiveField(6)
  final String contentFr;
  @HiveField(7)
  final String contentAr;
  @HiveField(8)
  final String? source;
  @HiveField(9)
  final bool verified;
  @HiveField(10)
  final DateTime publishedAt;
  @HiveField(11)
  final DateTime updatedAt;

  Resource({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.descriptionFr,
    required this.descriptionAr,
    required this.category,
    required this.contentFr,
    required this.contentAr,
    this.source,
    this.verified = true,
    required this.publishedAt,
    required this.updatedAt,
  });
}

@HiveType(typeId: 116)
class AwarenessPartner extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String type; // MIDDLE_SCHOOL, HIGH_SCHOOL, UNIVERSITY, COMPANY, ASSOCIATION
  @HiveField(3)
  final String wilayaId;
  @HiveField(4)
  final String communeId;
  @HiveField(5)
  final bool verified;
  @HiveField(6)
  final String? contactEmail;

  AwarenessPartner({
    required this.id,
    required this.name,
    required this.type,
    required this.wilayaId,
    required this.communeId,
    this.verified = false,
    this.contactEmail,
  });
}

@HiveType(typeId: 117)
class AwarenessCampaign extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String partnerId;
  @HiveField(2)
  final String titleFr;
  @HiveField(3)
  final String titleAr;
  @HiveField(4)
  final DateTime startDate;
  @HiveField(5)
  final DateTime endDate;
  @HiveField(6)
  final List<String> resourceIds;

  AwarenessCampaign({
    required this.id,
    required this.partnerId,
    required this.titleFr,
    required this.titleAr,
    required this.startDate,
    required this.endDate,
    this.resourceIds = const [],
  });
}

@HiveType(typeId: 118)
class Notification extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String? anonymousSessionId;
  @HiveField(3)
  final NotificationType type;
  @HiveField(4)
  final String titleFr;
  @HiveField(5)
  final String titleAr;
  @HiveField(6)
  final String bodyFr;
  @HiveField(7)
  final String bodyAr;
  @HiveField(8)
  final bool isRead;
  @HiveField(9)
  final DateTime createdAt;

  Notification({
    required this.id,
    this.userId,
    this.anonymousSessionId,
    required this.type,
    required this.titleFr,
    required this.titleAr,
    required this.bodyFr,
    required this.bodyAr,
    this.isRead = false,
    required this.createdAt,
  });
}

@HiveType(typeId: 119)
class SecurityLog extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String action; // login, logout, permission_change, referral_created, etc.
  @HiveField(2)
  final String? userId; // Technical ID only
  @HiveField(3)
  final String? anonymousSessionId;
  @HiveField(4)
  final DateTime timestamp;
  @HiveField(5)
  final String details; // Non-sensitive context (e.g. "Consent granted for referral X")

  SecurityLog({
    required this.id,
    required this.action,
    this.userId,
    this.anonymousSessionId,
    required this.timestamp,
    required this.details,
  });
}
