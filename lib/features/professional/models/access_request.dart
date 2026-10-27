import 'package:hive/hive.dart';

part 'access_request.g.dart';

@HiveType(typeId: 3)
enum AccessRequestStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  accepted,
  @HiveField(2)
  rejected,
  @HiveField(3)
  revoked,
}

@HiveType(typeId: 4)
class AccessRequest extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String professionalId;

  @HiveField(3)
  final AccessRequestStatus status;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String? message;

  @HiveField(6)
  final DateTime? updatedAt;

  AccessRequest({
    required this.id,
    required this.userId,
    required this.professionalId,
    required this.status,
    required this.createdAt,
    this.message,
    this.updatedAt,
  });

  AccessRequest copyWith({
    String? id,
    String? userId,
    String? professionalId,
    AccessRequestStatus? status,
    DateTime? createdAt,
    String? message,
    DateTime? updatedAt,
  }) {
    return AccessRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      professionalId: professionalId ?? this.professionalId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
