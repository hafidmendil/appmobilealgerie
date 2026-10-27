import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/providers/local_care_providers.dart';

/// Personal, local-only view of referrals created by the signed-in user.
/// It gives the person control over their own follow-up without presenting a
/// referral as though it had been delivered to a partner.
class LocalReferralsPage extends ConsumerWidget {
  const LocalReferralsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isArabic ? 'توجيهاتي المحلية' : 'Mes orientations locales',
          ),
        ),
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/login'),
            child: Text(isArabic ? 'تسجيل الدخول' : 'Se connecter'),
          ),
        ),
      );
    }
    final referrals = ref.watch(localReferralsProvider(user.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'توجيهاتي المحلية' : 'Mes orientations locales'),
      ),
      body: referrals.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.inbox_outlined, size: 52),
                    const SizedBox(height: 12),
                    Text(
                      isArabic
                          ? 'لم تحفظ أي توجيه محلي بعد.'
                          : 'Vous n’avez pas encore enregistré d’orientation locale.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.go('/orientation/network'),
                      child: Text(
                        isArabic ? 'البحث عن موارد' : 'Chercher des ressources',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    isArabic
                        ? 'هذه قائمة شخصية على جهازك. لا تعني أن الشريك تلقى طلبًا أو بيانات عنك.'
                        : 'Cette liste personnelle reste sur votre appareil. Elle ne signifie pas qu’un partenaire a reçu une demande ou des données à votre sujet.',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (referral) => _ReferralTile(
                  referral: referral,
                  userId: user.id,
                  isArabic: isArabic,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReferralTile extends ConsumerWidget {
  const _ReferralTile({
    required this.referral,
    required this.userId,
    required this.isArabic,
  });

  final Map<String, dynamic> referral;
  final String userId;
  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ref
          .read(localCareRepositoryProvider)
          .partnerById('${referral['partnerId']}'),
      builder: (context, snapshot) {
        final partner = snapshot.data;
        final status = '${referral['status']}';
        final isCancelled = status == 'cancelled_locally';
        final isContacted = status == 'contacted_by_user';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    child: Icon(Icons.handshake_outlined),
                  ),
                  title: Text(
                    partner?['name']?.toString() ??
                        (isArabic ? 'شريك محلي' : 'Partenaire local'),
                  ),
                  subtitle: Text(
                    '${isArabic ? 'السبب' : 'Motif'} : ${referral['reason']}\n'
                    '${isArabic ? 'الحالة' : 'Statut'} : ${_statusLabel(status)}',
                  ),
                  isThreeLine: true,
                ),
                if (!isCancelled)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (!isContacted)
                        OutlinedButton.icon(
                          onPressed: () =>
                              _update(context, ref, 'contacted_by_user'),
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(
                            isArabic
                                ? 'تم التواصل بنفسي'
                                : 'J’ai contacté ce partenaire',
                          ),
                        ),
                      TextButton(
                        onPressed: () =>
                            _update(context, ref, 'cancelled_locally'),
                        child: Text(
                          isArabic ? 'إلغاء محليًا' : 'Annuler localement',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _update(
    BuildContext context,
    WidgetRef ref,
    String status,
  ) async {
    await ref
        .read(localCareRepositoryProvider)
        .updateLocalReferralStatus(
          userId: userId,
          referralId: '${referral['id']}',
          status: status,
        );
    ref.invalidate(localReferralsProvider(userId));
  }

  String _statusLabel(String status) {
    final labelsFr = {
      'local_pending_contact': 'À contacter par vous-même',
      'contacted_by_user': 'Vous avez indiqué avoir pris contact',
      'cancelled_locally': 'Annulée localement',
    };
    final labelsAr = {
      'local_pending_contact': 'بانتظار أن تتواصل بنفسك',
      'contacted_by_user': 'أشرت إلى أنك تواصلت بنفسك',
      'cancelled_locally': 'ألغيت محليًا',
    };
    return (isArabic ? labelsAr : labelsFr)[status] ?? status;
  }
}
