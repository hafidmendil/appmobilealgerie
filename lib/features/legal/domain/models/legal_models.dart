import 'package:flutter/foundation.dart';

enum ValidationStatus { validated, pendingReview, obsolete, archived }

enum LegalReportStatus { draft, userConfirmed, readyForExport, transmitted }

class LegalCategory {
  final String id;
  final String code;
  final String titleFr;
  final String titleAr;
  final String descriptionFr;
  final String descriptionAr;
  final bool isEnabled;

  const LegalCategory({
    required this.id,
    required this.code,
    required this.titleFr,
    required this.titleAr,
    required this.descriptionFr,
    required this.descriptionAr,
    this.isEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'titleFr': titleFr,
    'titleAr': titleAr,
    'descriptionFr': descriptionFr,
    'descriptionAr': descriptionAr,
    'isEnabled': isEnabled,
  };

  factory LegalCategory.fromJson(Map<String, dynamic> json) => LegalCategory(
    id: json['id'] as String,
    code: json['code'] as String,
    titleFr: json['titleFr'] as String,
    titleAr: json['titleAr'] as String,
    descriptionFr: json['descriptionFr'] as String,
    descriptionAr: json['descriptionAr'] as String,
    isEnabled: json['isEnabled'] as bool? ?? true,
  );
}

class LegalSource {
  final String id;
  final String name;
  final String officialReference;
  final String? url;
  final String jurisdiction;

  const LegalSource({
    required this.id,
    required this.name,
    required this.officialReference,
    this.url,
    this.jurisdiction = 'DZ',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'officialReference': officialReference,
    'url': url,
    'jurisdiction': jurisdiction,
  };

  factory LegalSource.fromJson(Map<String, dynamic> json) => LegalSource(
    id: json['id'] as String,
    name: json['name'] as String,
    officialReference: json['officialReference'] as String,
    url: json['url'] as String?,
    jurisdiction: json['jurisdiction'] as String? ?? 'DZ',
  );
}

class LegalVersion {
  final String id;
  final String versionCode;
  final DateTime releaseDate;
  final String changelog;
  final bool isActive;

  const LegalVersion({
    required this.id,
    required this.versionCode,
    required this.releaseDate,
    required this.changelog,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'versionCode': versionCode,
    'releaseDate': releaseDate.toIso8601String(),
    'changelog': changelog,
    'isActive': isActive,
  };

  factory LegalVersion.fromJson(Map<String, dynamic> json) => LegalVersion(
    id: json['id'] as String,
    versionCode: json['versionCode'] as String,
    releaseDate: DateTime.parse(json['releaseDate'] as String),
    changelog: json['changelog'] as String,
    isActive: json['isActive'] as bool? ?? true,
  );
}

class LegalProcedure {
  final String id;
  final String titleFr;
  final String titleAr;
  final String descriptionFr;
  final String descriptionAr;
  final List<String> competentAuthorities;
  final List<String> stepsFr;
  final List<String> stepsAr;
  final List<String> requiredEvidenceFr;
  final bool isEmergency;
  final List<String> helplines;

