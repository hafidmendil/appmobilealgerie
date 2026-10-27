import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/features/team/models/project_member.dart';

final teamMembersProvider =
    StateNotifierProvider<TeamMembersNotifier, List<ProjectMember>>((ref) {
      return TeamMembersNotifier();
    });

class TeamMembersNotifier extends StateNotifier<List<ProjectMember>> {
  TeamMembersNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    final box = Hive.box<ProjectMember>(HiveConfig.teamMembersBox);
    if (box.isEmpty) {
      _loadInitialData();
    } else {
      state = box.values.toList()..sort((a, b) => a.order.compareTo(b.order));
    }
  }

  void _loadInitialData() {
    final initial = [
      ProjectMember(
        id: 'daif',
        name: "Daif Abdelatif",
        role: "Professeur / Expert en criminologie",
        expertise: "Criminologie",
        phone: "+213 661 20 02 68",
        order: 0,
      ),
      ProjectMember(
        id: 'merzoug',
        name: "Merzoug Mohamed",
        role: "Professeur / Expert en biotechnologie",
        expertise: "Biotechnologie",
        phone: "+213 549 86 51 61",
        order: 1,
      ),
      ProjectMember(
        id: 'hadj',
        name: "Hadj Mokhtar Nour el Houd",
        role: "Membre du projet",
        whatsappEnabled: false,
        order: 2,
      ),
      ProjectMember(
        id: 'mendil',
        name: "Mendil Ahmed Abdel Hafid",
        role: "Programmeur / Développeur",
        location: "Mascara",
        phone: "06 74 93 21 25",
        order: 3,
      ),
      ProjectMember(
        id: 'gherbi',
        name: "Mourad Gherbi",
        role: "Membre technique / Programmeur",
        location: "Arzew, Oran",
        phone: "0799 31 19 55",
        order: 4,
      ),
    ];

    final box = Hive.box<ProjectMember>(HiveConfig.teamMembersBox);
    box.addAll(initial);
    state = initial;
  }

  Future<void> addMember(ProjectMember member) async {
    final box = Hive.box<ProjectMember>(HiveConfig.teamMembersBox);
    await box.add(member);
    state = [...state, member]..sort((a, b) => a.order.compareTo(b.order));
  }

  Future<void> deleteMember(String id) async {
    final box = Hive.box<ProjectMember>(HiveConfig.teamMembersBox);
    final member = box.values.firstWhere((m) => m.id == id);
    await box.delete(member.key);
    state = state.where((m) => m.id != id).toList();
  }
}
