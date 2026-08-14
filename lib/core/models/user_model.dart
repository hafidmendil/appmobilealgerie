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
      hasCompletedInitialAssessment: hasCompletedInitialAssessment ?? this.hasCompletedInitialAssessment,
      name: name ?? this.name,
    );
  }
}
