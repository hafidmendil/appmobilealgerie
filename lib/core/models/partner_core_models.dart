import 'package:hive/hive.dart';
import 'package:projetmascara/core/models/enums.dart';

part 'partner_core_models.g.dart';

@HiveType(typeId: 109)
class PartnerSpeciality extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nameFr;
  @HiveField(2)
  final String nameAr;
  @HiveField(3)
  final PartnerType type;

  PartnerSpeciality({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.type,
  });
}

@HiveType(typeId: 110)
class Partner extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final PartnerType type;
  @HiveField(3)
  final String specialityId;
  @HiveField(4)
  final String wilayaId;
  @HiveField(5)
  final String communeId;
  @HiveField(6)
  final String location;
  @HiveField(7)
  final String phone;
  @HiveField(8)
  final List<String> languages; // 'fr', 'ar', 'en'
  @HiveField(9)
  final bool availability;
  @HiveField(10)
  final PartnerStatus status;
  @HiveField(11)
  final bool active;
  @HiveField(12)
  final List<UserSituation> acceptedCaseTypes;
  @HiveField(13)
  final List<RiskLevel> supportedRiskLevels;

  Partner({
    required this.id,
    required this.name,
    required this.type,
    required this.specialityId,
    required this.wilayaId,
    required this.communeId,
    required this.location,
    required this.phone,
    required this.languages,
    required this.availability,
    required this.status,
    required this.active,
    required this.acceptedCaseTypes,
    required this.supportedRiskLevels,
  });
}

@HiveType(typeId: 111)
class Institution extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nameFr;
  @HiveField(2)
  final String nameAr;
  @HiveField(3)
  final InstitutionType type;
  @HiveField(4)
  final String wilayaId;
  @HiveField(5)
  final String communeId;
  @HiveField(6)
  final String phone;
  @HiveField(7)
  final String location;

  Institution({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.type,
    required this.wilayaId,
    required this.communeId,
    required this.phone,
    required this.location,
  });
}
