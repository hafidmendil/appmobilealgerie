import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.priority_safety_alert),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.danger,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              LucideIcons.shield_alert,
              size: 80,
              color: AppColors.danger,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.summary_urgent_help,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.q_safety_immediate_harm,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xxl),

            _SafetyActionCard(
              title: l10n.res_emergency_name,
              icon: LucideIcons.phone_call,
              color: AppColors.danger,
              onTap: () async {
                final phone =
                    '112'; // numéro d'urgence générique — adapter selon pays
                final uri = Uri(scheme: 'tel', path: phone);
                if (!await launchUrl(uri)) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.error_occurred)));
                }
              },
            ),

            const SizedBox(height: AppSpacing.md),

            _SafetyActionCard(
              title: l10n.trustedContact,
              icon: LucideIcons.user_plus,
              color: AppColors.oliveGreen,
              onTap: () async {
                // Open share sheet to share a prefilled message / number
                final msg = l10n.trustedContactMessage;
                await Share.share(msg);
              },
            ),

            const SizedBox(height: AppSpacing.md),

            _SafetyActionCard(
              title: l10n.resources,
              icon: LucideIcons.map_pin,
              color: AppColors.info,
              onTap: () => context.push('/resources'),
            ),

            const SizedBox(height: AppSpacing.xxl),

            SindSecondaryButton(
              label: l10n.back_to_home,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SafetyActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.largeRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color.withAlpha(12),
          border: Border.all(color: color.withAlpha(51), width: 2),
          borderRadius: AppRadii.largeRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Icon(LucideIcons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
