import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("${l10n.professionalPortal}: ${user?.email}"),
            const SizedBox(height: 20),
            _AdminTile(
              title: l10n.userManagement,
              icon: Icons.people,
              onTap: () => context.push('/admin/users'),
            ),
            _AdminTile(
              title: l10n.psychologistValidation,
              icon: Icons.verified_user,
              onTap: () {
                _showValidationDialog(context, ref);
              },
            ),
            _AdminTile(
              title: l10n.securityLogs,
              icon: Icons.security,
              onTap: () => context.push('/admin/security-logs'),
            ),
            _AdminTile(
              title: l10n.globalSettings,
              icon: Icons.settings,
              onTap: () => context.push('/admin/settings'),
            ),
          ],
        ),
      ),
    );
  }

  void _showValidationDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.psychologistValidation),
        content: SizedBox(
          width: double.maxFinite,
          child: ref
              .watch(allUsersProvider)
              .when(
                data: (users) {
                  final pending = users
                      .where(
                        (u) =>
                            u.role == UserRole.psychologist &&
                            u.status == 'pending',
                      )
                      .toList();
                  if (pending.isEmpty) return Text(l10n.noPendingRequests);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      final user = pending[index];
                      return ListTile(
                        title: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                await ref
                                    .read(authRepositoryProvider)
                                    .updateUserStatus(user.id, 'approved');
                                if (context.mounted) Navigator.pop(context);
                                ref.invalidate(allUsersProvider);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () async {
                                await ref
                                    .read(authRepositoryProvider)
                                    .updateUserStatus(user.id, 'rejected');
                                if (context.mounted) Navigator.pop(context);
                                ref.invalidate(allUsersProvider);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Text("${l10n.error_occurred}: $e"),
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
