import 'assessment_axis.dart';

class MicroAction {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String? titleAr;
  final String? titleFr;
  final String? descAr;
  final String? descFr;
  final int? estimatedMinutes;
  final AssessmentAxis axis;
  final String type;
  final int impactPoints;

  const MicroAction({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    this.titleAr,
    this.titleFr,
    this.descAr,
    this.descFr,
    this.estimatedMinutes,
    required this.axis,
    this.type = 'action',
    this.impactPoints = 1,
  });
}