  const LegalProcedure({
    required this.id,
    required this.titleFr,
    required this.titleAr,
    required this.descriptionFr,
    required this.descriptionAr,
    required this.competentAuthorities,
    required this.stepsFr,
    required this.stepsAr,
    required this.requiredEvidenceFr,
    this.isEmergency = false,
    this.helplines = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titleFr': titleFr,
    'titleAr': titleAr,
    'descriptionFr': descriptionFr,
    'descriptionAr': descriptionAr,
    'competentAuthorities': competentAuthorities,
    'stepsFr': stepsFr,
    'stepsAr': stepsAr,
    'requiredEvidenceFr': requiredEvidenceFr,
    'isEmergency': isEmergency,
    'helplines': helplines,
  };

  factory LegalProcedure.fromJson(Map<String, dynamic> json) => LegalProcedure(
    id: json['id'] as String,
    titleFr: json['titleFr'] as String,
    titleAr: json['titleAr'] as String,
    descriptionFr: json['descriptionFr'] as String,
    descriptionAr: json['descriptionAr'] as String,
    competentAuthorities: List<String>.from(
      json['competentAuthorities'] as List? ?? [],
    ),
    stepsFr: List<String>.from(json['stepsFr'] as List? ?? []),
    stepsAr: List<String>.from(json['stepsAr'] as List? ?? []),
    requiredEvidenceFr: List<String>.from(
      json['requiredEvidenceFr'] as List? ?? [],
    ),
    isEmergency: json['isEmergency'] as bool? ?? false,
    helplines: List<String>.from(json['helplines'] as List? ?? []),
  );
}

class LegalArticle {
  final String id;
  final String titre;
  final String titreAr;
  final String reference;
  final String referenceAr;
  final String texte;
  final String texteAr;
  final String explicationSimplifiee;
  final String explicationSimplifieeAr;
  final List<String> categoriesConcernees;
  final List<String> proceduresAssociees;
  final String sourceOfficielle;
  final DateTime dateValidite;
  final String version;
  final ValidationStatus statutValidation;
  final String validatedBy;
  final DateTime validatedAt;

  const LegalArticle({
    required this.id,
    required this.titre,
    required this.titreAr,
    required this.reference,
    required this.referenceAr,
    required this.texte,
    required this.texteAr,
    required this.explicationSimplifiee,
    required this.explicationSimplifieeAr,
    required this.categoriesConcernees,
    required this.proceduresAssociees,
    required this.sourceOfficielle,
    required this.dateValidite,
    required this.version,
    required this.statutValidation,
    required this.validatedBy,
    required this.validatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'titre': titre,
    'titreAr': titreAr,
    'reference': reference,
    'referenceAr': referenceAr,
    'texte': texte,
    'texteAr': texteAr,
    'explicationSimplifiee': explicationSimplifiee,
    'explicationSimplifieeAr': explicationSimplifieeAr,
    'categoriesConcernees': categoriesConcernees,
    'proceduresAssociees': proceduresAssociees,
    'sourceOfficielle': sourceOfficielle,
    'dateValidite': dateValidite.toIso8601String(),
    'version': version,
    'statutValidation': statutValidation.name,
    'validatedBy': validatedBy,
    'validatedAt': validatedAt.toIso8601String(),
  };

  factory LegalArticle.fromJson(Map<String, dynamic> json) => LegalArticle(
    id: json['id'] as String,
    titre: json['titre'] as String,
    titreAr: json['titreAr'] as String? ?? json['titre'] as String,
    reference: json['reference'] as String,
    referenceAr: json['referenceAr'] as String? ?? json['reference'] as String,
    texte: json['texte'] as String,
    texteAr: json['texteAr'] as String? ?? json['texte'] as String,
    explicationSimplifiee: json['explicationSimplifiee'] as String,
    explicationSimplifieeAr: json['explicationSimplifieeAr'] as String? ??
        json['explicationSimplifiee'] as String,
    categoriesConcernees: List<String>.from(
      json['categoriesConcernees'] as List? ?? [],
    ),
    proceduresAssociees: List<String>.from(
      json['proceduresAssociees'] as List? ?? [],
    ),
    sourceOfficielle: json['sourceOfficielle'] as String,
    dateValidite: DateTime.parse(json['dateValidite'] as String),
    version: json['version'] as String,
    statutValidation: ValidationStatus.values.byName(
      json['statutValidation'] as String? ?? 'validated',
    ),
    validatedBy: json['validatedBy'] as String? ?? 'Comité Juridique NeuroSync',
    validatedAt: DateTime.parse(
      json['validatedAt'] as String? ?? DateTime.now().toIso8601String(),
    ),
  );
}

class LegalAssessment {
  final String id;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> answers;
  final List<String> declaredFactsSummary;
  final List<String> candidateCategoryIds;
  final List<String> applicableArticleIds;
  final List<String> recommendedProcedureIds;
  final String qualificationIndicativeFr;
  final String qualificationIndicativeAr;
  final bool isGuest;
  final String status;

