import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/localization/localization_utils.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminStatisticsProvider);
    final l10n = AppLocalizations.of(context)!;

    // Listen to admin notifier for feedback
    ref.listen(adminNotifierProvider, (previous, next) {
      next.when(
        data: (_) {
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.action_success)));
          }
        },
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.action_error(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        },
        loading: () {},
      );
    });

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
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _StatCard(
                    title: l10n.activeUsers,
                    value: LocalizationUtils.formatNumber(
                      stats['totalUsers'] ?? 0,
                      context,
                    ),
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    title: l10n.pendingProfessionals,
                    value: LocalizationUtils.formatNumber(
                      stats['pendingProfessionals'] ?? 0,
                      context,
                    ),
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                  _StatCard(
                    title: l10n.totalAssessments,
                    value: LocalizationUtils.formatNumber(
                      stats['totalAssessments'] ?? 0,
                      context,
                    ),
                    icon: Icons.assessment,
                    color: Colors.green,
                  ),
                  _StatCard(
                    title: l10n.securityAlerts,
                    value: LocalizationUtils.formatNumber(
                      stats['pendingAccessRequests'] ?? 0,
                      context,
                    ),
                    icon: Icons.security,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                l10n.content_management_title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _MenuTile(
                title: l10n.quran_library_title,
                subtitle: l10n.quran_library_subtitle,
                icon: Icons.book,
                onTap: () => context.push('/admin/quran'),
              ),
              _MenuTile(
                title: l10n.hadith_library_title,
                subtitle: l10n.hadith_library_subtitle,
                icon: Icons.auto_stories,
                onTap: () => context.push('/admin/hadith'),
              ),
              _MenuTile(
                title: l10n.health_library_title,
                subtitle: l10n.health_library_subtitle,
                icon: Icons.health_and_safety,
                onTap: () => context.push('/admin/health'),
              ),
              _MenuTile(
                title: l10n.project_team_title,
                subtitle: l10n.project_team_subtitle,
                icon: Icons.group,
                onTap: () => context.push('/admin/team'),
              ),
              _MenuTile(
                title: l10n.assessment_logic_title,
                subtitle: l10n.assessment_logic_subtitle,
                icon: Icons.psychology,
                onTap: () => context.push('/admin/assessment'),
              ),
              _MenuTile(
                title: 'Base Juridique & Textes Validés',
                subtitle:
                    'Articles, catégories, procédures, sources et versions (Audit log)',
                icon: Icons.gavel,
                onTap: () => context.push('/admin/legal'),
              ),
              _MenuTile(
                title: 'Réseau local et sensibilisation',
                subtitle:
                    'Partenaires, établissements, vérification et disponibilité locale',
                icon: Icons.hub_outlined,
                onTap: () => context.push('/admin/awareness'),
              ),
              _MenuTile(
                title: 'Comptes et relations partenaires',
                subtitle:
                    'Lien fiche partenaire ↔ compte responsable, disponibilité et suivi agrégé local',
                icon: Icons.account_tree_outlined,
                onTap: () => context.push('/admin/partners'),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.quickActions,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _MenuTile(
                title: l10n.professionalManagement,
                subtitle:
                    "${LocalizationUtils.formatNumber(stats['pendingProfessionals'] ?? 0, context)} ${l10n.statusPending}",
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
                title: l10n.communications_title,
                subtitle: l10n.communications_subtitle,
                icon: Icons.chat,
                onTap: () => context.push('/admin/chat'),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    height: 1.1,
                  ),
                ),
              ),
            ),
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
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
