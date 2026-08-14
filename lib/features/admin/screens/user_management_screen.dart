import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/models/user_model.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(adminUsersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userManagement),
      ),
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
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                final filtered = users.where((u) => 
                  u.email.toLowerCase().contains(_searchQuery) ||
                  u.role.name.toLowerCase().contains(_searchQuery)
                ).toList();

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
              error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
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
      title: Text(user.email, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${user.role.name.toUpperCase()} • ${_getStatusLabel(l10n, user.status)}"),
      trailing: PopupMenuButton<String>(
        onSelected: (status) => ref.read(adminNotifierProvider.notifier).updateUserStatus(user.id, status),
        itemBuilder: (context) => [
          PopupMenuItem(value: 'active', child: Text(l10n.activate)),
          PopupMenuItem(value: 'suspended', child: Text(l10n.suspend)),
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
                _InfoRow(label: l10n.timestamp, value: user.createdAt.toLocal().toString()),
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
                    style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
            ],
          ),
        );
      },
    );
  }

  String _getStatusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'active': return l10n.statusApproved;
      case 'suspended': return l10n.statusSuspended;
      case 'pending': return l10n.statusPending;
      default: return status;
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
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }
}
