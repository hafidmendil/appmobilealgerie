import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/data/wilaya_data.dart';
import 'package:projetmascara/core/models/wilaya_model.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/theme/tokens/app_radii.dart';
import '../../core/widgets/sind_components.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  String _getWilayaName(UserModel? user) {
    if (user?.wilayaId == null) return "Sélectionner ma Wilaya";
    try {
      final wilaya = algerianWilayas.firstWhere((w) => w.id == user!.wilayaId);
      return "Wilaya : ${wilaya.nameFr}";
    } catch (_) {
      return "Sélectionner ma Wilaya";
    }
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Changer la langue"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Français"),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('fr'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("العربية"),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final userName = user?.email.split('@').first ?? "Utilisateur";

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: const Text("Mon Profil"),
      ),
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
                    backgroundColor: AppColors.oliveGreen.withOpacity(0.1),
                    child: const Icon(LucideIcons.user, size: 50, color: AppColors.oliveGreen),
                  ).animate().scale(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    userName,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? "",
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Sections
            _ProfileSection(
              title: "Mon Parcours",
              items: [
                _ProfileItem(icon: LucideIcons.history, title: "Historique des évaluations", onTap: () => context.push('/history')),
                _ProfileItem(icon: LucideIcons.map_pin, title: _getWilayaName(user), onTap: () => context.push('/wilaya')),
              ],
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            _ProfileSection(
              title: "Préférences",
              items: [
                _ProfileItem(
                  icon: LucideIcons.sparkles, 
                  title: "Contenu spirituel", 
                  trailing: Switch(
                    value: user?.prefSpiritual ?? true,
                    onChanged: (val) {
                      if (user != null) {
                        ref.read(authRepositoryProvider).updateUser(user.copyWith(prefSpiritual: val));
                      }
                    },
                  ),
                  onTap: () {},
                ),
                _ProfileItem(icon: LucideIcons.settings, title: "Paramètres", onTap: () => context.push('/settings')),
                _ProfileItem(icon: LucideIcons.languages, title: "Langue", onTap: () => _showLanguageDialog(context, ref)),
              ],
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            _ProfileSection(
              title: "Sécurité & Confidentialité",
              items: [
                _ProfileItem(icon: LucideIcons.shield_check, title: "Confidentialité", onTap: () => context.push('/privacy')),
                _ProfileItem(icon: LucideIcons.trash_2, title: "Supprimer mes données", color: AppColors.danger, onTap: () {}),
              ],
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            SindSecondaryButton(
              label: "Se déconnecter",
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
          padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
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
          child: Column(
            children: items,
          ),
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
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 16),
      ),
      trailing: trailing ?? const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textMuted),
    );
  }
}
