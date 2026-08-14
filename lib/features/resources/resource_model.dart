import 'package:projetmascara/features/engine/decision_engine.dart';
import 'package:projetmascara/features/assessment/assessment_models.dart';

enum ResourceType {
  emergency,
  listening,
  counseling,
  selfCare
}

class Resource {
  final String id;
  final String nameKey;
  final ResourceType type;
  final String descriptionKey;
  final String? phone;
  final String? website;
  final OrientationLevel minLevel;

  Resource({
    required this.id,
    required this.nameKey,
    required this.type,
    required this.descriptionKey,
    this.phone,
    this.website,
    required this.minLevel,
  });
}

final List<Resource> mockResources = [
  Resource(
    id: 'res_1',
    nameKey: "res_emergency_name",
    type: ResourceType.emergency,
    descriptionKey: "res_emergency_desc",
    phone: "15",
    minLevel: OrientationLevel.level4,
  ),
  Resource(
    id: 'res_2',
    nameKey: "res_listening_name",
    type: ResourceType.listening,
    descriptionKey: "res_listening_desc",
    phone: "0000",
    minLevel: OrientationLevel.level2,
  ),
  Resource(
    id: 'res_3',
    nameKey: "res_selfcare_name",
    type: ResourceType.selfCare,
    descriptionKey: "res_selfcare_desc",
    website: "https://neurosync.example/guide",
    minLevel: OrientationLevel.level1,
  ),
  Resource(
    id: 'res_4',
    nameKey: "res_counseling_name",
    type: ResourceType.counseling,
    descriptionKey: "res_counseling_desc",
    website: "https://neurosync.example/rdv",
    minLevel: OrientationLevel.level2,
  ),
];
