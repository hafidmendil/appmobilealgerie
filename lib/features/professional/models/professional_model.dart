class ProfessionalModel {
  final int id;
  final String fullName;
  final String title;
  final String specialty;
  final int wilayaId;
  final String city;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? photo;
  final String? biography;
  final List<String>? languages;
  final List<String>? sessionTypes;
  final String? availability;
  final String verificationStatus;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfessionalModel({
    required this.id,
    required this.fullName,
    required this.title,
    required this.specialty,
    required this.wilayaId,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.whatsapp,
    this.email,
    this.photo,
    this.biography,
    this.languages,
    this.sessionTypes,
    this.availability,
    this.verificationStatus = 'PENDING',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      title: json['title'] as String,
      specialty: json['specialty'] as String,
      wilayaId: json['wilayaId'] as int,
      city: json['city'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      email: json['email'] as String?,
      photo: json['photo'] as String?,
      biography: json['biography'] as String?,
      languages: (json['languages'] as List?)?.map((e) => e as String).toList(),
      sessionTypes: (json['sessionTypes'] as List?)
          ?.map((e) => e as String)
          .toList(),
      availability: json['availability'] as String?,
      verificationStatus: json['verificationStatus'] as String? ?? 'PENDING',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'title': title,
      'specialty': specialty,
      'wilayaId': wilayaId,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
      'photo': photo,
      'biography': biography,
      'languages': languages,
      'sessionTypes': sessionTypes,
      'availability': availability,
      'verificationStatus': verificationStatus,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
