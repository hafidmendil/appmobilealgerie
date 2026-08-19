import 'package:freezed_annotation/freezed_annotation.dart';

part 'professional_model.freezed.dart';
part 'professional_model.g.dart';

@freezed
class ProfessionalModel with _$ProfessionalModel {
  const factory ProfessionalModel({
    required int id,
    required String fullName,
    required String title,
    required String specialty,
    required int wilayaId,
    required String city,
    required String address,
    double? latitude,
    double? longitude,
    String? phone,
    String? whatsapp,
    String? email,
    String? photo,
    String? biography,
    List<String>? languages,
    List<String>? sessionTypes,
    String? availability,
    @Default('PENDING') String verificationStatus,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProfessionalModel;

  factory ProfessionalModel.fromJson(Map<String, dynamic> json) => _$ProfessionalModelFromJson(json);
}