  const LegalAssessment({
    required this.id,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.answers,
    required this.declaredFactsSummary,
    required this.candidateCategoryIds,
    required this.applicableArticleIds,
    required this.recommendedProcedureIds,
    required this.qualificationIndicativeFr,
    required this.qualificationIndicativeAr,
    required this.isGuest,
    this.status = 'completed',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'answers': answers,
    'declaredFactsSummary': declaredFactsSummary,
    'candidateCategoryIds': candidateCategoryIds,
    'applicableArticleIds': applicableArticleIds,
    'recommendedProcedureIds': recommendedProcedureIds,
    'qualificationIndicativeFr': qualificationIndicativeFr,
    'qualificationIndicativeAr': qualificationIndicativeAr,
    'isGuest': isGuest,
    'status': status,
  };

  factory LegalAssessment.fromJson(Map<String, dynamic> json) =>
      LegalAssessment(
        id: json['id'] as String,
        userId: json['userId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        answers: Map<String, dynamic>.from(json['answers'] as Map? ?? {}),
        declaredFactsSummary: List<String>.from(
          json['declaredFactsSummary'] as List? ?? [],
        ),
        candidateCategoryIds: List<String>.from(
          json['candidateCategoryIds'] as List? ?? [],
        ),
        applicableArticleIds: List<String>.from(
          json['applicableArticleIds'] as List? ?? [],
        ),
        recommendedProcedureIds: List<String>.from(
          json['recommendedProcedureIds'] as List? ?? [],
        ),
        qualificationIndicativeFr:
            json['qualificationIndicativeFr'] as String? ?? '',
        qualificationIndicativeAr:
            json['qualificationIndicativeAr'] as String? ?? '',
        isGuest: json['isGuest'] as bool? ?? true,
        status: json['status'] as String? ?? 'completed',
      );
}

class ConsentRecord {
  final String id;
  final String? userId;
  final String? assessmentId;
  final String? reportId;
  final List<String> dataTypes;
  final String purpose;
  final String recipientInstitution;
  final List<String> transmittedFields;
  final String retentionPeriod;
  final String actionToBePerformed;
  final DateTime grantedAt;
  final bool isRevoked;
  final String consentVersion;
  final String checksum;

  const ConsentRecord({
    required this.id,
    this.userId,
    this.assessmentId,
    this.reportId,
    required this.dataTypes,
    required this.purpose,
    required this.recipientInstitution,
    required this.transmittedFields,
    required this.retentionPeriod,
    required this.actionToBePerformed,
    required this.grantedAt,
    this.isRevoked = false,
    required this.consentVersion,
    required this.checksum,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'assessmentId': assessmentId,
    'reportId': reportId,
    'dataTypes': dataTypes,
    'purpose': purpose,
    'recipientInstitution': recipientInstitution,
    'transmittedFields': transmittedFields,
    'retentionPeriod': retentionPeriod,
    'actionToBePerformed': actionToBePerformed,
    'grantedAt': grantedAt.toIso8601String(),
    'isRevoked': isRevoked,
    'consentVersion': consentVersion,
    'checksum': checksum,
  };

  factory ConsentRecord.fromJson(Map<String, dynamic> json) => ConsentRecord(
    id: json['id'] as String,
    userId: json['userId'] as String?,
    assessmentId: json['assessmentId'] as String?,
    reportId: json['reportId'] as String?,
    dataTypes: List<String>.from(json['dataTypes'] as List? ?? []),
    purpose: json['purpose'] as String,
    recipientInstitution: json['recipientInstitution'] as String,
    transmittedFields: List<String>.from(
      json['transmittedFields'] as List? ?? [],
    ),
    retentionPeriod: json['retentionPeriod'] as String? ?? '12 mois',
    actionToBePerformed: json['actionToBePerformed'] as String,
    grantedAt: DateTime.parse(json['grantedAt'] as String),
    isRevoked: json['isRevoked'] as bool? ?? false,
    consentVersion: json['consentVersion'] as String? ?? '1.0',
    checksum: json['checksum'] as String? ?? '',
  );
}

class ReportAttachment {
  final String id;
  final String fileName;
  final String fileType;
  final DateTime addedAt;
  final String? localPath;

  const ReportAttachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.addedAt,
    this.localPath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fileName': fileName,
    'fileType': fileType,
    'addedAt': addedAt.toIso8601String(),
    'localPath': localPath,
  };

  factory ReportAttachment.fromJson(Map<String, dynamic> json) =>
      ReportAttachment(
        id: json['id'] as String,
        fileName: json['fileName'] as String,
        fileType: json['fileType'] as String,
        addedAt: DateTime.parse(json['addedAt'] as String),
        localPath: json['localPath'] as String?,
      );
}

class ReportRecipient {
  final String id;
  final String name;
  final String
  type; // 'police_gendarmerie', 'procureur', 'social_services', 'custom'
  final String contactInfo;

  const ReportRecipient({
    required this.id,
    required this.name,
    required this.type,
    required this.contactInfo,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'contactInfo': contactInfo,
  };

  factory ReportRecipient.fromJson(Map<String, dynamic> json) =>
      ReportRecipient(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        contactInfo: json['contactInfo'] as String,
      );
}

class ReportDraft {
  final String id;
  final String? userId;
  final String? assessmentId;
  final Map<String, String> declaredFacts;
  final String summaryText;
  final ReportRecipient recipient;
  final List<ReportAttachment> attachments;
  final LegalReportStatus status;
  final String? consentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReportDraft({
    required this.id,
    this.userId,
    this.assessmentId,
    required this.declaredFacts,
    required this.summaryText,
    required this.recipient,
    this.attachments = const [],
    this.status = LegalReportStatus.draft,
    this.consentId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'assessmentId': assessmentId,
    'declaredFacts': declaredFacts,
    'summaryText': summaryText,
    'recipient': recipient.toJson(),
    'attachments': attachments.map((a) => a.toJson()).toList(),
    'status': status.name,
    'consentId': consentId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory ReportDraft.fromJson(Map<String, dynamic> json) => ReportDraft(
    id: json['id'] as String,
    userId: json['userId'] as String?,
    assessmentId: json['assessmentId'] as String?,
    declaredFacts: Map<String, String>.from(
      json['declaredFacts'] as Map? ?? {},
    ),
    summaryText: json['summaryText'] as String? ?? '',
    recipient: ReportRecipient.fromJson(
      Map<String, dynamic>.from(json['recipient'] as Map),
    ),
    attachments: (json['attachments'] as List? ?? [])
        .map(
          (a) => ReportAttachment.fromJson(Map<String, dynamic>.from(a as Map)),
        )
        .toList(),
    status: LegalReportStatus.values.byName(
      json['status'] as String? ?? 'draft',
    ),
    consentId: json['consentId'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  ReportDraft copyWith({
    Map<String, String>? declaredFacts,
    String? summaryText,
    ReportRecipient? recipient,
    List<ReportAttachment>? attachments,
    LegalReportStatus? status,
    String? consentId,
    DateTime? updatedAt,
  }) {
    return ReportDraft(
      id: id,
      userId: userId,
      assessmentId: assessmentId,
      declaredFacts: declaredFacts ?? this.declaredFacts,
      summaryText: summaryText ?? this.summaryText,
      recipient: recipient ?? this.recipient,
      attachments: attachments ?? this.attachments,
      status: status ?? this.status,
      consentId: consentId ?? this.consentId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
