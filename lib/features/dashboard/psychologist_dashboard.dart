import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/theme/app_animations.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/core/providers/backend_providers.dart';
import 'package:projetmascara/features/professional/models/session_request_model.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class PsychologistDashboard extends ConsumerWidget {
  const PsychologistDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: Text(l10n.professionalPortal),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(psychologistRequestsProvider);
          ref.invalidate(authorizedPatientsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInAnimation(child: _ProfessionalStatsCard()),
              const SizedBox(height: 32),

              // --- New Session Requests Section ---
              _buildSectionTitle(context, l10n.upcomingAppointments),
              const SizedBox(height: 16),
              _SessionRequestsList(),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      l10n.pendingFollowupRequests,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/psychologist/requests'),
                    child: Text(l10n.all),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              pendingRequestsAsync.when(
                data: (requests) => requests.isEmpty
                    ? Center(child: Text(l10n.noPendingRequests))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: requests.length > 3 ? 3 : requests.length,
                        itemBuilder: (context, index) {
                          final req = requests[index];
                          return FadeInAnimation(
                            delay: Duration(milliseconds: 300 + (index * 100)),
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text("${l10n.user_label} ${req.userId}"),
                                subtitle: Text(
                                  "${l10n.status_label}: ${l10n.pendingAccess}",
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () =>
                                      context.push('/psychologist/requests'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  child: Text(
                                    l10n.viewDetails,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) =>
                    Center(child: Text("${l10n.error_occurred}: $e")),
              ),
              const SizedBox(height: 32),
              FadeInAnimation(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  l10n.professionalTools,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _ToolButton(
                    title: l10n.myPatients,
                    icon: Icons.people_outline,
                    onTap: () => context.push('/psychologist/patients'),
                  ),
                  const SizedBox(width: 16),
                  _ToolButton(
                    title: l10n.reports,
                    icon: Icons.analytics_outlined,
                    onTap: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(l10n.reportTitle)));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _ToolButton(
                    title: 'Compte partenaire',
                    icon: Icons.hub_outlined,
                    onTap: () => context.push('/partner/account'),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 100),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SessionRequestsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final requestsAsync = ref.watch(sessionRequestsProvider);
    final repository = ref.read(professionalRepositoryProvider);

    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text(l10n.loadingError(error.toString())),
      data: (requests) {
        if (requests.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 48,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(height: 12),
                  Text(l10n.noAppointmentRequests, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }

        return Column(
          children: requests.map((request) {
            final isPending = request.status == SessionRequestStatus.PENDING;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  Icons.calendar_month,
                  color: isPending ? Colors.orange : Colors.green,
                ),
                title: Text(l10n.appointmentRequest(request.id)),
                subtitle: Text(
                  '${request.requestedDate.day}/${request.requestedDate.month}/${request.requestedDate.year}'
                  '${request.sessionType == null ? '' : ' - ${request.sessionType}'}\n'
                  '${l10n.statusValue(_statusLabel(request.status, l10n))}',
                ),
                isThreeLine: true,
                trailing: isPending
                    ? Wrap(
                        children: [
                          IconButton(
                            tooltip: l10n.reject,
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              await repository.updateSessionStatus(
                                request.id,
                                SessionRequestStatus.REJECTED,
                              );
                              ref.invalidate(sessionRequestsProvider);
                            },
                          ),
                          IconButton(
                            tooltip: l10n.accept,
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () async {
                              await repository.updateSessionStatus(
                                request.id,
                                SessionRequestStatus.ACCEPTED,
                              );
                              ref.invalidate(sessionRequestsProvider);
                            },
                          ),
                        ],
                      )
                    : Chip(label: Text(_statusLabel(request.status, l10n))),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String _statusLabel(SessionRequestStatus status, AppLocalizations l10n) {
    switch (status) {
      case SessionRequestStatus.PENDING:
        return l10n.sessionStatusPending;
      case SessionRequestStatus.ACCEPTED:
        return l10n.sessionStatusAccepted;
      case SessionRequestStatus.REJECTED:
        return l10n.sessionStatusRejected;
      case SessionRequestStatus.CANCELLED:
        return l10n.sessionStatusCancelled;
      case SessionRequestStatus.COMPLETED:
        return l10n.sessionStatusCompleted;
    }
  }
}

class _ProfessionalStatsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final patientsAsync = ref.watch(authorizedPatientsProvider);
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: patientsAsync.when(
              data: (p) => _StatItem(
                label: l10n.statsPatients,
                value: p.length.toString(),
              ),
              loading: () => _StatItem(label: l10n.statsPatients, value: "..."),
              error: (_, __) =>
                  _StatItem(label: l10n.statsPatients, value: "0"),
            ),
          ),
          Expanded(
            child: pendingRequestsAsync.when(
              data: (r) => _StatItem(
                label: l10n.statsAlerts,
                value: r.length.toString(),
                color: r.isNotEmpty ? Colors.orange : null,
              ),
              loading: () => _StatItem(label: l10n.statsAlerts, value: "..."),
              error: (_, __) => _StatItem(label: l10n.statsAlerts, value: "0"),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SessionRequestModel>>(
              future: ref.read(currentUserProvider) == null
                  ? Future.value(const <SessionRequestModel>[])
                  : ref
                        .read(professionalRepositoryProvider)
                        .getSessionRequests(ref.read(currentUserProvider)!.id),
              builder: (context, snapshot) {
                final count =
                    snapshot.data
                        ?.where(
                          (request) =>
                              request.status == SessionRequestStatus.ACCEPTED ||
                              request.status == SessionRequestStatus.COMPLETED,
                        )
                        .length ??
                    0;
                return _StatItem(
                  label: l10n.statsConsultations,
                  value: snapshot.connectionState == ConnectionState.waiting
                      ? '...'
                      : count.toString(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatItem({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.blueGrey)),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
}
