enum ProfessionalType {
  psychologist,
  doctor,
  neurologist,
  socialWorker,
  educator,
  counselor,
}

class Professional {
  final String id;
  final String name;
  final ProfessionalType type;
  final String specialty;
  final String wilayaId;
  final String? address;
  final String? phone;
  final bool isVerified;
  final double? rating;

  Professional({
    required this.id,
    required this.name,
    required this.type,
    required this.specialty,
    required this.wilayaId,
    this.address,
    this.phone,
    this.isVerified = false,
    this.rating,
  });
}
