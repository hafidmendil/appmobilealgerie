import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:projetmascara/features/team/models/project_member.dart';
import 'package:projetmascara/features/team/providers/team_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class TeamAdminScreen extends ConsumerStatefulWidget {
  const TeamAdminScreen({super.key});

  @override
  ConsumerState<TeamAdminScreen> createState() => _TeamAdminScreenState();
}

class _TeamAdminScreenState extends ConsumerState<TeamAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final team = ref.watch(teamMembersProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion de l'Équipe"),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () => _showMemberDialog(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: team.length,
        itemBuilder: (context, index) {
          final member = team[index];
          return ListTile(
            leading: CircleAvatar(child: Text(member.name[0])),
            title: Text(member.name),
            subtitle: Text(member.role),
            trailing: IconButton(
              icon: const Icon(LucideIcons.trash_2, color: Colors.red),
              onPressed: () => ref.read(teamMembersProvider.notifier).deleteMember(member.id),
            ),
          );
        },
      ),
    );
  }

  void _showMemberDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un membre"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: roleController, decoration: const InputDecoration(labelText: "Rôle")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Téléphone")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              final newMember = ProjectMember(
                id: const Uuid().v4(),
                name: nameController.text,
                role: roleController.text,
                phone: phoneController.text,
                order: ref.read(teamMembersProvider).length,
              );
              ref.read(teamMembersProvider.notifier).addMember(newMember);
              Navigator.pop(context);
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}
