import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/features/admin/admin_provider.dart';
import 'package:projetmascara/features/messaging/chat_page.dart';

class ContactListScreen extends ConsumerWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.auto_communications)),
      body: usersAsync.when(
        data: (users) {
          final currentUser = ref.read(currentUserProvider);
          final filteredUsers = users
              .where((u) => u.id != currentUser?.id)
              .toList();

          return ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(user.name?[0] ?? user.email[0]),
                ),
                title: Text(user.name ?? user.email),
                subtitle: Text(user.role.name.toUpperCase()),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        otherId: user.id,
                        otherName: user.name ?? user.email,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Erreur: $e")),
      ),
    );
  }
}
