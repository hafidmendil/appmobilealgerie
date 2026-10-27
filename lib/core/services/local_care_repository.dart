import 'dart:math' as math;

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../data/hive_config.dart';

/// Local-first persistence for the care network.
///
/// This repository deliberately never sends data outside the device.  A future
/// remote implementation can use the same records, but must enforce server-side
/// authorisation, consent and acknowledgement before it can mark anything as
/// transmitted.
class LocalCareRepository {
  LocalCareRepository({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  Box<dynamic> get _partners => Hive.box<dynamic>(HiveConfig.partnerBox);
  Box<dynamic> get _referrals => Hive.box<dynamic>(HiveConfig.referralBox);
  Box<dynamic> get _consents => Hive.box<dynamic>(HiveConfig.consentBox);
  Box<dynamic> get _reports => Hive.box<dynamic>(HiveConfig.reportsBox);
  Box<dynamic> get _notifications =>
      Hive.box<dynamic>(HiveConfig.notificationsBox);
  Box<dynamic> get _audit => Hive.box<dynamic>(HiveConfig.protectionAuditBox);

  /// Partner records are local directory entries.  They are not considered
  /// eligible for orientation until an administrator has set `verified=true`.
  Future<Map<String, dynamic>> savePartner({
    String? id,
    required String name,
    required String type,
    required String specialty,
    required String wilayaId,
    String communeId = '',
    String contact = '',
    String availability = 'unknown',
    List<String> services = const [],
    List<String> supportedSituations = const [],
    List<String> supportedRiskLevels = const [],
    List<String> languages = const ['fr', 'ar'],
    double? latitude,
    double? longitude,
    bool verified = false,
    String status = 'pending',
    bool active = true,
    String? accountUserId,
    String? actorId,
  }) async {
    final now = DateTime.now().toUtc();
    final partnerId = id ?? _uuid.v4();
    final existing = _map(_partners.get(partnerId));
    final partner = <String, dynamic>{
      'id': partnerId,
      'name': name.trim(),
      'type': type.trim(),
      'specialty': specialty.trim(),
      'wilayaId': wilayaId.trim(),
      'communeId': communeId.trim(),
      'contact': contact.trim(),
      'availability': availability,
      'services': services,
      'supportedSituations': supportedSituations,
      'supportedRiskLevels': supportedRiskLevels,
      'languages': languages,
      'latitude': latitude,
      'longitude': longitude,
      'verified': verified,
      'status': status,
      'active': active,
      // A directory entry may be administered by a professional account.  This
      // link is only for local governance and must never be treated as consent
      // to disclose a person's referral to that account.
      'accountUserId': accountUserId?.trim().isEmpty ?? true
          ? existing['accountUserId']
          : accountUserId!.trim(),
      'createdAt': existing['createdAt'] ?? now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };
    await _partners.put(partnerId, partner);
    await _log(actorId, 'partner_saved', 'partner', partnerId);
    return partner;
  }

  Future<List<Map<String, dynamic>>> partners({
    bool verifiedOnly = false,
    String? wilayaId,
  }) async {
    final items = _partners.values.map(_map).where((partner) {
      if (partner['active'] != true) return false;
      if (verifiedOnly &&
          (partner['verified'] != true || partner['status'] != 'approved')) {
        return false;
      }
      return wilayaId == null || partner['wilayaId'] == wilayaId;
    }).toList();
    items.sort((a, b) => '${a['name']}'.compareTo('${b['name']}'));
    return items;
  }

  Future<Map<String, dynamic>?> partnerById(String partnerId) async {
    final partner = _map(_partners.get(partnerId));
    return partner.isEmpty ? null : partner;
  }

  /// Local deterministic matching.  Nearby is a scoring preference, never a
  /// claim that a professional is geographically close unless coordinates are
  /// available for both sides.
  Future<List<LocalPartnerMatch>> matchPartners({
    required String specialty,
    required String situation,
    required String riskLevel,
    String? wilayaId,
    String? communeId,
    String language = 'fr',
    double? latitude,
    double? longitude,
  }) async {
    final candidates = await partners(verifiedOnly: true);
    final matches = <LocalPartnerMatch>[];
    final isArabic = language == 'ar';
    String localized(String french, String arabic) =>
        isArabic ? arabic : french;
    for (final partner in candidates) {
      if (partner['availability'] == 'unavailable') continue;
      var score = 0.0;
      final reasons = <String>[];
      if (_equals(partner['specialty'], specialty) ||
          _equals(partner['type'], specialty)) {
        score += 35;
        reasons.add(localized('Spécialité adaptée', 'اختصاص مناسب'));
      } else {
        continue;
      }
      if (wilayaId != null && partner['wilayaId'] == wilayaId) {
        score += 25;
        reasons.add(localized('Même wilaya', 'نفس الولاية'));
      }
      if (communeId != null &&
          communeId.isNotEmpty &&
          partner['communeId'] == communeId) {
        score += 15;
        reasons.add(localized('Même commune', 'نفس البلدية'));
      }
      if (_contains(partner['supportedSituations'], situation)) {
        score += 10;
        reasons.add(localized('Situation prise en charge', 'الوضعية مدعومة'));
      }
      if (_contains(partner['supportedRiskLevels'], riskLevel)) {
        score += 10;
        reasons.add(
          localized('Niveau de besoin pris en charge', 'مستوى الحاجة مدعوم'),
        );
      }
      if (_contains(partner['languages'], language)) {
        score += 5;
        reasons.add(localized('Langue disponible', 'اللغة متاحة'));
      }
      final distance = _distanceKm(
        latitude,
        longitude,
        _double(partner['latitude']),
        _double(partner['longitude']),
      );
      if (distance != null) {
        score += distance <= 10
            ? 15
            : distance <= 50
            ? 8
            : 0;
        reasons.add(
          localized(
            'Distance estimée : ${distance.toStringAsFixed(1)} km',
            'المسافة التقديرية: ${distance.toStringAsFixed(1)} كم',
          ),
        );
      }
      if (partner['availability'] == 'available') {
        score += 5;
        reasons.add(localized('Disponibilité déclarée', 'التوفر المعلن'));
      }
      matches.add(
        LocalPartnerMatch(
          partner: partner,
          score: score,
          reasons: reasons,
          distanceKm: distance,
        ),
      );
    }
    matches.sort((a, b) => b.score.compareTo(a.score));
    return matches;
  }

  Future<Map<String, dynamic>> grantConsent({
    required String userId,
    required String type,
    required String purpose,
    required List<String> dataFields,
    String? recipientId,
    String version = '1.0-local',
  }) async {
    final now = DateTime.now().toUtc();
    final record = <String, dynamic>{
      'id': _uuid.v4(),
      'userId': userId,
      'type': type,
      'purpose': purpose,
      'dataFields': dataFields,
      'recipientId': recipientId,
      'version': version,
      'status': 'granted',
      'grantedAt': now.toIso8601String(),
      'revokedAt': null,
    };
    await _consents.put(record['id'], record);
    await _log(userId, 'consent_granted', 'consent', record['id']);
    return record;
  }

  Future<void> revokeConsent({
    required String consentId,
    required String userId,
  }) async {
    final existing = _map(_consents.get(consentId));
    if (existing.isEmpty || existing['userId'] != userId) {
      throw StateError('Consentement introuvable ou non autorisé.');
    }
    existing['status'] = 'revoked';
    existing['revokedAt'] = DateTime.now().toUtc().toIso8601String();
    await _consents.put(consentId, existing);
    await _log(userId, 'consent_revoked', 'consent', consentId);
  }

  Future<bool> hasActiveConsent({
    required String userId,
    required String type,
    String? recipientId,
  }) async {
    return _consents.values
        .map(_map)
        .any(
          (consent) =>
              consent['userId'] == userId &&
              consent['type'] == type &&
              consent['status'] == 'granted' &&
              (recipientId == null || consent['recipientId'] == recipientId),
        );
  }

  Future<Map<String, dynamic>> createReferral({
    required String userId,
    required String partnerId,
    required String reason,
    required String consentId,
    String? assessmentId,
  }) async {
    final consent = _map(_consents.get(consentId));
    if (consent['userId'] != userId ||
        consent['status'] != 'granted' ||
        consent['type'] != 'partner_referral') {
      throw StateError('Un consentement actif de mise en relation est requis.');
    }
    final partner = _map(_partners.get(partnerId));
    if (partner.isEmpty ||
        partner['verified'] != true ||
        partner['status'] != 'approved' ||
        partner['active'] != true ||
        partner['availability'] == 'unavailable') {
      throw StateError('Partenaire non vérifié ou indisponible.');
    }
    final now = DateTime.now().toUtc();
    final referral = <String, dynamic>{
      'id': _uuid.v4(),
      'userId': userId,
      'partnerId': partnerId,
      'reason': reason.trim(),
      'consentId': consentId,
      'assessmentId': assessmentId,
      'status': 'local_pending_contact',
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'transmission': 'not_transmitted',
    };
    await _referrals.put(referral['id'], referral);
    await _notify(
      userId,
      'Orientation enregistrée localement',
      'Aucune donnée n’a été envoyée au partenaire. Contactez-le uniquement si vous le souhaitez.',
    );
    await _log(userId, 'referral_created_local', 'referral', referral['id']);
    return referral;
  }

  Future<Map<String, dynamic>> createLocalReport({
    required String? userId,
    required String reporterMode,
    required List<String> violenceTypes,
    required String context,
    required String severity,
    required String description,
    String? approximateLocation,
    String? consentId,
  }) async {
    final now = DateTime.now().toUtc();
    final report = <String, dynamic>{
      'id': _uuid.v4(),
      'userId': reporterMode == 'anonymous' ? null : userId,
      'reporterMode': reporterMode,
      'violenceTypes': violenceTypes,
      'context': context,
      'severity': severity,
      'description': description.trim(),
      'approximateLocation': approximateLocation?.trim(),
      'consentId': consentId,
      'status': 'saved_locally',
      'transmission': 'not_transmitted',
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };
    await _reports.put(report['id'], report);
    if (userId != null) {
      await _notify(
        userId,
        'Brouillon de signalement enregistré',
        'Ce dossier reste sur cet appareil et n’a été envoyé à aucune institution.',
      );
    }
    await _log(userId, 'local_report_saved', 'report', report['id']);
    return report;
  }

  Future<List<Map<String, dynamic>>> reportsForUser(String? userId) async {
    return _reports.values
        .map(_map)
        .where((report) => report['userId'] == userId)
        .toList()
      ..sort((a, b) => '${b['createdAt']}'.compareTo('${a['createdAt']}'));
  }

  Future<List<Map<String, dynamic>>> referralsForUser(String userId) async {
    return _referrals.values
        .map(_map)
        .where((referral) => referral['userId'] == userId)
        .toList()
      ..sort((a, b) => '${b['createdAt']}'.compareTo('${a['createdAt']}'));
  }

  /// Updates the person's own local follow-up marker.  This is not a partner
  /// workflow and it does not transmit, notify, or expose any data externally.
  Future<void> updateLocalReferralStatus({
    required String userId,
    required String referralId,
    required String status,
  }) async {
    const allowed = {
      'local_pending_contact',
      'contacted_by_user',
      'cancelled_locally',
    };
    if (!allowed.contains(status)) {
      throw ArgumentError.value(status, 'status');
    }
    final referral = _map(_referrals.get(referralId));
    if (referral.isEmpty || referral['userId'] != userId) {
      throw StateError('Orientation introuvable ou non autorisée.');
    }
    referral['status'] = status;
    referral['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    await _referrals.put(referralId, referral);
    await _log(userId, 'referral_local_status_updated', 'referral', referralId);
  }

  /// Returns the verified partner profiles administered by a signed-in
  /// professional.  It exposes directory metadata only, never a service user's
  /// report, assessment or referral content.
  Future<List<Map<String, dynamic>>> partnersForAccount(
    String accountUserId,
  ) async {
    final items = _partners.values
        .map(_map)
        .where(
          (partner) =>
              partner['accountUserId'] == accountUserId &&
              partner['active'] == true,
        )
        .toList();
    items.sort((a, b) => '${a['name']}'.compareTo('${b['name']}'));
    return items;
  }

  /// Relationship summary for an administrator.  The result is deliberately
  /// aggregate-only: it helps govern the local network without exposing the
  /// identity or sensitive content of people requesting help.
  Future<List<LocalPartnerRelationship>> partnerRelationships() async {
    final items = await partners();
    return items
        .map(
          (partner) => LocalPartnerRelationship(
            partner: partner,
            accountUserId: partner['accountUserId']?.toString(),
            localReferralCount: _referrals.values
                .map(_map)
                .where((referral) => referral['partnerId'] == partner['id'])
                .length,
          ),
        )
        .toList();
  }

  Future<void> setPartnerAvailability({
    required String partnerId,
    required String availability,
    required String actorId,
  }) async {
    if (!const {
      'available',
      'limited',
      'unavailable',
      'unknown',
    }.contains(availability)) {
      throw ArgumentError.value(availability, 'availability');
    }
    final partner = _map(_partners.get(partnerId));
    if (partner.isEmpty) throw StateError('Partenaire introuvable.');
    partner['availability'] = availability;
    partner['updatedAt'] = DateTime.now().toUtc().toIso8601String();
    await _partners.put(partnerId, partner);
    await _log(actorId, 'partner_availability_updated', 'partner', partnerId);
  }

  Future<List<Map<String, dynamic>>> notificationsForUser(String userId) async {
    return _notifications.values
        .map(_map)
        .where((item) => item['userId'] == userId)
        .toList()
      ..sort((a, b) => '${b['createdAt']}'.compareTo('${a['createdAt']}'));
  }

  Future<void> _notify(String userId, String title, String body) async {
    final item = <String, dynamic>{
      'id': _uuid.v4(),
      'userId': userId,
      'title': title,
      'body': body,
      'isRead': false,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
    await _notifications.put(item['id'], item);
  }

  Future<void> _log(
    String? actorId,
    String action,
    String targetType,
    String targetId,
  ) async {
    final item = <String, dynamic>{
      'id': _uuid.v4(),
      'actorId': actorId,
      'action': action,
      'targetType': targetType,
      'targetId': targetId,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    await _audit.put(item['id'], item);
  }

  static Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
  static bool _equals(dynamic value, String expected) =>
      '${value ?? ''}'.toLowerCase() == expected.toLowerCase();
  static bool _contains(dynamic values, String value) =>
      values is Iterable &&
      values.any((item) => '$item'.toLowerCase() == value.toLowerCase());
  static double? _double(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value');

  static double? _distanceKm(
    double? lat1,
    double? lon1,
    double? lat2,
    double? lon2,
  ) {
    if ([lat1, lon1, lat2, lon2].any((value) => value == null)) return null;
    // Equirectangular approximation: suitable only to rank local suggestions.
    const earthRadiusKm = 6371.0;
    final x =
        (lon2! - lon1!) *
        0.017453292519943295 *
        math.cos((lat1! + lat2!) * 0.008726646259971648);
    final y = (lat2 - lat1) * 0.017453292519943295;
    return earthRadiusKm * math.sqrt(x * x + y * y);
  }
}

class LocalPartnerMatch {
  const LocalPartnerMatch({
    required this.partner,
    required this.score,
    required this.reasons,
    this.distanceKm,
  });
  final Map<String, dynamic> partner;
  final double score;
  final List<String> reasons;
  final double? distanceKm;
}

class LocalPartnerRelationship {
  const LocalPartnerRelationship({
    required this.partner,
    required this.accountUserId,
    required this.localReferralCount,
  });

  final Map<String, dynamic> partner;
  final String? accountUserId;
  final int localReferralCount;
}
