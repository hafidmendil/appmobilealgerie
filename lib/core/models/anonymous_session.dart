import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'anonymous_session.g.dart';

@HiveType(typeId: 100)
class AnonymousSession extends HiveObject {
  @HiveField(0)
  final String id; // Random anonymousSessionId

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DateTime expiresAt;

  @HiveField(3)
  final String locale; // fr or ar

  @HiveField(4)
  final String? wilayaId;

  @HiveField(5)
  final String? communeId;

  @HiveField(6)
  final Map<ConsentType, ConsentStatus> consentState;

  AnonymousSession({
    required this.id,
    required this.createdAt,
    required this.expiresAt,
    required this.locale,
    this.wilayaId,
    this.communeId,
    this.consentState = const {},
  });

  AnonymousSession copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? locale,
    String? wilayaId,
    String? communeId,
    Map<ConsentType, ConsentStatus>? consentState,
  }) {
    return AnonymousSession(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      locale: locale ?? this.locale,
      wilayaId: wilayaId ?? this.wilayaId,
      communeId: communeId ?? this.communeId,
      consentState: consentState ?? this.consentState,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'locale': locale,
      'wilayaId': wilayaId,
      'communeId': communeId,
      'consentState': consentState.map((k, v) => MapEntry(k.name, v.name)),
    };
  }

  factory AnonymousSession.fromJson(Map<String, dynamic> json) {
    return AnonymousSession(
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: DateTime.parse(json['expiresAt']),
      locale: json['locale'] ?? 'fr',
      wilayaId: json['wilayaId'],
      communeId: json['communeId'],
      consentState:
          (json['consentState'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(
              ConsentType.values.firstWhere((e) => e.name == k),
              ConsentStatus.values.firstWhere((e) => e.name == v),
            ),
          ) ??
          {},
    );
  }
}
