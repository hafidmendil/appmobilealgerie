class CenterModel {
  final int id;
  final String name;
  final String description;
  final int wilayaId;
  final String city;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? whatsapp;
  final String? email;
  final String? website;
  final String? openingHours;
  final List<String>? services;
  final String verificationStatus;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CenterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.wilayaId,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
    this.phone,
    this.whatsapp,
    this.email,
    this.website,
    this.openingHours,
    this.services,
    this.verificationStatus = 'PENDING',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      wilayaId: json['wilayaId'] as int,
      city: json['city'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      phone: json['phone'] as String?,
      whatsapp: json['whatsapp'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      openingHours: json['openingHours'] as String?,
      services: (json['services'] as List?)?.map((e) => e as String).toList(),
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
      'name': name,
      'description': description,
      'wilayaId': wilayaId,
      'city': city,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
      'website': website,
      'openingHours': openingHours,
      'services': services,
      'verificationStatus': verificationStatus,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
