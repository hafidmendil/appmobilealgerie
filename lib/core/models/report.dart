enum ReportStatus { reported, underReview, resolved, rejected }

enum ReportTargetType { account, message, behavior, content, security }

class Report {
  final String id;
  final String reporterId;
  final String targetId;
  final ReportTargetType targetType;
  final String reason;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? adminDecision;

  const Report({
    required this.id,
    required this.reporterId,
    required this.targetId,
    required this.targetType,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.adminDecision,
  });

  Report copyWith({
    String? id,
    String? reporterId,
    String? targetId,
    ReportTargetType? targetType,
    String? reason,
    ReportStatus? status,
    DateTime? createdAt,
    DateTime? reviewedAt,
    String? adminDecision,
  }) {
    return Report(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      adminDecision: adminDecision ?? this.adminDecision,
    );
  }
}
