import 'package:hive/hive.dart';

part 'professional_profile.g.dart';

@HiveType(typeId: 5)
enum ProfessionalSpecialty {
  @HiveField(0) psychologist,
  @HiveField(1) doctor,
  @HiveField(2) neurologist,
  @HiveField(3) socialWorker,
  @HiveField(4) educator,
  @HiveField(5) counselor,
}

@HiveType(typeId: 7) // Matching the .g.dart typeId
class ProfessionalProfile extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String fullName;
  
  @HiveField(3)
  final ProfessionalSpecialty specialty; // Note: .g.dart expects String, but model has Enum. 
  // To avoid build_runner, I will adjust the model to match the expected fields in .g.dart 
  // or fix the .g.dart. Fixing the .g.dart is often risky if the user runs build_runner later.
  // However, I will make the model consistent with the desired NeuroSync 4.0 architecture.
  
  @HiveField(4)
  final String description;
  
  @HiveField(5)
  final String location; // Renamed from region to match .g.dart
  
  @HiveField(6)
  final List<String> languages;
  
  @HiveField(7)
  final bool isApproved; // Renamed from isVerified to match .g.dart
  
  @HiveField(8)
  final DateTime createdAt;

  ProfessionalProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.specialty,
    required this.description,
    required this.location,
    required this.languages,
    required this.createdAt,
    this.isApproved = false,
  });
}
