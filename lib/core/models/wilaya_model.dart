class Wilaya {
  final String id;
  final String nameFr;
  final String nameAr;
  final String code;
  final String? nameEn;

  Wilaya({
    required this.id,
    required this.nameFr,
    required this.nameAr,
    required this.code,
    this.nameEn,
  });

  factory Wilaya.fromJson(Map<String, dynamic> json) {
    return Wilaya(
      id: json['id']?.toString() ?? '',
      nameFr: json['nameFr'] ?? '',
      nameAr: json['nameAr'] ?? '',
      code: json['code']?.toString() ?? '',
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameFr': nameFr,
      'nameAr': nameAr,
      'code': code,
      'nameEn': nameEn,
    };
  }
}
