import 'package:freezed_annotation/freezed_annotation.dart';

part 'center_model.freezed.dart';
part 'center_model.g.dart';

@freezed
class CenterModel with _$CenterModel {
  const factory CenterModel({
    required int id,
    required String name,
    required String description,
    required int wilayaId,
    required String city,
    required String address,
    double? latitude,
    double? longitude,
    String? phone,
    String? whatsapp,
    String? email,
    String? website,
    String? openingHours,
    List<String>? services,
    @Default('PENDING') String verificationStatus,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CenterModel;

  factory CenterModel.fromJson(Map<String, dynamic> json) => _$CenterModelFromJson(json);
}
