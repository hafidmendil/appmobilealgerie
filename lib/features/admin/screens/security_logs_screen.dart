import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SecurityLogsScreen extends ConsumerWidget {
  const SecurityLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(securityLogsProvider);
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityLogs)),
      body: logsAsync.when(
        data: (logs) {
          if (logs.isEmpty) {
            return Center(child: Text(l10n.noLogsFound));
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading: Icon(
                    log.status == 'success'
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    color: log.status == 'success' ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    log.action.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(dateFormat.format(log.timestamp)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LogDetailRow(
                            label: l10n.actor,
                            value: "${log.actorRole} (${log.actorId})",
                          ),
                          if (log.targetId != null)
                            _LogDetailRow(
                              label: l10n.target,
                              value: log.targetId!,
                            ),
                          _LogDetailRow(
                            label: l10n.status_label,
                            value: log.status,
                          ),
                          if (log.metadata != null) ...[
                            const SizedBox(height: 8),
                            const Text(
                              "Metadata:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...log.metadata!.entries.map(
                              (e) => Text("  ${e.key}: ${e.value}"),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }
}

class _LogDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _LogDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
