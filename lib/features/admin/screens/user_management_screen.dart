import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    final l10n = AppLocalizations.of(context)!;

    // Listen for feedback
    ref.listen(adminNotifierProvider, (previous, next) {
      next.when(
        data: (_) {
          if (previous is AsyncLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.action_success)),
            );
          }
        },
        error: (e, st) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.red),
          );
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.userManagement)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: l10n.searchUser,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                final filtered = users
                    .where(
                      (u) =>
                          u.email.toLowerCase().contains(_searchQuery) ||
                          u.role.name.toLowerCase().contains(_searchQuery),
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return Center(child: Text(l10n.noPendingRequests));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    return _UserTile(user: user);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) =>
                  Center(child: Text("${l10n.error_occurred}: $e")),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserTile extends ConsumerWidget {
  final UserModel user;

  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: Text(
        user.email,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "${user.role.name.toUpperCase()} • ${_getStatusLabel(l10n, user.status)}",
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (action) => _handleAction(context, ref, action),
        itemBuilder: (context) => [
          PopupMenuItem(value: 'active', child: Text(l10n.activate)),
          PopupMenuItem(value: 'suspended', child: Text(l10n.suspend)),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'reset_password',
            child: Text(l10n.resetTemporaryPassword),
          ),
          PopupMenuItem(
            value: user.mfaRequired ? 'disable_mfa' : 'enable_mfa',
            child: Text(
              user.mfaRequired ? l10n.disableLocalMfa : l10n.requireLocalMfa,
            ),
          ),
        ],
      ),
      onTap: () {
        // Show metadata only dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.userDetails),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: l10n.email, value: user.email),
                _InfoRow(label: "ID", value: user.id),
                _InfoRow(label: l10n.roleSelection, value: user.role.name),
                _InfoRow(label: l10n.status_label, value: user.status),
                _InfoRow(
                  label: l10n.timestamp,
                  value: user.createdAt.toLocal().toString(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Text(
                    "Note: L'administrateur n'a pas accès aux données cliniques privées de l'utilisateur.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.close),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    if (action == 'active' || action == 'suspended') {
      await ref
          .read(adminNotifierProvider.notifier)
          .updateUserStatus(user.id, action);
      return;
    }
    final admin = ref.read(currentUserProvider);
    if (admin == null) return;
    final l10n = AppLocalizations.of(context)!;

    if (action == 'reset_password') {
      final password = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.resetTemporaryPassword),
          content: TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.temporaryPassword),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.confirm),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        try {
          await ref
              .read(authRepositoryProvider)
              .adminResetPassword(
                adminId: admin.id,
                userId: user.id,
                temporaryPassword: password.text,
              );
          ref.invalidate(adminUsersProvider);
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
      password.dispose();
      return;
    }

    if (action == 'enable_mfa') {
      final code = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.requireLocalMfa),
          content: TextField(
            controller: code,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.mfaEnrollmentCode),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.confirm),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        try {
          await ref
              .read(authRepositoryProvider)
              .setMfaRequirement(
                adminId: admin.id,
                userId: user.id,
                required: true,
                enrollmentCode: code.text,
              );
          ref.invalidate(adminUsersProvider);
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
      code.dispose();
      return;
    }

    if (action == 'disable_mfa') {
      try {
        await ref
            .read(authRepositoryProvider)
            .setMfaRequirement(
              adminId: admin.id,
              userId: user.id,
              required: false,
            );
        ref.invalidate(adminUsersProvider);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getStatusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'active':
        return l10n.statusApproved;
      case 'suspended':
        return l10n.statusSuspended;
      case 'pending':
        return l10n.statusPending;
      default:
        return status;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
