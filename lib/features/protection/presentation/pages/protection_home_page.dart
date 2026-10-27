import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/l10n_extension.dart';

class ProtectionHomePage extends StatelessWidget {
  const ProtectionHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.prot_home_title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(context.l10n.prot_home_notice),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.warning_amber_rounded),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              minimumSize: const Size.fromHeight(56),
            ),
            onPressed: () => context.push('/protection/emergency'),
            label: Text(context.l10n.prot_danger_now),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.psychology_alt_outlined),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            onPressed: () => context.push('/protection/flow'),
            label: Text(context.l10n.prot_understand_violence),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.gavel_outlined),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () => context.push('/legal'),
            label: Text(context.l10n.prot_legal_orientation),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.edit_note),
            onPressed: () => context.push('/protection/report'),
            label: Text(context.l10n.prot_report_situation),
          ),
          ListTile(
            leading: const Icon(Icons.shield_outlined),
            title: Text(context.l10n.prot_privacy),
            onTap: () => context.push('/protection/privacy'),
          ),
          ListTile(
            leading: const Icon(Icons.air),
            title: Text(context.l10n.prot_breathing_exercise),
            onTap: () => context.push('/protection/breathing'),
          ),
          ListTile(
            leading: const Icon(Icons.library_books_outlined),
            title: Text(context.l10n.prot_verified_resources),
            onTap: () => context.push('/protection/resources'),
          ),
          ListTile(
            leading: const Icon(Icons.hub_outlined),
            title: Text(context.l10n.prot_local_partners),
            subtitle: Text(context.l10n.prot_local_partners_desc),
            onTap: () => context.push('/orientation/network'),
          ),
          ListTile(
            leading: const Icon(Icons.fact_check_outlined),
            title: Text(context.l10n.prot_training_scenarios),
            subtitle: Text(context.l10n.prot_training_scenarios_desc),
            onTap: () => context.push('/protection/scenarios'),
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: Text(context.l10n.prot_local_reports),
            onTap: () => context.push('/protection/reports'),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: Text(context.l10n.prot_safety_plan),
            onTap: () => context.push('/protection/safety-plan'),
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: Text(context.l10n.prot_vocal_exercise),
            onTap: () => context.push('/protection/voice'),
          ),
        ],
      ),
    );
  }
}
