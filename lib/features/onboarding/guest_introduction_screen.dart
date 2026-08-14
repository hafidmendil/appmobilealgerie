import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';

class GuestIntroductionScreen extends StatelessWidget {
  const GuestIntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.warmBeige, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Icon(LucideIcons.shield_check, size: 80, color: AppColors.oliveGreen)
                    .animate().fadeIn().scale(),
                const SizedBox(height: AppSpacing.xxl),
                Text(
                  l10n.purposeTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: AppSpacing.xl),
                _PurposeItem(text: l10n.purposeItem1, delay: 400),
                _PurposeItem(text: l10n.purposeItem2, delay: 600),
                _PurposeItem(text: l10n.purposeItem3, delay: 800, isWarning: true),
                const Spacer(),
                SindPrimaryButton(
                  label: l10n.continueLabel,
                  onPressed: () => context.go('/guest'),
                ).animate().fadeIn(delay: 1.seconds),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => context.go('/'),
                  child: Text(l10n.previous, style: const TextStyle(color: AppColors.textMuted)),
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PurposeItem extends StatelessWidget {
  final String text;
  final int delay;
  final bool isWarning;

  const _PurposeItem({required this.text, required this.delay, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning ? LucideIcons.triangle_alert : LucideIcons.circle_check,
            color: isWarning ? AppColors.warning : AppColors.oliveGreen,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isWarning ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isWarning ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1, end: 0);
  }
}
