enum ResourceType { emergency, listening, counseling, selfCare }

class Resource {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final ResourceType type;

  const Resource({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.type,
  });
}

const List<Resource> mockResources = [
  Resource(
    id: 'r1',
    nameKey: 'res_emergency_name',
    descriptionKey: 'res_emergency_desc',
    type: ResourceType.emergency,
  ),
  Resource(
    id: 'r2',
    nameKey: 'res_listening_name',
    descriptionKey: 'res_listening_desc',
    type: ResourceType.listening,
  ),
  Resource(
    id: 'r3',
    nameKey: 'res_counseling_name',
    descriptionKey: 'res_counseling_desc',
    type: ResourceType.counseling,
  ),
  Resource(
    id: 'r4',
    nameKey: 'res_selfcare_name',
    descriptionKey: 'res_selfcare_desc',
    type: ResourceType.selfCare,
  ),
];
