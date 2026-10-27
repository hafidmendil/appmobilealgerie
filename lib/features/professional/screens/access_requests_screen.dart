import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/theme/app_animations.dart';
import 'package:projetmascara/core/providers/backend_providers.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/models/user_model.dart';

class AccessRequestsScreen extends ConsumerWidget {
  const AccessRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(pendingRequestsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.accessRequests)),
      body: requestsAsync.when(
        data: (requests) => requests.isEmpty
            ? Center(child: Text(l10n.noPendingRequests))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return FadeInAnimation(
                    delay: Duration(milliseconds: index * 100),
                    child: _RequestCard(request: request),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }
}

class _RequestCard extends ConsumerWidget {
  final AccessRequest request;

  const _RequestCard({required this.request});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(professionalRepositoryProvider);
    final users =
        ref.watch(allUsersProvider).valueOrNull ?? const <UserModel>[];
    UserModel? patient;
    for (final user in users) {
      if (user.id == request.userId) {
        patient = user;
        break;
      }
    }
    final patientLabel = patient?.name ?? patient?.email ?? request.userId;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                patientLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${l10n.user_label}: ${patient?.email ?? request.userId}\n"
                "${l10n.status_label}: ${l10n.pendingAccess}",
                style: const TextStyle(color: Colors.orange),
              ),
            ),
            if (request.message != null && request.message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  request.message!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    await repo.respondToRequest(
                      request.id,
                      AccessRequestStatus.rejected,
                    );
                    ref.invalidate(psychologistRequestsProvider);
                  },
                  child: Text(
                    l10n.reject,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    await repo.respondToRequest(
                      request.id,
                      AccessRequestStatus.accepted,
                    );
                    ref.invalidate(psychologistRequestsProvider);
                    ref.invalidate(authorizedPatientsProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(l10n.accept),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
