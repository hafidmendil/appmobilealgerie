import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../generated/l10n/app_localizations.dart';

class PsychologistPendingScreen extends ConsumerWidget {
  const PsychologistPendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.shield_alert,
                size: 100,
                color: Colors.orange,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.professionalPendingTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                l10n.professionalPendingMessage(user?.email ?? ''),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              SindPrimaryButton(
                label: l10n.refresh,
                onPressed: () {
                  // This will trigger a re-fetch of the auth state if implemented,
                  // or just notify the UI to rebuild.
                  ref.invalidate(authStateProvider);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              SindSecondaryButton(
                label: l10n.logout_label,
                onPressed: () => ref.read(authRepositoryProvider).logout(),
                icon: LucideIcons.log_out,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
