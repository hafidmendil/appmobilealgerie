import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/config/app_config.dart';
import 'package:go_router/go_router.dart';
import '../admin_provider.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final config = AppConfig.instance;

    // Listen for log cleaning feedback
    ref.listen(adminNotifierProvider, (previous, next) {
      next.when(
        data: (_) {
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.auto_logs_nettoys_avec_succs),
              ),
            );
          }
        },
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erreur lors du nettoyage: $e"),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.globalSettings)),
      body: ListView(
        children: [
          _SectionHeader(title: l10n.systemStats),
          ListTile(
            title: Text(l10n.app_version),
            subtitle: Text(config.version),
            leading: const Icon(Icons.info_outline),
          ),
          ListTile(
            title: Text(l10n.environment),
            subtitle: Text(config.environment.name.toUpperCase()),
            leading: const Icon(Icons.code),
          ),
          if (!config.networkEnabled)
            ListTile(
              title: Text(l10n.offlineMode),
              subtitle: Text(l10n.offlineModeDescription),
              leading: const Icon(Icons.cloud_off_outlined),
            ),
          const Divider(),
          _SectionHeader(title: l10n.administration),
          ListTile(
            title: Text(l10n.securityLogs),
            subtitle: Text(l10n.auditLogsImmutable),
            leading: const Icon(Icons.receipt_long, color: Colors.indigo),
            onTap: () => context.push('/admin/security-logs'),
          ),
          ListTile(
            title: Text(l10n.institutionalReadiness),
            subtitle: Text(l10n.institutionalReadinessSubtitle),
            leading: const Icon(Icons.verified_user, color: Colors.green),
            onTap: () => context.push('/admin/institutional-readiness'),
          ),
          ListTile(
            title: Text(l10n.restart_assessment),
            leading: const Icon(Icons.refresh),
            onTap: () {
              showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(l10n.restart_assessment),
                  content: Text(dialogContext.l10n.reset_algorithm_confirm),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(dialogContext.l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(adminNotifierProvider.notifier)
                            .resetAlgorithm();
                        Navigator.pop(dialogContext);
                      },
                      child: Text(dialogContext.l10n.confirm),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
