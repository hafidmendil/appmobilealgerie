import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/data/wilaya_data.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/localization/locale_provider.dart';

import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/widgets/sind_components.dart';

import '../../generated/l10n/app_localizations.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _getWilayaName(UserModel? user, AppLocalizations l10n) {
    if (user?.wilayaId == null) return l10n.select_wilaya_label;
    try {
      final wilaya = algerianWilayas.firstWhere((w) => w.id == user!.wilayaId);
      final name = l10n.localeName == 'ar' ? wilaya.nameAr : wilaya.nameFr;
      return l10n.wilaya_prefix(name);
    } catch (_) {
      return l10n.select_wilaya_label;
    }
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.change_language_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.french_label),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.arabic_label),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showChangePasswordDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    AppLocalizations l10n,
  ) async {
    final current = TextEditingController();
    final next = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: current,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.currentPassword),
            ),
            TextField(
              controller: next,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.newPassword),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      try {
        await ref
            .read(authRepositoryProvider)
            .changePassword(
              userId: user.id,
              currentPassword: current.text,
              newPassword: next.text,
            );
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.action_success)));
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.error_prefix}$error'),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      }
    }
    current.dispose();
    next.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final userName =
        user?.name ?? user?.email.split('@').first ?? l10n.user_label;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(title: Text(l10n.my_profile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.oliveGreen.withAlpha(25),
                    child: const Icon(
                      LucideIcons.user,
                      size: 50,
                      color: AppColors.oliveGreen,
                    ),
                  ).animate().scale(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    userName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user?.email ?? "",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Role specific info
            if (user?.role == UserRole.psychologist)
              _ProfileSection(
                title: l10n.professionalPortal,
                items: [
                  _ProfileItem(
                    icon: LucideIcons.shield_check,
                    title: l10n.status_label,
                    trailing: Text(
                      user?.status == 'approved' ? l10n.statusApproved : l10n.statusPending,
                      style: TextStyle(
                        color: user?.status == 'approved' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            
            if (user?.role == UserRole.psychologist) const SizedBox(height: AppSpacing.lg),

            // Sections
            _ProfileSection(
              title: l10n.my_journey,
              items: [
                _ProfileItem(
                  icon: LucideIcons.history,
                  title: l10n.assessment_history,
                  onTap: () => context.push('/history'),
                ),
                _ProfileItem(
                  icon: LucideIcons.map_pin,
                  title: _getWilayaName(user, l10n),
                  onTap: () => context.push('/wilaya'),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            _ProfileSection(
              title: l10n.preferences_label,
              items: [
                _ProfileItem(
                  icon: LucideIcons.sparkles,
                  title: l10n.spiritual_content_label,
                  trailing: Switch(
                    value: user?.prefSpiritual ?? true,
                    onChanged: (val) {
                      if (user != null) {
                        ref
                            .read(authRepositoryProvider)
                            .updateUser(user.copyWith(prefSpiritual: val));
                      }
                    },
                  ),
                  onTap: () {
                    if (user != null) {
                      ref
                          .read(authRepositoryProvider)
                          .updateUser(
                            user.copyWith(prefSpiritual: !user.prefSpiritual),
                          );
                    }
                  },
                ),
                _ProfileItem(
                  icon: LucideIcons.settings,
                  title: l10n.settings_label,
                  onTap: () => context.push('/settings'),
                ),
                _ProfileItem(
                  icon: LucideIcons.languages,
                  title: l10n.language_label,
                  onTap: () => _showLanguageDialog(context, ref, l10n),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            _ProfileSection(
              title: l10n.security_privacy_label,
              items: [
                _ProfileItem(
                  icon: LucideIcons.shield_check,
                  title: l10n.privacy_label,
                  onTap: () => context.push('/privacy'),
                ),
                if (user != null)
                  _ProfileItem(
                    icon: LucideIcons.key_round,
                    title: user.mustChangePassword
                        ? '${l10n.changePassword} *'
                        : l10n.changePassword,
                    onTap: () =>
                        _showChangePasswordDialog(context, ref, user, l10n),
                  ),
                _ProfileItem(
                  icon: LucideIcons.trash_2,
                  title: l10n.delete_data_label,
                  color: AppColors.danger,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.delete_data_label),
                        content: Text(l10n.delete_question_confirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(l10n.delete_data_label),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      try {
                        await ref
                            .read(authProvider.notifier)
                            .deleteCurrentUserData();
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.action_success)),
                        );
                        context.go('/');
                      } catch (error) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${l10n.error_prefix}$error'),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            SindSecondaryButton(
              label: l10n.logout_label,
              onPressed: () => ref.read(authRepositoryProvider).logout(),
              icon: LucideIcons.log_out,
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_ProfileItem> items;

  const _ProfileSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SindGlassCard(
          color: Colors.white,
          padding: EdgeInsets.zero,
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final Widget? trailing;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.oliveGreen, size: 20),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      trailing:
          trailing ??
          const Icon(
            LucideIcons.chevron_right,
            size: 18,
            color: AppColors.textMuted,
          ),
    );
  }
}
