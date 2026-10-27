import '../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/providers/backend_providers.dart';
import '../../features/professional/models/access_request.dart';
import 'chat_page.dart';

class MyCommunicationsPage extends ConsumerWidget {
  const MyCommunicationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return Scaffold(body: Center(child: Text(context.l10n.auto_non_connect)));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.localNotes)),
      body: FutureBuilder<List<AccessRequest>>(
        future: ref
            .read(professionalRepositoryProvider)
            .getRequestsForUser(user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final accepted = snapshot.data!
              .where(
                (request) => request.status == AccessRequestStatus.accepted,
              )
              .toList();
          if (accepted.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  context.l10n.auto_messagerie_sera_disponible_aprs,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: accepted.length,
            itemBuilder: (context, index) {
              final request = accepted[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(
                  context.l10n.specialistWithId(
                    request.professionalId.substring(0, 5),
                  ),
                ),
                subtitle: Text(context.l10n.consultationAccessGranted),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatPage(
                      otherId: request.professionalId,
                      otherName: context.l10n.rolePsychologist,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
