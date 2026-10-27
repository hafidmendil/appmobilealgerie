import 'package:hive/hive.dart';

part 'project_member.g.dart';

@HiveType(typeId: 25)
class ProjectMember extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role;

  @HiveField(3)
  final String? expertise;

  @HiveField(4)
  final String? phone;

  @HiveField(5)
  final String? location;

  @HiveField(6)
  final String? photo;

  @HiveField(7)
  final bool whatsappEnabled;

  @HiveField(8)
  final int order;

  ProjectMember({
    required this.id,
    required this.name,
    required this.role,
    this.expertise,
    this.phone,
    this.location,
    this.photo,
    this.whatsappEnabled = true,
    this.order = 0,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) {
    return ProjectMember(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      expertise: json['expertise'],
      phone: json['phone'],
      location: json['location'],
      photo: json['photo'],
      whatsappEnabled: json['whatsappEnabled'] ?? true,
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'expertise': expertise,
      'phone': phone,
      'location': location,
      'photo': photo,
      'whatsappEnabled': whatsappEnabled,
      'order': order,
    };
  }
}
