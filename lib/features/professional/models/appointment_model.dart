enum AppointmentStatus { requested, confirmed, cancelled, completed, noShow }

class AppointmentModel {
  final String id;
  final String patientId;
  final String psychologistId;
  final DateTime scheduledAt;
  final int durationMinutes;
  final AppointmentStatus status;
  final String? notes;
  final DateTime createdAt;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.psychologistId,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? psychologistId,
    DateTime? scheduledAt,
    int? durationMinutes,
    AppointmentStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      psychologistId: psychologistId ?? this.psychologistId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
