import 'package:freezed_annotation/freezed_annotation.dart';

part 'directory_models.freezed.dart';
part 'directory_models.g.dart';

@freezed
class Wilaya with _$Wilaya {
  const factory Wilaya({
    required int id,
    required String code,
    @JsonKey(name: 'name_fr') required String nameFr,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'prof_count') @Default(0) int profCount,
    @JsonKey(name: 'cabinet_count') @Default(0) int cabinetCount,
    @JsonKey(name: 'public_count') @Default(0) int publicCount,
  }) = _Wilaya;

  factory Wilaya.fromJson(Map<String, dynamic> json) => _$WilayaFromJson(json);
}

@freezed
class Professional with _$Professional {
  const factory Professional({
    required int id,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'professional_type') String? professionalType,
    String? specialty,
    @JsonKey(name: 'phone_primary') String? phonePrimary,
    @JsonKey(name: 'phone_secondary') String? phoneSecondary,
    String? email,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'wilaya_name') String? wilayaName,
    String? commune,
    String? address,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'consultation_online') @Default(false) bool consultationOnline,
    @Default(false) bool children,
    @Default(false) bool adolescents,
    @Default(false) bool adults,
    @JsonKey(name: 'verification_status') required String verificationStatus,
    @JsonKey(name: 'last_verified_at') String? lastVerifiedAt,
  }) = _Professional;

  factory Professional.fromJson(Map<String, dynamic> json) => _$ProfessionalFromJson(json);
}

@freezed
class Establishment with _$Establishment {
  const factory Establishment({
    required int id,
    required String name,
    @JsonKey(name: 'establishment_type') String? establishmentType,
    @JsonKey(name: 'public_private') required String publicPrivate,
    String? specialty,
    @JsonKey(name: 'phone_primary') String? phonePrimary,
    @JsonKey(name: 'phone_secondary') String? phoneSecondary,
    String? email,
    @JsonKey(name: 'wilaya_id') required int wilayaId,
    @JsonKey(name: 'wilaya_name') String? wilayaName,
    String? commune,
    String? address,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'opening_hours') String? openingHours,
    @JsonKey(name: 'verification_status') required String verificationStatus,
  }) = _Establishment;

  factory Establishment.fromJson(Map<String, dynamic> json) => _$EstablishmentFromJson(json);
}

@freezed
class SearchResult with _$SearchResult {
  const factory SearchResult({
    required String category, // professional, establishment
    required int id,
    required String name,
    @JsonKey(name: 'sub_type') String? subType,
    String? phone,
    String? address,
    @JsonKey(name: 'wilaya_name') String? wilayaName,
    @JsonKey(name: 'verification_status') required String verificationStatus,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) => _$SearchResultFromJson(json);
}
