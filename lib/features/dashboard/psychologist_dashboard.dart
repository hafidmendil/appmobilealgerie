import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/theme/app_animations.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
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
              FadeInAnimation(
                child: _ProfessionalStatsCard(),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      l10n.pendingFollowupRequests,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                              leading: const CircleAvatar(child: Icon(Icons.person)),
                              title: Text("${l10n.user_label} ${req.userId.substring(0, 8)}"),
                              subtitle: Text("${l10n.status_label}: ${l10n.pendingAccess}"),
                              trailing: ElevatedButton(
                                onPressed: () => context.push('/psychologist/requests'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                child: Text(l10n.viewDetails, style: const TextStyle(fontSize: 12, color: Colors.white)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
              ),
              const SizedBox(height: 32),
              FadeInAnimation(
                delay: const Duration(milliseconds: 600),
                child: Text(
                  l10n.professionalTools,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.reportTitle)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfessionalStatsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final patientsAsync = ref.watch(authorizedPatientsProvider);
    
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
          patientsAsync.when(
            data: (p) => _StatItem(label: l10n.statsPatients, value: p.length.toString()),
            loading: () => _StatItem(label: l10n.statsPatients, value: "..."),
            error: (_, __) => _StatItem(label: l10n.statsPatients, value: "0"),
          ),
          _StatItem(label: l10n.statsAlerts, value: "0", color: Colors.red), // TODO: Real alerts
          _StatItem(label: l10n.statsConsultations, value: "0"), // TODO: Real consultations
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
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.blueGrey)),
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolButton({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
