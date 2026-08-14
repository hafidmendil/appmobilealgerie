import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/config/app_config.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final config = AppConfig.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.globalSettings),
      ),
      body: ListView(
        children: [
          _SectionHeader(title: l10n.systemStats),
          ListTile(
            title: const Text("Version de l'application"),
            subtitle: Text(config.version),
            leading: const Icon(Icons.info_outline),
          ),
          ListTile(
            title: const Text("Environnement"),
            subtitle: Text(config.environment.name.toUpperCase()),
            leading: const Icon(Icons.code),
          ),
          const Divider(),
          _SectionHeader(title: "Maintenance"),
          ListTile(
            title: const Text("Vider les logs de sécurité"),
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            onTap: () {
              // Implementation would go here
            },
          ),
          ListTile(
            title: const Text("Réinitialiser le cache système"),
            leading: const Icon(Icons.refresh),
            onTap: () {
              // Implementation would go here
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
