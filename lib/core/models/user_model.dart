import 'package:hive/hive.dart';
import 'package:projetmascara/core/auth/user_role.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final UserRole role;

  @HiveField(3)
  final String status; // pending, approved, rejected, active

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final String? wilayaId;

  @HiveField(7)
  final bool prefSpiritual;

  @HiveField(8)
  final bool hasCompletedInitialAssessment;

  @HiveField(9)
  final String? name;

  /// A local second factor can be required for privileged accounts. The
  /// verification secret is intentionally stored in secure storage, not Hive.
  @HiveField(10)
  final bool mfaRequired;

  /// Set after an administrator issues a temporary password. The current UI
  /// records this state; a server-backed deployment must enforce a password
  /// change before granting access to sensitive data.
  @HiveField(11)
  final bool mustChangePassword;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.wilayaId,
    this.prefSpiritual = true,
    this.hasCompletedInitialAssessment = false,
    this.name,
    this.mfaRequired = false,
    this.mustChangePassword = false,
  });

  UserModel copyWith({
    String? id,
    String? email,
    UserRole? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? wilayaId,
    bool? prefSpiritual,
    bool? hasCompletedInitialAssessment,
    String? name,
    bool? mfaRequired,
    bool? mustChangePassword,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      wilayaId: wilayaId ?? this.wilayaId,
      prefSpiritual: prefSpiritual ?? this.prefSpiritual,
      hasCompletedInitialAssessment:
          hasCompletedInitialAssessment ?? this.hasCompletedInitialAssessment,
      name: name ?? this.name,
      mfaRequired: mfaRequired ?? this.mfaRequired,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role.name,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'wilayaId': wilayaId,
      'prefSpiritual': prefSpiritual,
      'hasCompletedInitialAssessment': hasCompletedInitialAssessment,
      'name': name,
      'mfaRequired': mfaRequired,
      'mustChangePassword': mustChangePassword,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.name == json['role']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      wilayaId: json['wilayaId'],
      prefSpiritual: json['prefSpiritual'] ?? true,
      hasCompletedInitialAssessment:
          json['hasCompletedInitialAssessment'] ?? false,
      name: json['name'],
      mfaRequired: json['mfaRequired'] ?? false,
      mustChangePassword: json['mustChangePassword'] ?? false,
    );
  }
}
