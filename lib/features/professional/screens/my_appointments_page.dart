import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/neurosync_data.dart';
import '../../../core/providers/backend_providers.dart';
import '../../../core/localization/l10n_extension.dart';
import '../models/session_request_model.dart';
import '../professional_provider.dart';

class MyAppointmentsPage extends ConsumerWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(mySessionRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.my_appointments)),
      body: requestsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('${context.l10n.error_prefix}$error')),
        data: (requests) {
          if (requests.isEmpty) {
            return Center(child: Text(context.l10n.no_appointments));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final account = neuroSyncAccounts.firstWhere(
                (item) => item.id == request.professionalId,
                orElse: () => neuroSyncAccounts.first,
              );
              final canCancel = request.status == SessionRequestStatus.PENDING;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_month,
                    color: _statusColor(request.status),
                  ),
                  title: Text(account.fullName),
                  subtitle: Text(
                    '${request.requestedDate.day}/${request.requestedDate.month}/${request.requestedDate.year}'
                    '${request.sessionType == null ? '' : ' - ${request.sessionType}'}\n'
                    '${context.l10n.localAppointmentDraft}: ${_localStatusLabel(context, request.status)}',
                  ),
                  isThreeLine: true,
                  trailing: canCancel
                      ? IconButton(
                          tooltip: context.l10n.cancel,
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await ref
                                .read(professionalRepositoryProvider)
                                .updateSessionStatus(
                                  request.id,
                                  SessionRequestStatus.CANCELLED,
                                );
                            ref.invalidate(mySessionRequestsProvider);
                          },
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Color _statusColor(SessionRequestStatus status) {
    switch (status) {
      case SessionRequestStatus.PENDING:
        return Colors.orange;
      case SessionRequestStatus.ACCEPTED:
        return Colors.green;
      case SessionRequestStatus.REJECTED:
      case SessionRequestStatus.CANCELLED:
        return Colors.red;
      case SessionRequestStatus.COMPLETED:
        return Colors.blue;
    }
  }

  static String _localStatusLabel(
    BuildContext context,
    SessionRequestStatus status,
  ) {
    return switch (status) {
      SessionRequestStatus.PENDING => context.l10n.localDraftNotShared,
      SessionRequestStatus.CANCELLED => context.l10n.sessionStatusCancelled,
      SessionRequestStatus.ACCEPTED ||
      SessionRequestStatus.REJECTED ||
      SessionRequestStatus.COMPLETED => context.l10n.localDraftNotShared,
    };
  }
}
