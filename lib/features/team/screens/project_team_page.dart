import 'package:flutter/material.dart';
import 'package:projetmascara/features/team/models/project_member.dart';
import 'package:projetmascara/features/team/widgets/project_member_card.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class ProjectTeamPage extends StatelessWidget {
  const ProjectTeamPage({super.key});

  static const List<ProjectMember> _team = [
    ProjectMember(
      name: "Daif Abdelatif",
      role: "Professeur / Expert en criminologie",
      expertise: "Criminologie",
      phone: "+213 661 20 02 68",
    ),
    ProjectMember(
      name: "Merzoug Mohamed",
      role: "Professeur / Expert en biotechnologie",
      expertise: "Biotechnologie",
      phone: "+213 549 86 51 61",
    ),
    ProjectMember(
      name: "Hadj Mokhtar Nour el Houd",
      role: "Membre du projet",
      whatsappEnabled: false,
    ),
    ProjectMember(
      name: "Mendil Ahmed Abdel Hafid",
      role: "Programmeur / Développeur",
      location: "Mascara",
      phone: "06 74 93 21 25",
    ),
    ProjectMember(
      name: "Mourad Gherbi",
      role: "Membre technique / Programmeur",
      location: "Arzew, Oran",
      phone: "0799 31 19 55",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.project_team_title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: _team.length,
        itemBuilder: (context, index) {
          return ProjectMemberCard(member: _team[index]);
        },
      ),
    );
  }
}
