import 'package:hive/hive.dart';

part 'session_request_model.g.dart';

@HiveType(typeId: 11)
enum SessionRequestStatus {
  @HiveField(0)
  PENDING,
  @HiveField(1)
  ACCEPTED,
  @HiveField(2)
  REJECTED,
  @HiveField(3)
  CANCELLED,
  @HiveField(4)
  COMPLETED,
}

@HiveType(typeId: 12)
class SessionRequestModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final int? professionalId;

  @HiveField(3)
  final int? centerId;

  @HiveField(4)
  final int wilayaId;

  @HiveField(5)
  final DateTime requestedDate;

  @HiveField(6)
  final String? preferredTime;

  @HiveField(7)
  final String? sessionType;

  @HiveField(8)
  final String? userMessage;

  @HiveField(9)
  final SessionRequestStatus status;

  @HiveField(10)
  final bool consentGiven;

  @HiveField(11)
  final DateTime? consentDate;

  @HiveField(12)
  final String? consentVersion;

  @HiveField(13)
  final DateTime? createdAt;

  @HiveField(14)
  final DateTime? updatedAt;

  SessionRequestModel({
    required this.id,
    required this.userId,
    this.professionalId,
    this.centerId,
    required this.wilayaId,
    required this.requestedDate,
    this.preferredTime,
    this.sessionType,
    this.userMessage,
    this.status = SessionRequestStatus.PENDING,
    this.consentGiven = false,
    this.consentDate,
    this.consentVersion,
    this.createdAt,
    this.updatedAt,
  });

  SessionRequestModel copyWith({
    int? id,
    int? userId,
    int? professionalId,
    int? centerId,
    int? wilayaId,
    DateTime? requestedDate,
    String? preferredTime,
    String? sessionType,
    String? userMessage,
    SessionRequestStatus? status,
    bool? consentGiven,
    DateTime? consentDate,
    String? consentVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionRequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      professionalId: professionalId ?? this.professionalId,
      centerId: centerId ?? this.centerId,
      wilayaId: wilayaId ?? this.wilayaId,
      requestedDate: requestedDate ?? this.requestedDate,
      preferredTime: preferredTime ?? this.preferredTime,
      sessionType: sessionType ?? this.sessionType,
      userMessage: userMessage ?? this.userMessage,
      status: status ?? this.status,
      consentGiven: consentGiven ?? this.consentGiven,
      consentDate: consentDate ?? this.consentDate,
      consentVersion: consentVersion ?? this.consentVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory SessionRequestModel.fromJson(Map<String, dynamic> json) {
    return SessionRequestModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      professionalId: json['professionalId'] as int?,
      centerId: json['centerId'] as int?,
      wilayaId: json['wilayaId'] as int,
      requestedDate: DateTime.parse(json['requestedDate'] as String),
      preferredTime: json['preferredTime'] as String?,
      sessionType: json['sessionType'] as String?,
      userMessage: json['userMessage'] as String?,
      status: SessionRequestStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'PENDING'),
        orElse: () => SessionRequestStatus.PENDING,
      ),
      consentGiven: json['consentGiven'] as bool? ?? false,
      consentDate: json['consentDate'] != null
          ? DateTime.parse(json['consentDate'] as String)
          : null,
      consentVersion: json['consentVersion'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'professionalId': professionalId,
      'centerId': centerId,
      'wilayaId': wilayaId,
      'requestedDate': requestedDate.toIso8601String(),
      'preferredTime': preferredTime,
      'sessionType': sessionType,
      'userMessage': userMessage,
      'status': status.name,
      'consentGiven': consentGiven,
      'consentDate': consentDate?.toIso8601String(),
      'consentVersion': consentVersion,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
