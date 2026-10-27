import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'referral_model.g.dart';

@HiveType(typeId: 108)
class Referral extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String? anonymousSessionId;
  @HiveField(3)
  final String partnerId;
  @HiveField(4)
  final ReferralStatus status;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  @HiveField(7)
  final String? consentId;
  @HiveField(8)
  final String? assessmentResultId;
  @HiveField(9)
  final String? notes; // Optional context notes

  Referral({
    required this.id,
    this.userId,
    this.anonymousSessionId,
    required this.partnerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.consentId,
    this.assessmentResultId,
    this.notes,
  });
}
