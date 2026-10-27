import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/localization/l10n_extension.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(context.l10n.emg_immediate_help),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              context.l10n.emg_safety_first,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(context.l10n.emg_danger_desc),
            const SizedBox(height: 24),
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.l10n.emg_immediate_action_notice),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _call(context, '14'),
              icon: const Icon(Icons.phone),
              label: Text(context.l10n.emg_protection_civile),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _call(context, '1055'),
              icon: const Icon(Icons.security),
              label: Text(context.l10n.emg_gendarmerie),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/protection/safety-plan'),
              icon: const Icon(Icons.checklist_outlined),
              label: Text(context.l10n.emg_open_safety_plan),
            ),
            TextButton.icon(
              onPressed: () => context.go('/protection'),
              icon: const Icon(Icons.arrow_back),
              label: Text(context.l10n.emg_quick_exit),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _call(BuildContext context, String number) async {
    final launched = await launchUrl(Uri(scheme: 'tel', path: number));
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.emg_call_error(number)),
        ),
      );
    }
  }
}
