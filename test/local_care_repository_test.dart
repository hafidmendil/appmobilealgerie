import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/services/local_care_repository.dart';

void main() {
  late Directory directory;
  late LocalCareRepository repository;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('neurosync_local_care_');
    Hive.init(directory.path);
    for (final box in [
      HiveConfig.partnerBox,
      HiveConfig.referralBox,
      HiveConfig.consentBox,
      HiveConfig.reportsBox,
      HiveConfig.notificationsBox,
      HiveConfig.protectionAuditBox,
    ]) {
      await Hive.openBox<dynamic>(box);
    }
    repository = LocalCareRepository();
  });

  tearDownAll(() async {
    await Hive.close();
    await directory.delete(recursive: true);
  });

  test('only approved local partners can be matched', () async {
    await repository.savePartner(
      id: 'approved',
      name: 'Psychologue vérifié',
      type: 'psychologist',
      specialty: 'psychologist',
      wilayaId: '29',
      availability: 'available',
      supportedSituations: const ['victim'],
      supportedRiskLevels: const ['moderate'],
      verified: true,
      status: 'approved',
    );
    await repository.savePartner(
      id: 'pending',
      name: 'Profil en attente',
      type: 'psychologist',
      specialty: 'psychologist',
      wilayaId: '29',
      verified: false,
      status: 'pending',
    );

    final matches = await repository.matchPartners(
      specialty: 'psychologist',
      situation: 'victim',
      riskLevel: 'moderate',
      wilayaId: '29',
    );

    expect(matches, hasLength(1));
    expect(matches.single.partner['id'], 'approved');
    expect(matches.single.reasons, contains('Même wilaya'));
  });

  test('a revoked consent blocks a new local referral', () async {
    final consent = await repository.grantConsent(
      userId: 'user-1',
      type: 'partner_referral',
      purpose: 'test',
      dataFields: const ['wilaya'],
      recipientId: 'approved',
    );
    final referral = await repository.createReferral(
      userId: 'user-1',
      partnerId: 'approved',
      reason: 'orientation',
      consentId: '${consent['id']}',
    );
    expect(referral['transmission'], 'not_transmitted');

    await repository.revokeConsent(
      consentId: '${consent['id']}',
      userId: 'user-1',
    );
    await expectLater(
      repository.createReferral(
        userId: 'user-1',
        partnerId: 'approved',
        reason: 'orientation',
        consentId: '${consent['id']}',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test(
    'partner account links are governance-only and unavailable partners hide',
    () async {
      await repository.savePartner(
        id: 'linked-partner',
        name: 'Partenaire lié',
        type: 'psychologist',
        specialty: 'psychologist',
        wilayaId: '16',
        availability: 'available',
        supportedSituations: const ['witness'],
        supportedRiskLevels: const ['low'],
        verified: true,
        status: 'approved',
        accountUserId: 'partner-account-1',
      );

      expect(
        (await repository.partnersForAccount('partner-account-1')).single['id'],
        'linked-partner',
      );

      await repository.setPartnerAvailability(
        partnerId: 'linked-partner',
        availability: 'unavailable',
        actorId: 'admin-1',
      );
      final matches = await repository.matchPartners(
        specialty: 'psychologist',
        situation: 'witness',
        riskLevel: 'low',
        wilayaId: '16',
      );
      expect(
        matches.map((match) => match.partner['id']),
        isNot(contains('linked-partner')),
      );

      final relationship = (await repository.partnerRelationships()).firstWhere(
        (item) => item.partner['id'] == 'linked-partner',
      );
      expect(relationship.accountUserId, 'partner-account-1');
      expect(relationship.localReferralCount, 0);
    },
  );

  test('a user controls only their own local referral follow-up', () async {
    final consent = await repository.grantConsent(
      userId: 'user-follow-up',
      type: 'partner_referral',
      purpose: 'test',
      dataFields: const ['motif'],
      recipientId: 'approved',
    );
    final referral = await repository.createReferral(
      userId: 'user-follow-up',
      partnerId: 'approved',
      reason: 'orientation',
      consentId: '${consent['id']}',
    );
    await repository.updateLocalReferralStatus(
      userId: 'user-follow-up',
      referralId: '${referral['id']}',
      status: 'contacted_by_user',
    );
    expect(
      (await repository.referralsForUser('user-follow-up')).single['status'],
      'contacted_by_user',
    );
    await expectLater(
      repository.updateLocalReferralStatus(
        userId: 'another-user',
        referralId: '${referral['id']}',
        status: 'cancelled_locally',
      ),
      throwsA(isA<StateError>()),
    );
  });
}
