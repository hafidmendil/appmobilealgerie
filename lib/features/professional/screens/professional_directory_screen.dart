import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/professional/professional_provider.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class ProfessionalDirectoryScreen extends ConsumerWidget {
  const ProfessionalDirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final professionalsAsync = ref.watch(allProfessionalsProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resources),
      ),
      body: professionalsAsync.when(
        data: (professionals) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: professionals.length,
          itemBuilder: (context, index) {
            final prof = professionals[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(prof.fullName),
                subtitle: Text("${prof.specialty.name} - ${prof.location}"),
                trailing: user == null ? null : IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _showRequestDialog(context, ref, prof),
                ),
                onTap: () => _showProfDetails(context, prof),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("${l10n.error_occurred}: $e")),
      ),
    );
  }

  void _showProfDetails(BuildContext context, ProfessionalProfile prof) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prof.fullName, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text("${prof.specialty.name} | ${prof.location}", style: const TextStyle(color: Colors.blueGrey)),
            const SizedBox(height: 16),
            Text(prof.description),
            const SizedBox(height: 24),
            Text("Langues: ${prof.languages.join(', ')}"),
          ],
        ),
      ),
    );
  }

  void _showRequestDialog(BuildContext context, WidgetRef ref, ProfessionalProfile prof) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.pendingFollowupRequests),
        content: Text("Souhaitez-vous partager vos évaluations avec ${prof.fullName} pour un suivi ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.later)),
          ElevatedButton(
            onPressed: () async {
              await ref.read(professionalRepositoryProvider).sendRequest(
                userId: user.id,
                professionalId: prof.userId,
              );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Demande envoyée avec succès")),
                );
              }
            },
            child: Text(l10n.acceptConsent),
          ),
        ],
      ),
    );
  }
}
