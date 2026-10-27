import 'package:projetmascara/core/models/assessment_core_models.dart';
import 'package:projetmascara/core/models/consent_model.dart';
import 'package:projetmascara/core/models/enums.dart';
import 'package:projetmascara/core/models/legal_core_models.dart';
import 'package:projetmascara/core/models/partner_core_models.dart';
import 'package:projetmascara/core/models/referral_model.dart';
import 'package:projetmascara/core/models/awareness_core_models.dart';

abstract class AssessmentRepository {
  Future<void> saveAssessment(Assessment assessment);
  Future<Assessment?> getAssessment(String id);
  Future<List<Assessment>> getUserAssessments(String userId);
}

abstract class PartnerRepository {
  Future<List<Partner>> getPartners();
  Future<Partner?> getPartnerById(String id);
}

abstract class ReferralRepository {
  Future<void> createReferral(Referral referral);
  Future<Referral?> getReferral(String id);
  Future<List<Referral>> getUserReferrals(String userId);
  Future<void> updateReferralStatus(String id, ReferralStatus status);
}

abstract class LegalRepository {
  Future<List<LegalArticle>> getLegalArticles();
  Future<LegalArticle?> getLegalArticleById(String id);
}

abstract class ResourceRepository {
  Future<List<Resource>> getResources();
}

abstract class ConsentRepository {
  Future<void> saveConsent(Consent consent);
  Future<List<Consent>> getUserConsents(String userId);
  Future<void> revokeConsent(String consentId);
}
