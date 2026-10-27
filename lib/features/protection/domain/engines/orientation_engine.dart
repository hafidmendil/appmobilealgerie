import '../models/protection_models.dart';

class OrientationSuggestion {
  final String type;
  final String reason;
  final bool requiresConsent;

  const OrientationSuggestion({
    required this.type,
    required this.reason,
    required this.requiresConsent,
  });
}

class ProtectionOrientationEngine {
  const ProtectionOrientationEngine();

  OrientationDetails generateOrientation({
    required ViolenceSeverity severity,
    required Set<ViolenceType> categories,
    String wilaya = '01',
    String? userPreferredSpecialty,
  }) {
    String specialty = userPreferredSpecialty ?? 'Psychologue';

    if (userPreferredSpecialty == null) {
      if (categories.contains(ViolenceType.childAbuse)) {
        specialty = 'Spécialiste de l’enfance';
      } else if (categories.contains(ViolenceType.family) ||
          categories.contains(ViolenceType.domestic)) {
        specialty = 'Conseiller familial / Psychologue';
      } else if (categories.contains(ViolenceType.digital)) {
        specialty = 'Expert en sécurité numérique / Psychologue';
      } else if (categories.contains(ViolenceType.workplace)) {
        specialty = 'Psychologue du travail';
      }
    }

    final urgencyLevel = severity.code;

    return OrientationDetails(
      requiredSpecialty: specialty,
      urgencyLevel: urgencyLevel,
      wilaya: wilaya,
      remoteConsultationPossible: true,
      inPersonPossible: true,
      recommendedSpecialists: const [
        'Psychologue clinicien',
        'Écoute et soutien social',
        'Conseiller d’orientation et de protection',
      ],
    );
  }

  List<OrientationSuggestion> suggest({
    required RiskAssessment assessment,
    required Set<ViolenceType> violenceTypes,
    String? preferredType,
  }) {
    final suggestions = <OrientationSuggestion>[];
    if (assessment.level == RiskLevel.immediate) {
      suggestions.add(
        const OrientationSuggestion(
          type: 'aide_urgente',
          reason: 'facteur_critique',
          requiresConsent: false,
        ),
      );
    }
    if (preferredType != null) {
      suggestions.add(
        OrientationSuggestion(
          type: preferredType,
          reason: 'préférence déclarée',
          requiresConsent: true,
        ),
      );
    }
    if (violenceTypes.contains(ViolenceType.digital)) {
      suggestions.add(
        const OrientationSuggestion(
          type: 'association',
          reason: 'violence_numérique',
          requiresConsent: true,
        ),
      );
    }
    suggestions.add(
      const OrientationSuggestion(
        type: 'ressources_generales',
        reason: 'information_vérifiée',
        requiresConsent: false,
      ),
    );
    return suggestions;
  }
}
