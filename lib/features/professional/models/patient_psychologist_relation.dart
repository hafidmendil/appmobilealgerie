enum RelationStatus { pending, accepted, rejected, cancelled, blocked, ended }

class PatientPsychologistRelation {
  final String id;
  final String patientId;
  final String psychologistId;
  final RelationStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? reason;
  final bool chatAllowed;

  const PatientPsychologistRelation({
    required this.id,
    required this.patientId,
    required this.psychologistId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.reason,
    this.chatAllowed = false,
  });

  PatientPsychologistRelation copyWith({
    String? id,
    String? patientId,
    String? psychologistId,
    RelationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reason,
    bool? chatAllowed,
  }) {
    return PatientPsychologistRelation(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      psychologistId: psychologistId ?? this.psychologistId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reason: reason ?? this.reason,
      chatAllowed: chatAllowed ?? this.chatAllowed,
    );
  }
}
