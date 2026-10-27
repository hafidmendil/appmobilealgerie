import '../../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/theme/app_theme.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import '../../domain/models/legal_models.dart';
import '../providers/legal_providers.dart';

class ConsentCenterPage extends ConsumerWidget {
  const ConsentCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consent = ref.watch(consentStateProvider);

    if (consent == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.auto_consent_center)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(context.l10n.auto_aucune_demande_consentement_active),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.auto_consent_center_espace_consentement),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: AppColors.primary,
                            size: 32,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.consent_center_title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.l10n.consent_center_notice,
                                  style: const TextStyle(fontSize: 13, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Detail Card
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildConsentDetailItem(
                              icon: Icons.dataset_outlined,
                              title: context.l10n.consent_center_data_usage_q,
                              content: consent.dataTypes.join(' ; '),
                            ),
                            const Divider(height: 24),
                            _buildConsentDetailItem(
                              icon: Icons.psychology_alt_outlined,
                              title: context.l10n.consent_center_purpose_q,
                              content: consent.purpose,
                            ),
                            const Divider(height: 24),
                            _buildConsentDetailItem(
                              icon: Icons.account_balance_outlined,
                              title:
                                  context.l10n.consent_center_recipient_q,
                              content: consent.recipientInstitution,
                            ),
                            const Divider(height: 24),
                            _buildConsentDetailItem(
                              icon: Icons.send_outlined,
                              title:
                                  context.l10n.consent_center_transmission_q,
                              content: consent.transmittedFields.join(' ; '),
                            ),
                            const Divider(height: 24),
                            _buildConsentDetailItem(
                              icon: Icons.timer_outlined,
                              title: context.l10n.consent_center_duration_q,
                              content: consent.retentionPeriod,
                            ),
                            const Divider(height: 24),
                            _buildConsentDetailItem(
                              icon: Icons.touch_app_outlined,
                              title: context.l10n.consent_center_action_q,
                              content: consent.actionToBePerformed,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Trace audit info
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_clock,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.l10n.consent_center_trace_label(
                                consent.checksum.substring(0, 16),
                                consent.consentVersion,
                              ),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Buttons: [Retour] [Modifier] [Confirmer]
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // [Retour]
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(context.l10n.auto_retour),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // [Modifier]
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.push('/legal/report-builder');
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: Text(context.l10n.auto_modifier),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.orange.shade800,
                        side: BorderSide(color: Colors.orange.shade800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // [Confirmer]
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final success = await ref
                            .read(consentStateProvider.notifier)
                            .confirmConsent();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n.consent_center_success_msg,
                              ),
                            ),
                          );
                          context.push('/legal/report-builder');
                        }
                      },
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: Text(context.l10n.auto_confirmer),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentDetailItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
