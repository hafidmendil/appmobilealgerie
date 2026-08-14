import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatisticsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.administration),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).logout(),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.systemStats,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(
                    title: l10n.activeUsers,
                    value: stats['totalUsers'].toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: l10n.pendingProfessionals,
                    value: stats['pendingProfessionals'].toString(),
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: l10n.totalAssessments,
                    value: stats['totalAssessments'].toString(),
                    icon: Icons.assessment,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: l10n.securityAlerts,
                    value: stats['pendingAccessRequests'].toString(),
                    icon: Icons.security,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                "Gestion du Contenu",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _MenuTile(
                title: "Bibliothèque Coranique",
                subtitle: "Gérer les versets et thèmes",
                icon: Icons.book,
                onTap: () {},
              ),
              _MenuTile(
                title: "Hadiths & Hikam",
                subtitle: "Gérer les sagesses et sources",
                icon: Icons.auto_stories,
                onTap: () {},
              ),
              _MenuTile(
                title: "Questionnaire & Logique",
                subtitle: "Modifier les questions et l'algorithme",
                icon: Icons.psychology,
                onTap: () {},
              ),
              const SizedBox(height: 32),
              Text(
                l10n.quickActions,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _MenuTile(
                title: l10n.professionalManagement,
                subtitle: "${stats['pendingProfessionals']} ${l10n.statusPending}",
                icon: Icons.verified_user,
                onTap: () => context.push('/admin/professionals'),
              ),
              _MenuTile(
                title: l10n.userManagement,
                subtitle: l10n.viewAll,
                icon: Icons.person_search,
                onTap: () => context.push('/admin/users'),
              ),
              _MenuTile(
                title: l10n.securityLogs,
                subtitle: l10n.recentActivity,
                icon: Icons.list_alt,
                onTap: () => context.push('/admin/security-logs'),
              ),
              _MenuTile(
                title: l10n.globalSettings,
                subtitle: l10n.administration,
                icon: Icons.settings,
                onTap: () => context.push('/admin/settings'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
