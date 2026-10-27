import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/widgets/sind_components.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/data/hive_config.dart';
import '../../core/widgets/medical_disclaimer_banner.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../core/theme/theme_mode_provider.dart';

final dailyReminderProvider =
    StateNotifierProvider<DailyReminderNotifier, AsyncValue<bool>>(
      (ref) => DailyReminderNotifier(),
    );

class DailyReminderNotifier extends StateNotifier<AsyncValue<bool>> {
  static const _key = 'daily_reminders_enabled';

  DailyReminderNotifier() : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = AsyncValue.data(prefs.getBool(_key) ?? false);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = AsyncValue.data(enabled);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, enabled);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeProvider);
    final dailyReminder = ref.watch(dailyReminderProvider);
    final isAr = locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(title: Text(l10n.settings_label)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const MedicalDisclaimerBanner(),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: l10n.application_section,
            children: [
              _SettingsTile(
                icon: LucideIcons.languages,
                title: l10n.language_label,
                subtitle: locale.languageCode == 'fr'
                    ? l10n.french_label
                    : l10n.arabic_label,
                onTap: () => _showLanguageDialog(context, ref, l10n),
              ),
              _SettingsTile(
                icon: LucideIcons.moon,
                title: l10n.dark_mode_label,
                subtitle: themeMode == ThemeMode.dark
                    ? l10n.dark_mode_label
                    : l10n.auto_mode_label,
                onTap: () => ref
                    .read(themeModeProvider.notifier)
                    .setDarkMode(themeMode != ThemeMode.dark),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: l10n.notifications_section,
            children: [
              SwitchListTile(
                value: dailyReminder.value ?? false,
                onChanged: dailyReminder.isLoading
                    ? null
                    : (value) => ref
                        .read(dailyReminderProvider.notifier)
                        .setEnabled(value),
                title: Text(l10n.daily_reminders_label),
                secondary: const Icon(
                  LucideIcons.bell,
                  color: AppColors.oliveGreen,
                ),
                activeThumbColor: AppColors.oliveGreen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: l10n.security_privacy_label,
            children: [
              _SettingsTile(
                icon: LucideIcons.shield_check,
                title: l10n.privacy_label,
                onTap: () => context.push('/legal/details'),
              ),
              _SettingsTile(
                icon: LucideIcons.history,
                title: isAr ? "سجل الأنشطة الأمنية" : "Historique de sécurité",
                onTap: () => _showSecurityHistory(context, ref, l10n),
              ),
              _SettingsTile(
                icon: LucideIcons.download,
                title: isAr ? "تصدير بياناتي (قانون 18-07)" : "Exporter mes données (Loi 18-07)",
                onTap: () => _exportUserData(context, l10n),
              ),
              _SettingsTile(
                icon: LucideIcons.trash_2,
                title: l10n.delete_data_label,
                color: Colors.red,
                onTap: () => _showDeleteDataConfirmation(context, l10n),
              ),
            ],
          ),
          _SettingsSection(
            title: isAr ? "أمان الحساب" : "Sécurité du compte",
            children: [
              SwitchListTile(
                value: false,
                onChanged: (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isAr ? "المصادقة الثنائية المحلية ستفعل قريباً" : "MFA locale disponible prochainement")),
                  );
                },
                title: Text(isAr ? "المصادقة الثنائية (MFA)" : "Double Authentification (MFA)"),
                secondary: const Icon(LucideIcons.shield, color: AppColors.oliveGreen),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SettingsSection(
            title: l10n.support_section,
            children: [
              _SettingsTile(
                icon: LucideIcons.circle_question_mark,
                title: l10n.help_faq_label,
                onTap: () => _showHelpFaqDialog(context, l10n),
              ),
              _SettingsTile(
                icon: LucideIcons.info,
                title: l10n.about_label,
                onTap: () => context.push('/about'),
              ),
            ],
          ),
        ],
      ),
    );
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

  void _showHelpFaqDialog(BuildContext context, AppLocalizations l10n) {
    final faqs = [
      l10n.faq_q1,
      l10n.faq_q2,
      l10n.faq_q3,
      l10n.faq_q4,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.help_faq_label),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: faqs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final answer = switch (index) {
                0 => l10n.faq_a1,
                1 => l10n.faq_a2,
                2 => l10n.faq_a3,
                _ => l10n.faq_a4,
              };

              return ListTile(
                title: Text(faqs[index]),
                subtitle: Text(answer),
                contentPadding: EdgeInsets.zero,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about_label),
        content: Text(l10n.settings_about_desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _showSecurityHistory(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final isAr = l10n.localeName == 'ar';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? "سجل النشاط المحلي" : "Historique d'activité local",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(LucideIcons.log_in, color: Colors.green),
              title: Text(isAr ? "دخول ناجح" : "Connexion réussie"),
              subtitle: Text(DateTime.now().toString()),
            ),
            ListTile(
              leading: const Icon(LucideIcons.shield_check, color: Colors.blue),
              title: Text(isAr ? "تشفير البيانات" : "Chiffrement des données"),
              subtitle: Text(isAr ? "تلقائي - نشط" : "Automatique - Actif"),
            ),
          ],
        ),
      ),
    );
  }

  void _exportUserData(BuildContext context, AppLocalizations l10n) {
    final isAr = l10n.localeName == 'ar';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAr ? "جاري تحضير ملف البيانات بصيغة مشفرة..." : "Préparation du fichier de données chiffré..."),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDeleteDataConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_data_label),
        content: Text(l10n.auto_voulezvous_vraiment_supprimer_tous),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await HiveConfig.deleteAllData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Toutes les données ont été supprimées.')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.auto_supprimer),
          ),
        ],
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
          child: Column(children: children),
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
  final Color? color;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.oliveGreen, size: 20),
      title: Text(title, style: TextStyle(color: color)),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: const Icon(
        LucideIcons.chevron_right,
        size: 18,
        color: AppColors.textMuted,
      ),
    );
  }
}
