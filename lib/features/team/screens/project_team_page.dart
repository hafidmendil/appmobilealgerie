import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/features/team/providers/team_provider.dart';
import 'package:projetmascara/features/team/widgets/project_member_card.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class ProjectTeamPage extends ConsumerWidget {
  const ProjectTeamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final team = ref.watch(teamMembersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.project_team_title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: team.length,
        itemBuilder: (context, index) {
          return ProjectMemberCard(member: team[index]);
        },
      ),
    );
  }
}
