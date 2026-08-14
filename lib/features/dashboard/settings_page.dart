import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/widgets/sind_components.dart';
import '../../core/localization/locale_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _SettingsSection(
            title: "Application",
            children: [
              _SettingsTile(
                icon: LucideIcons.languages,
                title: "Langue",
                subtitle: locale.languageCode == 'fr' ? "Français" : "العربية",
                onTap: () => _showLanguageDialog(context, ref),
              ),
              _SettingsTile(
                icon: LucideIcons.moon,
                title: "Mode sombre",
                subtitle: "Automatique",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: "Notifications",
            children: [
              SwitchListTile(
                value: true,
                onChanged: (v) {},
                title: const Text("Rappels quotidiens"),
                secondary: const Icon(LucideIcons.bell, color: AppColors.oliveGreen),
                activeColor: AppColors.oliveGreen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: "Support",
            children: [
              _SettingsTile(
                icon: LucideIcons.circle_question_mark,
                title: "Aide & FAQ",
                onTap: () {},
              ),
              _SettingsTile(
                icon: LucideIcons.info,
                title: "À propos",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choisir la langue"),
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
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

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
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.oliveGreen, size: 20),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(LucideIcons.chevron_right, size: 18, color: AppColors.textMuted),
    );
  }
}
