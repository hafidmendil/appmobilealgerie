import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_request_model.freezed.dart';
part 'session_request_model.g.dart';

enum SessionRequestStatus { PENDING, ACCEPTED, REJECTED, CANCELLED, COMPLETED }

@freezed
class SessionRequestModel with _$SessionRequestModel {
  const factory SessionRequestModel({
    required int id,
    required int userId,
    int? professionalId,
    int? centerId,
    required int wilayaId,
    required DateTime requestedDate,
    String? preferredTime,
    String? sessionType,
    String? userMessage,
    @Default(SessionRequestStatus.PENDING) SessionRequestStatus status,
    @Default(false) bool consentGiven,
    DateTime? consentDate,
    String? consentVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SessionRequestModel;

  factory SessionRequestModel.fromJson(Map<String, dynamic> json) => _$SessionRequestModelFromJson(json);
}
