class ProjectMember {
  final String name;
  final String role;
  final String? expertise;
  final String? phone;
  final String? location;
  final String? photo;
  final bool whatsappEnabled;

  const ProjectMember({
    required this.name,
    required this.role,
    this.expertise,
    this.phone,
    this.location,
    this.photo,
    this.whatsappEnabled = true,
  });
}
