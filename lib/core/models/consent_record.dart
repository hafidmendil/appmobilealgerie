class ConsentRecord {
  final String id;
  final String userId;
  final String consentType;
  final String version;
  final DateTime acceptedAt;
  final DateTime? revokedAt;
  final bool isActive;

  const ConsentRecord({
    required this.id,
    required this.userId,
    required this.consentType,
    required this.version,
    required this.acceptedAt,
    this.revokedAt,
    this.isActive = true,
  });

  ConsentRecord copyWith({
    String? id,
    String? userId,
    String? consentType,
    String? version,
    DateTime? acceptedAt,
    DateTime? revokedAt,
    bool? isActive,
  }) {
    return ConsentRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      consentType: consentType ?? this.consentType,
      version: version ?? this.version,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      revokedAt: revokedAt ?? this.revokedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
