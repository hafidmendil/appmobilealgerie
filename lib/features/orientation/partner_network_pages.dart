import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/data/hive_config.dart';
import '../../core/localization/l10n_extension.dart';
import '../../core/models/user_model.dart';
import '../../core/providers/local_care_providers.dart';
import '../../core/services/local_care_repository.dart';

/// The account-side view of a partner record.  It purposefully contains no
/// referral details: a local referral is not a message sent to a partner.
class PartnerAccountPage extends ConsumerWidget {
  const PartnerAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.partner_account_title),
        ),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/login'),
            child: Text(l10n.connect_btn),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.partner_account_title),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref
            .read(localCareRepositoryProvider)
            .partnersForAccount(user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final partners = snapshot.data!;
          if (partners.isEmpty) {
            return _PartnerEmptyState(l10n: l10n);
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.partner_account_info),
                ),
              ),
              const SizedBox(height: 16),
              ...partners.map(
                (partner) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.verified_outlined),
                    ),
                    title: Text('${partner['name']}'),
                    subtitle: Text(
                      '${l10n.status_label} : ${partner['status']} · '
                      '${l10n.availability_available} : ${partner['availability']}\n'
                      'Wilaya : ${partner['wilayaId']}',
                    ),
                    isThreeLine: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PartnerEmptyState extends StatelessWidget {
  const _PartnerEmptyState({required this.l10n});
  final dynamic l10n;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link_off_outlined, size: 48),
          const SizedBox(height: 12),
          Text(
            l10n.no_partner_linked,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

/// Admin-only governance screen.  It shows the relationship between a
/// directory profile and the account that administers it, and only an
/// aggregate count of locally saved referrals.
class PartnerNetworkManagementPage extends ConsumerWidget {
  const PartnerNetworkManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentUser = ref.watch(currentUserProvider);
    // Watching this provider gives the list a deterministic refresh after an
    // administrator updates an availability state below.
    ref.watch(localPartnerRelationshipsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.partner_network_management_title),
      ),
      body: FutureBuilder<List<LocalPartnerRelationship>>(
        future: ref.read(localCareRepositoryProvider).partnerRelationships(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final relationships = snapshot.data!;
          if (relationships.isEmpty)
            return _PartnerEmptyState(l10n: l10n);
          final users = Hive.box<UserModel>(HiveConfig.usersBox);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.partner_network_info),
                ),
              ),
              const SizedBox(height: 12),
              ...relationships.map((relationship) {
                final account = relationship.accountUserId == null
                    ? null
                    : users.get(relationship.accountUserId);
                final partner = relationship.partner;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.hub_outlined),
                          ),
                          title: Text('${partner['name']}'),
                          subtitle: Text(
                            account == null
                                ? l10n.no_linked_account
                                : '${l10n.responsible_account} : ${account.name ?? account.email}\n${account.email}',
                          ),
                          isThreeLine: account != null,
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text('${partner['status']}')),
                            Chip(label: Text('${partner['availability']}')),
                            Chip(
                              label: Text(
                                l10n.local_referrals_count(
                                  relationship.localReferralCount,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SegmentedButton<String>(
                          segments: [
                            ButtonSegment(
                              value: 'available',
                              label: Text(l10n.availability_available),
                            ),
                            ButtonSegment(
                              value: 'limited',
                              label: Text(l10n.availability_limited),
                            ),
                            ButtonSegment(
                              value: 'unavailable',
                              label: Text(l10n.availability_unavailable),
                            ),
                          ],
                          selected: {
                            partner['availability'] == 'unknown'
                                ? 'limited'
                                : '${partner['availability']}',
                          },
                          onSelectionChanged: currentUser == null
                              ? null
                              : (selection) async {
                                  await ref
                                      .read(localCareRepositoryProvider)
                                      .setPartnerAvailability(
                                        partnerId: '${partner['id']}',
                                        availability: selection.first,
                                        actorId: currentUser.id,
                                      );
                                  ref.invalidate(
                                    localPartnerRelationshipsProvider,
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
