import 'package:hive/hive.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/services/admin/hive_security_log_repository.dart';
import 'package:uuid/uuid.dart';

enum InstitutionalApprovalArea { legal, medical, institutional }

class InstitutionalApproval {
  final InstitutionalApprovalArea area;
  final bool approved;
  final String reviewerName;
  final String reference;
  final String notes;
  final DateTime? decidedAt;

  const InstitutionalApproval({
    required this.area,
    required this.approved,
    this.reviewerName = '',
    this.reference = '',
    this.notes = '',
    this.decidedAt,
  });

  factory InstitutionalApproval.fromMap(
    InstitutionalApprovalArea area,
    Map<dynamic, dynamic>? map,
  ) {
    return InstitutionalApproval(
      area: area,
      approved: map?['approved'] == true,
      reviewerName: map?['reviewerName'] as String? ?? '',
      reference: map?['reference'] as String? ?? '',
      notes: map?['notes'] as String? ?? '',
      decidedAt: map?['decidedAt'] == null
          ? null
          : DateTime.tryParse(map!['decidedAt'] as String),
    );
  }
}

/// Local, encrypted register of release approvals. It is appropriate for a
/// pilot managed on one device; it is not a replacement for signed records or
/// independent institutional governance.
class InstitutionalReadinessService {
  static const _uuid = Uuid();

  Box<dynamic> get _box =>
      Hive.box<dynamic>(HiveConfig.institutionalControlsBox);

  String _key(InstitutionalApprovalArea area) => 'approval_${area.name}';

  Future<List<InstitutionalApproval>> getApprovals() async {
    return InstitutionalApprovalArea.values
        .map(
          (area) => InstitutionalApproval.fromMap(
            area,
            _box.get(_key(area)) as Map<dynamic, dynamic>?,
          ),
        )
        .toList();
  }

  Future<bool> isPublicReleaseReady() async {
    final approvals = await getApprovals();
    return approvals.every((approval) => approval.approved);
  }

  Future<void> setApproval({
    required UserModel actor,
    required InstitutionalApprovalArea area,
    required bool approved,
    String reviewerName = '',
    String reference = '',
    String notes = '',
  }) async {
    if (actor.role != UserRole.admin) {
      throw StateError('Seul un administrateur peut modifier le registre');
    }
    if (approved && (reviewerName.trim().isEmpty || reference.trim().isEmpty)) {
      throw ArgumentError(
        'Le nom du valideur et la référence sont obligatoires',
      );
    }

    final now = DateTime.now().toUtc();
    await _box.put(_key(area), <String, dynamic>{
      'approved': approved,
      'reviewerName': approved ? reviewerName.trim() : '',
      'reference': approved ? reference.trim() : '',
      'notes': approved ? notes.trim() : '',
      'decidedAt': now.toIso8601String(),
    });

    await HiveSecurityLogRepository().logEvent(
      SecurityLog(
        id: _uuid.v4(),
        actorId: actor.id,
        actorRole: actor.role.name,
        action: approved
            ? 'institutional_approval_granted'
            : 'institutional_approval_revoked',
        targetId: area.name,
        timestamp: now,
        status: 'success',
        metadata: approved ? {'reference': reference.trim()} : null,
      ),
    );
  }
}
