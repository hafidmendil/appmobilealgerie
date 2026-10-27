import 'package:freezed_annotation/freezed_annotation.dart';

enum AssessmentType {
  @JsonValue('psychological_vulnerability')
  psychologicalVulnerability,
  @JsonValue('violence_victim')
  violenceVictim,
}

enum UserSituation {
  @JsonValue('actor')
  actor,
  @JsonValue('victim')
  victim,
  @JsonValue('informational')
  informational,
}

enum RiskLevel {
  @JsonValue('low')
  low,
  @JsonValue('moderate')
  moderate,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

enum ViolenceType {
  @JsonValue('physical')
  physical,
  @JsonValue('psychological')
  psychological,
  @JsonValue('verbal')
  verbal,
  @JsonValue('economic')
  economic,
  @JsonValue('sexual')
  sexual,
  @JsonValue('family')
  family,
  @JsonValue('school')
  school,
  @JsonValue('workplace')
  workplace,
  @JsonValue('digital')
  digital,
  @JsonValue('harassment')
  harassment,
  @JsonValue('threat')
  threat,
  @JsonValue('blackmail')
  blackmail,
  @JsonValue('intimidation')
  intimidation,
}

enum ViolenceSeverity {
  @JsonValue('low')
  low,
  @JsonValue('moderate')
  moderate,
  @JsonValue('high')
  high,
  @JsonValue('critical')
  critical,
}

enum PartnerType {
  @JsonValue('psychologist')
  psychologist,
  @JsonValue('psychiatrist')
  psychiatrist,
  @JsonValue('neurologist')
  neurologist,
  @JsonValue('health_professional')
  healthProfessional,
  @JsonValue('social_worker')
  socialWorker,
  @JsonValue('legal_support')
  legalSupport,
  @JsonValue('association')
  association,
  @JsonValue('other_specialist')
  otherSpecialist,
}

enum PartnerStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
  @JsonValue('suspended')
  suspended,
  @JsonValue('rejected')
  rejected,
}

enum ReferralStatus {
  @JsonValue('created')
  created,
  @JsonValue('user_consented')
  userConsented,
  @JsonValue('pending')
  pending,
  @JsonValue('sent')
  sent,
  @JsonValue('received')
  received,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum ConsentType {
  @JsonValue('anonymous_session')
  anonymousSession,
  @JsonValue('data_storage')
  dataStorage,
  @JsonValue('location')
  location,
  @JsonValue('partner_referral')
  partnerReferral,
  @JsonValue('institution_referral')
  institutionReferral,
  @JsonValue('legal_guidance')
  legalGuidance,
  @JsonValue('analytics')
  analytics,
}

enum ConsentStatus {
  @JsonValue('granted')
  granted,
  @JsonValue('revoked')
  revoked,
  @JsonValue('pending')
  pending,
}

enum LegalKnowledgeStatus {
  @JsonValue('verified')
  verified,
  @JsonValue('needs_verification')
  needsVerification,
}

enum NotificationType {
  @JsonValue('assessment_reminder')
  assessmentReminder,
  @JsonValue('referral_update')
  referralUpdate,
  @JsonValue('partner_response')
  partnerResponse,
  @JsonValue('safety_information')
  safetyInformation,
  @JsonValue('awareness')
  awareness,
  @JsonValue('system')
  system,
}

enum InstitutionType {
  @JsonValue('police')
  police,
  @JsonValue('gendarmerie')
  gendarmerie,
  @JsonValue('court')
  court,
  @JsonValue('hospital')
  hospital,
  @JsonValue('social_services')
  socialServices,
  @JsonValue('child_protection')
  childProtection,
  @JsonValue('women_shelter')
  womenShelter,
}
