# 1. Executive Summary

**Verdict : INCOMPLETE — 3,4/10.** NeuroSync est une application Flutter locale riche en écrans, modèles et moteurs déterministes, mais elle n'est pas un système national opérationnel de prévention, d'orientation ou de signalement. Elle ne doit pas être utilisée demain pour une situation de victime, de danger ou de transmission institutionnelle réelle.

État constaté le 2 septembre 2026, sans modification de code : 289 fichiers Dart, 9 fichiers de tests, 38 déclarations `test`, 70 routes déclarées. `flutter test` retourne le code 0 ; `flutter analyze` échoue avec 2 erreurs (`ScoreDirection` introuvable dans `lib/features/adaptive_assessment/domain/engines/scoring_engine.dart:26,36`) et 488 diagnostics. Les tests ne couvrent donc pas le build complet ni les parcours institutionnels.

Constats déterminants, prouvés par le code :

| Niveau | Constat | Preuve |
|---|---|---|
| CRITICAL | Aucun backend ni transmission institutionnelle active ; la synchronisation simule une réussite. | `lib/core/data/sync/sync_queue_service.dart:194-199` |
| CRITICAL | Les rapports victime/légaux sont sauvegardés localement dans Hive ; aucun envoi au destinataire n'est codé. | `lib/features/protection/data/repositories/hive_protection_repository.dart:15-54`; `lib/features/legal/presentation/providers/legal_providers.dart:194-204` |
| CRITICAL | L'autorisation est côté client/local ; les repositories sensibles ne reçoivent pas l'acteur qui agit. | `lib/core/services/hive_professional_repository.dart:121-138`; `lib/core/providers/unified_data_providers.dart:44-75` |
| HIGH | Le moteur national de matching existe mais n'est relié ni aux écrans ni à un annuaire national de `Partner`; aucune distance/GPS. | `lib/core/engines/partner_matching_engine.dart:16-77` |
| HIGH | Le parcours victime est indépendant et comporte questionnaire/red flags/guidance, mais son consentement initial n'est pas appliqué et ses sorties n'entraînent aucune protection réelle. | `lib/features/protection/presentation/pages/violence_understanding_flow_page.dart:24-26`; `lib/features/protection/domain/engines/violence_risk_engine.dart:70-128` |
| HIGH | L'orientation juridique est indicative dans son libellé, mais ses références locales doivent être validées par un juriste et son état « confirmé » ne transmet rien. | `lib/features/legal/domain/engines/legal_orientation_engine.dart:45-92`; `lib/features/legal/data/repositories/legal_repository.dart:291-568` |

La phrase fonctionnelle exacte est donc : **application/prototype local chiffré, avec évaluation et orientation informative locales ; pas de réseau national vérifié, pas de dossier partagé de façon sécurisée, pas de transmission à une institution, pas de sécurité serveur.**

# 2. Vision fonctionnelle réelle

La vision réellement implémentée est principalement une auto-évaluation de bien-être/vulnérabilité, des ressources, une annuaire local de psychologues de démonstration, un chat local après demande acceptée, et des modules séparés de protection/légal. Le README promet notamment Supabase et synchronisation, mais les providers instancient systématiquement Hive et les sources Supabase sont supprimées dans l'état Git observé (`README.md:64`; `lib/core/providers/unified_data_providers.dart:44-75`).

# 3. Écart entre vision client et application

| Exigence client | Documents | Code | Fonctionnelle | État / preuve | Priorité |
|---|---|---|---|---|---|
| Préorientation psychologique | Oui | Oui | Partiel | questionnaire + score local | HIGH |
| Réseau national multi-spécialistes | Oui | Modèles/engine | Non | aucun annuaire `Partner` consommé | CRITICAL |
| Orientation selon résidence/situation | Oui | Partiel | Non | filtre wilaya, engine isolé | HIGH |
| Psychologues | Oui | Oui | Partiel | profils Hive et comptes seed | HIGH |
| Neurologues/autres spécialistes | Oui | Enum/modèle | Non | aucun parcours/directoire vivant | HIGH |
| Éducation/université/entreprise/association | Oui | Modèles seulement | Non | `AwarenessPartner` non raccordé | HIGH |
| Sensibilisation | Oui | Oui | Partiel | ressources statiques/admin local | MEDIUM |
| Parcours victime | Oui | Oui | Partiel | assessment local, pas d'aide réelle | CRITICAL |
| Parcours auteur/vulnérabilité | Oui | Oui | Partiel | pas de rôle « actor », questionnaire générique | HIGH |
| Témoin | Non explicite | Non | Non | pas de situation/rôle witness | MEDIUM |
| Évaluation violence/type/gravité/risque | Oui | Oui | Partiel | moteur local non validé cliniquement | HIGH |
| Conseils initiaux | Oui | Oui | Partiel | guidance statique locale | HIGH |
| Signalement/transmission | Oui | Formulaires/modèles | Non | Hive seulement | CRITICAL |
| Orientation juridique/information | Oui | Oui | Partiel | contenu local à valider | HIGH |
| Consentement | Oui | Modèles/UI | Partiel | stockage local, révocation sans effet global | CRITICAL |
| Suivi/statut institutionnel | Oui | Enums/modèles | Non | pas d'API/accusé de réception | CRITICAL |

# 4. Architecture

Architecture Flutter/Riverpod « feature-first » partielle : `adaptive_assessment`, `protection` et `legal` ont data/domain/presentation ; beaucoup d'autres features accèdent directement à Hive. Deux familles d'engines coexistent (`lib/core/engines/` et `lib/features/adaptive_assessment/domain/engines/`), créant un risque de divergence ; l'évaluation utilise la seconde famille (`assessment_provider.dart:3-12`).

```text
UI/GoRouter → Riverpod notifier/provider → engine/repository → Hive local chiffré
                                            └→ SyncQueue simulée (pas d'API)
```

# 5. Arborescence

Périmètre inspecté : `lib/`, `test/`, `docs/`, `README.md`, `pubspec.*`, plateformes Flutter et le DOCX. Features pertinentes : `adaptive_assessment`, `protection`, `legal`, `professional`, `messaging`, `admin`, `health`, `resources`, `wellness`. Aucun dossier backend actif n'est présent : `git status` montre `backend/` supprimé. Le worktree était déjà très modifié/sale ; aucune source existante n'a été changée par cet audit.

Documents fonctionnels analysés :

| Document | Objectif/domaine | Règles/acteurs constatés | Comparaison code |
|---|---|---|---|
| `README.md` | vision, assessment, Wilaya, Supabase | visiteur, patient, psychologue, admin | backend annoncé non présent ; orientation locale seulement |
| `Approche intégrée de prévention criminelle et de repérage précoce.docx` | prévention/violence | prévention multi-acteurs, repérage précoce, précautions éthiques | protection existe, intégration sociale/institutionnelle absente |
| `docs/05_SPECIFICATION_VERSION_FINALE_TESTABLE.txt` | spécification/workflows | états, comptes, orientation | de nombreuses étapes ne sont que locales |
| `docs/LOCAL_INSTITUTIONAL_PILOT_GOVERNANCE.md` | gouvernance | validation institutionnelle | service local de préparation, sans intégration |
| `docs/API_INTEGRATION_GUIDE.md` | API | contrat envisagé | `ApiClient` non consommé par les flux critiques |
| `docs/PROTECTION_IMPLEMENTATION_STATUS.md` | protection | victim/risk/report | modèles présents, transmission absente |
| `docs/*AUDIT*.md`, `FINAL_REPORT.md` | audits antérieurs | constats/propositions | sources secondaires, non preuve d'exécution |
| `docs/liste_psychologues_algerie.md`, `wilaya_psychologues_accounts.txt` | annuaire | psychologues/wilayas | importés comme comptes seed, vérification externe non démontrée |
| `docs/AYAT_BDD.txt`, `AHADITH_BDD.txt`, `HIKEM_BDD.txt` et vérifications | contenus spirituels | contenu/sources | bibliothèques statiques, pas traitement médical |

# 6. Fonctionnalités existantes

Onboarding FR/AR, guest local, inscription/login locaux, sélection de wilaya, assessment adaptatif, scoring/orientation locaux, résultats, historique Hive, recherche de psychologues, demandes d'accès, chat local, dashboards admin locaux, ressources/bien-être, protection, orientation juridique, ébauches de consentement et de rapport.

# 7. Fonctionnalités manquantes

Backend authentifié, RBAC serveur, API de signalement, réception/accusé institutionnel, réseau national vérifié de partenaires, matching consommé par l'UI, GPS/distance, gestion de partenaires/campagnes, notifications réelles, synchronisation réelle, révocation appliquée, suppression/rétention, portail institution/entreprise/éducation, tests E2E/integration et validation clinique/juridique.

# 8. Routes

70 routes sont centralisées dans `lib/core/navigation/app_router.dart:228-526`. Le guard bloque `/admin*`, `/psychologist*`, `/user`, `/session-request`, mais de nombreuses routes sensibles sont déclarées publiques : protection, légal, history, results, professional search et communications (`:120-151`). Les guards sont UI/client uniquement.

| Groupe | Routes | Rôle/guard réel |
|---|---|---|
| Public | `/`, `/guest`, `/assessment`, `/protection*`, `/legal*`, `/history`, `/resources` | aucune identité requise |
| User | `/user`, `/session-request` | rôle user |
| Psychologue | `/psychologist`, `pending`, `requests`, `patients/:id` | rôle psychologist et statut actif |
| Admin | `/admin/*` | rôle admin |
| Partenaire/institution/victime/actor/witness | aucune route dédiée | manquant |

# 9. Authentification

Authentification locale Hive, hash côté client et état persistant : `lib/core/services/auth_repository_impl.dart:94-260`. Pas de token, expiration, refresh, MFA effective, vérification e-mail distante, récupération de mot de passe ou identité professionnelle indépendante. L'environnement est forcé à `dev` (`lib/main.dart:19`).

# 10. Rôles

Rôles réels : `guest`, `user`, `psychologist`, `admin` (`lib/core/auth/user_role.dart:5-14`). `Victim`, `actor`, `informational` ne sont que des valeurs de `UserSituation` dans les modèles core (`lib/core/models/enums.dart:10-17`) ; ils ne sont ni rôles, ni ACL, ni dashboards. `Witness`, professional générique, partner, institution, company, educational organization : **MISSING** comme rôles d'authentification.

# 11. Permissions

`RolePermissions` décrit des permissions déclaratives (`lib/core/auth/role_permissions.dart:3-51`), mais le routeur/repositories ne l'appellent pas. `AccessControl` est incomplet et accorde au psychologue ou admin un historique selon le rôle sans relation/consentement (`lib/core/models/access_control.dart:3-19`).

| Fonction | Guest | User | Victim | Psychologist | Professional | Partner/Institution | Admin |
|---|---|---|---|---|---|---|---|
| Assessment/ressources | oui | oui | même user/guest | oui | n/a | n/a | oui |
| Créer rapport protection | oui (public) | oui | même parcours | oui | n/a | n/a | oui |
| Voir propre assessment | fragile/public | oui local | non séparé | si request acceptée | n/a | n/a | oui local |
| Chat | non sans relation | après request | non séparé | après request | n/a | n/a | bypass |
| Valider professionnel | non | non | non | non | n/a | n/a | route UI |
| Export/transmission | non réel | non réel | non réel | non réel | non réel | non réel | non réel |

# 12. User

`UserModel` stocke id, e-mail, rôle/statut, dates, wilaya, préférences et quelques flags (`lib/core/models/user_model.dart:7-129`). Un utilisateur peut faire l'assessment et demander une relation avec un psychologue. Les données restent sur le même appareil, non dans un espace utilisateur serveur.

# 13. Victim

Le module victime/protection est réel au niveau local : `/protection/flow` collecte catégories, contexte, fréquence, durée, relation, réponses adaptatives, calcule red flags/gravité et affiche guidance. Call graph : `ViolenceUnderstandingFlowPage → protection providers → AdaptiveProtectionQuestionEngine/ViolenceRiskEngine → HiveProtectionRepository` (`violence_understanding_flow_page.dart:14-36`; `protection_providers.dart`; `hive_protection_repository.dart:92-128`).

Il n'existe ni identité « victim » séparée, ni mécanisme de protection externe, ni dossier partagé contrôlé, ni institution destinataire. Le booléen `_consentGiven` est déclaré mais jamais lu (analyseur : `violence_understanding_flow_page.dart:26`), donc il ne constitue pas un consentement effectif.

# 14. Actor / Vulnerability

L'axe vulnérabilité existe par le questionnaire général (émotions, stress, sommeil, productivité, social, colère, confiance, pressions, style de vie, safety). Il n'existe pas de parcours auteur distinct : aucune question de passage à l'acte, relation à la victime, suivi/récidive, rôle actor ou orientation spécifique. Ne pas interpréter les scores comme une classification de dangerosité : l'UI doit rester informationnelle.

# 15. Witness

**MISSING.** Aucun modèle, situation, questionnaire, route, guidance ou signalement témoin n'a été trouvé (`rg` sur `witness` dans `lib/` ne retourne pas de module métier).

# 16. Psychological Assessment

Flux vivant : `AssessmentPage → AssessmentNotifier → AdaptiveQuestionEngine/SafetyEngine/ScoringEngine/OrientationEngine/RecommendationEngine → HiveAssessmentRepository`. Voir `lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart:43-187`. Les résultats enregistrés ne conservent pas axes, recommendations ni trace complète (`lib/features/assessment/assessment_record.dart:7-41`). Les 40 questions sont statiques dans `data/question_bank.dart`.

# 17. Violence Assessment

`ViolenceAssessment` couvre catégories, réponses, fréquence, durée, contexte, relation et anonymat (`lib/features/protection/domain/models/protection_models.dart:680-748`). `ViolenceRiskEngine` additionne des facteurs, applique des red flags et produit niveau/guidance/orientation (`violence_risk_engine.dart:70-128`). C'est un moteur de règles local, pas une évaluation clinique/forensique validée ; ses seuils/version sont codés (`:21-58`) sans preuve de validation professionnelle.

# 18. Safety Engine

Deux safety engines : le questionnaire psychologique détecte les triggers et l'orientation a priorité (`lib/features/adaptive_assessment/domain/engines/safety_engine.dart:22-93`; `orientation_engine.dart:8-49`), mais le provider conduit à la page de résultat normale au lieu d'un parcours sécurité dédié (`assessment_provider.dart:80-92`). Dans protection, le red flag interrompt les questions et produit niveau 4. Aucun appel à une institution, aucun accusé de réception et aucun mécanisme médical réel ne suit le safety path.

# 19. Adaptive Question Engine

Psychologique : sélection par priorité/score/contexte, sans répétition (`adaptive_question_engine.dart:52-115`) ; les champs `conditions` et `rules` sont déclarés mais non interprétés (`domain/models/assessment_question.dart:22-46,85-88`). Protection : non-répétition et adaptation aux catégories, testée. Statut : **PARTIAL** ; branching non démontré, reprise/draft non complétée.

# 20. Scoring Engine

Le scoring feature normalise poids/réponses et inverse les items selon `ScoreDirection`, mais le symbole n'est pas défini : l'analyse complète échoue (`scoring_engine.dart:26,36`). Les tests de `core/engines/scoring_engine.dart` passent, mais c'est un moteur parallèle et ne prouve pas que le flux UI compile. Validation psychométrique, bornes par banque complète et biais : **manquants**.

# 21. Decision Engine

Le flux assessment utilise `OrientationEngine`, pas `lib/core/engines/decision_engine.dart`. Règles locales de niveau 0–4 : urgent, nombres d'axes moyens/élevés et maximum normalisé (`features/adaptive_assessment/domain/engines/orientation_engine.dart:8-49`). L'engine core est du code concurrent non raccordé. Psychological et violence/safety sont séparés par modules, mais duplication/décisions concurrentes est un risque architectural.

# 22. Recommendation Engine

`RecommendationEngine` sélectionne les recommandations statiques par axe (`features/adaptive_assessment/domain/engines/recommendation_engine.dart:5-32`). Il ne prend pas wilaya, distance, disponibilité, consentement, relation pro ni statut partenaire ; les ids ne sont pas une mise en relation réelle. **PARTIAL / local.**

# 23. Partner Matching

`PartnerMatchingEngine.matchPartners()` filtre active+verified puis note wilaya 40, commune 20, case type 20, risque 15, disponibilité 10, langue 5 (`lib/core/engines/partner_matching_engine.dart:16-77`). Input→normalisation : absent ; rules/scoring/filter/ranking : réel ; source de partenaires/UI/repository : manquants ; distance/lat/lon : absentes. Scénario demandé : P1 même wilaya adapté/disponible/vérifié est classé avant P2 autre wilaya ; P3 mauvaise spécialité reste néanmoins classable si case type correspond car spécialité n'est pas filtrée explicitement ; P4 indisponible perd 10 mais n'est pas exclu ; P5 non vérifié est exclu. Le moteur n'est appelé par aucun parcours d'orientation constaté.

# 24. National Network

Le modèle national est **PROPOSED, NOT IMPLEMENTED**. `Partner`, `Institution`, `PartnerType` et `PartnerStatus` existent (`partner_core_models.dart:25-102`; `enums.dart:70-98`), mais aucune seed/CRUD/UI/repository de `partners`, aucune API et aucun raccordement à matching. Les 232 psychologues seed ne constituent pas un réseau national vérifié.

# 25. Wilaya

Les 58 wilayas sont listées de 01 à 58 dans `lib/core/data/wilaya_data.dart:3-77`; la sélection est stockée localement. Le répertoire professionnel compare principalement la wilaya ; aucune commune normalisée exhaustive, latitude, longitude, calcul d'itinéraire ou wilayas limitrophes. **Simple filtrage par wilaya, pas proximité réelle.**

# 26. Specialists

Le modèle core prévoit psychologist, psychiatrist, neurologist, healthProfessional, socialWorker, legalSupport, association, otherSpecialist (`enums.dart:70-87`). L'application exploite réellement des `ProfessionalProfile` majoritairement psychologues ; pas de workflow pour neurologue, médecin, biologiste ou autre spécialiste. Ajouter des professions nécessiterait une validation de besoin et de compétence, non une simple enum.

# 27. Psychologists

Inscription pending, profil, recherche, demande, acceptation, patients autorisés et chat local existent. `HiveProfessionalRepository.getAuthorizedPatients` filtre les demandes acceptées (`hive_professional_repository.dart:141-190`). La vérification de diplôme/identité n'est pas implémentée ; l'acceptation ne reçoit pas l'identité de l'appelant et peut être modifiée dans la base locale (`:121-138`).

# 28. Other Professionals

**MISSING FUNCTIONALLY.** Enum/modèles seulement ; pas d'inscription/rôle/dashboard/validation, relation ou orientation pour psychiatre, neurologue, médecin, biologiste, juriste ou travailleur social.

# 29. Educational Partners

`AwarenessPartner` prévoit collège/lycée/université/entreprise/association, wilaya, commune, vérification et e-mail (`lib/core/models/awareness_core_models.dart:50-75`). Aucun repository, route, dashboard, permissions ou agrégats n'est relié : **model-only**.

# 30. Universities

**MISSING FUNCTIONALLY.** Université est une chaîne possible du modèle `AwarenessPartner`, sans campagne réelle, responsable, statistiques agrégées, isolation des données individuelles ou dashboard.

# 31. Companies

**MISSING FUNCTIONALLY.** Même état que l'université ; aucun employeur ne doit obtenir les assessments individuels. Le code ne fournit pas un tel accès, mais ne fournit non plus de portail/contrôle d'agrégation.

# 32. Associations

Association est prévue comme `PartnerType` et awareness type ; aucun annuaire vérifié, matching alimenté, contrôle de statut ou mise en relation effective.

# 33. Awareness

Ressources/health/contenus et écran admin awareness existent. `Resource`, `AwarenessCampaign` et `AwarenessPartner` sont des modèles (`awareness_core_models.dart:7-103`), sans service métier ni campagne consommable. La prévention primaire est donc limitée à des contenus statiques ; la secondaire existe partiellement via questionnaires ; la tertiaire n'a pas de suivi institutionnel/récidive.

# 34. Consent

Deux systèmes distincts : `Consent` core (`consent_model.dart:7-34`) et `ConsentRecord` légal (`legal_models.dart:318-386`). Le centre légal montre data/purpose/destinataire/champs/rétention puis sauvegarde localement (`legal_providers.dart:89-125`). `isRevoked` existe mais aucune opération de révocation appliquant partage, stockage ou transmission n'est trouvée. Le checksum est une chaîne `sha256_<timestamp>`, pas un hash cryptographique démontré (`:102-116`).

# 35. Access Requests

`AccessRequest` relie user/professionnel/statut/date/message ; le chat UI vérifie une demande `accepted` (`chat_page.dart:52-77`). Limite critique : `respondToRequest()` prend seulement request id et statut, pas professional id ni consentement explicite (`hive_professional_repository.dart:121-138`). Pas de révocation/expiration/audit complet.

# 36. Chat

UI : `ChatPage → _canCommunicate → HiveProfessionalRepository → HiveMessageRepository → messages_box` (`chat_page.dart:43-93`). La restriction UI relation acceptée est utile ; l'admin bypass est explicite (`:56-63`). Repository de messages ne vérifie aucune relation et expose conversations par ids (`hive_message_repository.dart:8-37`). Pas de serveur, E2EE, suppression, rétention, notifications push ni logs de contenu ; confidentialité limitée à l'appareil/chiffrement Hive.

# 37. Notifications

Des modèles `Notification`/`NotificationModel` existent, mais aucun service de delivery, token, push, queue reliée ou événements exhaustifs. Les événements Assessment Completed, Recommendation, Access Request, Report Submitted/Status et Professional Approval ne sont pas garantis. **MODEL/LOCAL ONLY.**

# 38. Violence Reports

`ViolenceReport` contient id, reporter mode, types, contexte, occurrence, risk assessment, statut, consent version, description/location approximative, relation, attachments, professional/closure (`protection_models.dart:838-885`). Statuts : draft/submitted/underReview/referred/inFollowUp/resolved/closed (`:5-13`). `HiveProtectionRepository.saveReport` les écrit localement (`hive_protection_repository.dart:15-54`). « submitted » signifie une valeur locale, jamais une réception institutionnelle.

# 39. Institutional Transmission

**NOT IMPLEMENTED.** Aucun endpoint de rapport, auth, chiffrement transport, consentement côté serveur, accusé de réception, destination validée ou statut distant. `SyncQueueService._executeRemoteSync()` attend 100 ms et retourne `true` (`sync_queue_service.dart:194-199`). `ApiClient` contient une URL HTTP non chiffrée (`lib/core/api/api_client.dart:14`) et n'est pas consommé par les rapports. L'application contient une architecture de frontend/prototype et ne fournit pas de transmission institutionnelle réelle.

# 40. Legal Information

Le questionnaire légal, la catégorisation et les procédures sont locaux. `LegalOrientationEngine` filtre les articles actifs/validés et rédige une qualification explicitement indicative (`legal_orientation_engine.dart:45-92,233-241`). C'est conforme à l'intention « information/orientation », non une décision judiciaire. Les numéros/institutions affichés doivent être vérifiés avant diffusion publique.

# 41. Legal References

`LegalSource`, `LegalVersion`, `LegalArticle` gardent source, date, version et statut validation (`legal_models.dart:47-106,171-241`). Des références préchargées utilisent `v2026.1-DZ-OFFICIAL` (`legal_repository.dart:320-330,491-568`), mais elles sont saisies dans Hive par l'application. **LEGAL SOURCE PRESENT — LEGAL CONTENT REQUIRES HUMAN/LEGAL VALIDATION.** Aucune preuve de récupération d'une source officielle actuelle ou de relecture juriste indépendante.

# 42. Privacy

Données sensibles : réponses psychologiques, résultats, rapports de violence, localisation approximative, messages, profils professionnels et informations légales. Stockage : boxes Hive AES (`hive_config.dart:157-237`) dont la clé est dans `flutter_secure_storage` (`:240-251`). Le chiffrement local est une bonne mesure, mais ne remplace pas RBAC serveur, rétention, effacement, minimisation, consentement effectif, séparation profils/agrégats ou contrôle par relation. Admin/Hive local peut contourner les restrictions UI.

# 43. Security

Points positifs : chiffrement Hive, hash login local, routes de rôle et statuts de compte. Failles : build en dev, logs, `ApiClient` HTTP, absence de secrets/token serveur, auth local falsifiable sur appareil compromis, contrôles repository insuffisants, admin bypass chat, règles de permission non appliquées, aucun audit immuable. `RolePermissions` est décoratif (`role_permissions.dart:3-51`).

# 44. Location

Wilaya/commune sont des chaînes de modèle. `LocationService` ouvre une URL Google/Apple Maps à partir d'une latitude/longitude fournie (`lib/core/services/location_service.dart:4-16`) ; il ne collecte pas de position, ne demande pas permission et ne calcule pas de distance. Pas de stockage/partage GPS réel : risque de géolocalisation précise limité actuellement, mais proximité annoncée non réalisée.

# 45. Offline-First

Assessment, scoring, safety local, ressources, historique local, rapports/brouillons locaux et chat sur le même appareil peuvent fonctionner hors ligne après initialisation. Guest emploie littéralement `userId = "guest"`, donc plusieurs visiteurs du même appareil partagent cet espace (`assessment_page.dart:27-33`). Ce n'est pas une séparation multi-utilisateur solide.

# 46. Synchronization

`SyncItem`, queue, retry et conflict resolver existent, mais l'exécution distante est simulée. Pas de endpoints, authentification, reprise réelle, transfert d'attachments, conflits résolus contre serveur ou synchronisation de messages/rapports. **NOT IMPLEMENTED.**

# 47. Backend

Interfaces `*RemoteDataSource` seulement (`lib/core/data/remote_data_source.dart:6-22`). Les providers injectent Hive (`unified_data_providers.dart:44-75`), et les fichiers backend figurent supprimés dans l'état Git. **The application currently contains a frontend/prototype architecture and does not yet provide real institutional transmission.**

# 48. API

| Endpoint | Méthode/Auth | Usage réel | Données sensibles |
|---|---|---|---|
| `ApiClient.baseUrl` `/api` | GET/POST, aucun bearer/HTTPS imposé | aucune invocation critique trouvée | risque si utilisé |
| transmission report | absent | absent | rapports/consentement |
| auth backend | absent | absent | identités |
| matching/directory backend | absent | absent | partenaires |

# 49. Database

Base effective : Hive local. Tables/migrations SQL/backend absentes du worktree ; Hive boxes ne fournissent pas clés étrangères, contraintes multi-utilisateur, transactions serveur, index national ou RLS. `DatabaseMigrationService` ne transforme pas le stockage en backend. Les boxes standardisés sont ouverts, mais beaucoup contiennent `dynamic` (`hive_config.dart:200-237`).

# 50. Models

Inventaire métier pertinent : `UserModel`, `AssessmentRecord`, `AssessmentSession/Result/Question`, `AccessRequest`, `ProfessionalProfile/Model`, `SessionRequestModel`, `MessageModel`, `ViolenceAssessment/Result/Report/RiskAssessment/Referral/SafetyPlan/ProtectionAudit`, `LegalCategory/Source/Version/Procedure/Article/Assessment/ConsentRecord/ReportDraft/Attachment/Recipient`, `Partner/Speciality/Institution`, `AwarenessPartner/Campaign/Resource/Notification`, `Consent`, `SyncItem`, `SecurityLog`. Sérialisation : Hive adapters pour une partie ; protection/légal sont majoritairement JSON/maps `dynamic`; relations sont ids sans contraintes. Plusieurs modèles core (Partner/Awareness/Consent) ne sont pas enregistrés/consommés dans les flux actifs, donc **proposés**.

# 51. Relations

```text
IMPLEMENTED LOCAL
User ──< AssessmentRecord
User ──< AccessRequest >── Professional
Accepted AccessRequest ──> chat UI authorization
User? ──< ViolenceAssessment / ViolenceReport (Hive)
Legal ConsentRecord ──? ReportDraft (local id only)

PROPOSED / NOT CONNECTED
User → Need → PartnerMatchingEngine → Partner
Victim → ViolenceCase → Report → Institution
User → Consent → Authorized professional access
AwarenessPartner → AwarenessCampaign → aggregated metrics
```

| Source | Relation | Destination | Cardinalité | Permission/consentement | Implémenté |
|---|---|---|---|---|---|
| User | owns | AssessmentRecord | 1:N | local id | oui local |
| User | requests | Professional | N:N via AccessRequest | accepted, non révocable | partiel |
| Professional | reads | User assessments | 1:N | relation UI, pas serveur | partiel |
| Victim/User | creates | ViolenceReport | 1:N | formulaire local | oui local |
| Report | transmitted to | Institution | 0 | consent modèle seulement | non |
| User need | matches | Partner | N:N | engine sans source | non |

# 52. Services

| Service/repository | Domaine | Réel | Entrées/sorties |
|---|---|---|---|
| `HiveAuthRepository` | auth | local | credentials/UserModel |
| `HiveAssessmentRepository` | assessment | local | AssessmentRecord |
| `HiveProfessionalRepository` | directory/access | local | profile/request/user |
| `HiveMessageRepository` | chat | local | MessageModel |
| `HiveProtectionRepository` | violence | local | maps reports/assessments |
| `HiveLegalRepository` | legal/consent/draft | local | models/maps |
| `HiveAdminRepository`, security/content repos | admin | local | boxes |
| `SyncQueueService` | sync | mock | SyncItem→true |
| `ApiClient` | HTTP | dormant/insecure | dynamic JSON |
| `InstitutionalReadinessService` | governance | local | approval flags |
| `LocationService` | maps | local launcher | URL |

# 53. Repositories

Interfaces existent pour assessment/professional/admin/protection/access/auth ; implémentations effectives Hive. `RemoteDataSource` est abstrait, pas une implémentation. `HiveLegalRepository` n'est pas caché derrière une abstraction et est directement fourni (`legal_providers.dart:8-12`). Aucun repository Partner/Awareness/Institution opérationnel.

# 54. Riverpod

Providers importants : auth/router, assessment notifier, protection providers, legal providers/notifiers, unified data providers, health/progress/team/admin. Les actions critiques gèrent rarement `AsyncLoading`/erreur/autorisation : plusieurs widgets appellent directement Hive. `assessmentRepositoryProvider`, `professionalRepositoryProvider`, `protectionRepositoryProvider` retournent Hive (`unified_data_providers.dart:44-75`). Aucun provider backend de prod sélectionné.

# 55. Localization

FR et AR sont supportés (`lib/main.dart:37-43`, ARB/generated). Messages de domaines sensibles sont en partie codés en français, notamment guidance/consentement ; audit linguistique humain arabe/darja et juridique reste nécessaire. `flutter analyze` signale aussi des fichiers de vérification `.dart` dans `docs/` et des incohérences de style.

# 56. RTL

Locale arabe est déclarée et Flutter gère direction. Aucune campagne de tests widget/visuels RTL pour les formulaires, tableaux, nombres de téléphone ou longs textes légaux n'est présente : **PARTIAL**.

# 57. UI/UX

Écrans nombreux et design system présent. Points de rupture : routes sensibles publiques, feedback « submitted » sans transmission, consentement victime inactif, résultat psychologique normal après trigger, données seed présentables comme annuaire. Pour victime : formulations globalement non culpabilisantes dans les catégories/guidance, mais sécurité opérationnelle insuffisante. États loading/empty existent ponctuellement ; offline/error/unauthorized ne sont pas homogènes.

# 58. Accessibility

Pas d'audit/accessibility tests, semantic labels ou parcours lecteur d'écran systématiques trouvés. Contrastes, focus clavier/web, taille de texte, RTL et gestes doivent être vérifiés avant diffusion. **NOT VERIFIED.**

# 59. Performance

Application locale ; Hive convient au prototype. Aucun benchmark, pagination, profilage, stratégie d'attachments ou index de grande taille. Les recherches/filtrages sont en mémoire. `flutter analyze` recense beaucoup d'avertissements/obsolescences : dette de qualité avant optimisation.

# 60. Tests

9 fichiers, 38 déclarations test ; `flutter test` code 0. Couverture : engines core/protection/légal, auth seed, chat local, data layer, hadith. Manquent tests widget/routes, intégration, autorisations adversariales, consentement refusé/révoqué, rapport transmis/réçu, offline/retry réel, partner matching alimenté, access admin, sécurité API, anonymisation/agrégats, victim E2E et build/analyzer vert. `flutter analyze` : 2 erreurs et 488 diagnostics, donc CI de production non verte.

# 61. Mocks

| Élément | Classement | Preuve |
|---|---|---|
| Sync remote retourne true | MOCK HIDING MISSING PRODUCTION FEATURE | `sync_queue_service.dart:194-199` |
| Ressources/professionnels d'écran resources | MOCK HIDING MISSING PRODUCTION FEATURE | `resources_screen.dart:92,234` |
| 232 comptes professionnels seed | prototype/données de démonstration à vérifier | `database_seed_service.dart:138-217` |
| Models/engines partner awareness | mock structure acceptable seulement hors production | modèles non consommés |
| API URL sans flux | placeholder/dormant | `api_client.dart:14-60` |

# 62. Dead Code

Engines core de décision/scoring/adaptatif en concurrence avec ceux de feature ; `RolePermissions` non appliqué ; `AccessControl` quasi non raccordé ; RemoteDataSource abstrait ; `LocationService` isolé ; modèles Partner/Awareness/Consent core non intégrés. L'analyseur signale notamment code mort dans `assessment_page.dart:56` et `professional_search_page.dart:337`.

# 63. Fonctionnalités fantômes

« Supabase authentication and synchronization » README, transmission/signalement, réseau national, partenaire/éducation/université/entreprise, statistiques agrégées, notifications, GPS/proximité, téléconsultation et suivi institutionnel ne sont pas fonctionnels. Les routes/modèles ne constituent pas une fonctionnalité de production.

# 64. Bugs

| ID | Fichier:ligne | Problème | Impact | Correction Phase 2 |
|---|---|---|---|---|
| B-01 | `scoring_engine.dart:26,36` | `ScoreDirection` indéfini | analyse/build échoue | corriger import/modèle + tests |
| B-02 | `assessment_provider.dart:80-92` | trigger safety rend résultat standard | danger non priorisé | relier sécurité à parcours dédié |
| B-03 | `violence_understanding_flow_page.dart:26` | consentement non utilisé | consentement illusoire | bloquer/expliquer et persister |
| B-04 | `hive_professional_repository.dart:121-138` | réponse request sans propriétaire | élévation locale | ajouter actor/ownership serveur |
| B-05 | `sync_queue_service.dart:194-199` | sync réussit fictivement | faux signalement/suivi | supprimer prétention ou implémenter API |

# 65. Security Vulnerabilities

CRITICAL : auth/RBAC/institutional transmission inexistants côté serveur ; fausse synchronisation. HIGH : HTTP dans `ApiClient`, environment dev/logs, contrôle d'accès repository absent, admin chat bypass, partage device local. MEDIUM : permissions décoratives, clés/chiffrement dépendants appareil, nombre d'avertissements/obsolescences. Ne pas traiter les boîtes Hive chiffrées comme une frontière de sécurité multi-acteurs.

# 66. Privacy Risks

CRITICAL : rapport déclaré « submitted » sans destination/consentement transmis vérifiable ; impossible de satisfaire réellement droits de retrait/traçabilité. HIGH : historique/messages/rapports co-résident sur l'appareil et protection de relation côté UI. HIGH : guest commun `"guest"`. MEDIUM : pas de politiques de rétention/suppression ni agrégation partenaire. Les établissements/entreprises n'ont pas de portail actuellement ; ils ne reçoivent donc pas de données, mais le futur modèle doit imposer données agrégées uniquement.

# 67. Legal Risks

Les articles/procédures/numeros et « officiel » sont stockés en local. Leur validité actuelle ne peut pas être conclue à partir du code. Les mots « submitted », « institution », « legal » peuvent créer une attente de procédure réelle. Toute diffusion nécessite validation juridique algérienne, mise à jour versionnée de sources officielles, règles de conservation/consentement et disclaimer visible.

# 68. Ethical Risks

Scores et risk rules ne sont pas preuves cliniques ni prédictions de violence. Risque de stigmatisation d'auteur/vulnérabilité, fausse assurance d'une victime, biais des règles/seuils, confusion entre violence et crime, mélange spiritualité/soin. Les formulations doivent rester besoin de soutien/orientation ; aucun registre de « personnes dangereuses » n'a été trouvé, ce qui est positif.

# 69. Missing Features

Prioritaires : sécurité victime réellement prioritaire, backend/RBAC/audit, consentement/révocation exécutoires, report API sécurisé et protocole institutionnel, partner directory vérifié, matching réellement intégré, statut distant, portails/agrégats awareness, rôles author/witness/partner/institution, gestion des preuves, notifications, retention/deletion, géographie/distance, tests E2E.

# 70. Technical Debt

Duplication engines, modèles/migrations Hive `dynamic`, imports inutiles, warnings/obsolescences, code mort, incohérence README/backend, worktree avec suppressions, fichiers générés/modèles non reliés et absence de frontière domaine/infra. Stabiliser compilation/analyse avant ajout fonctionnel.

# 71. Priority Matrix

| Priorité | Action | Condition de sortie |
|---|---|---|
| P0 CRITICAL | Ne pas diffuser comme outil de crise/transmission ; corriger build + safety UI | `flutter analyze` 0 erreur, parcours urgence explicite |
| P0 CRITICAL | Concevoir backend/RBAC/audit/consentement avant toute transmission | tests d'autorisation serveur et protocole validé |
| P0 CRITICAL | Retirer tout libellé laissant croire à un report transmis | statut local explicite ou API accusée |
| P1 HIGH | Validation clinique/psychologique et juridique | experts documentés/versionnés |
| P1 HIGH | Réseau partenaires vérifié + matching intégré | données validées, distance/disponibilité, tests |
| P1 HIGH | Parcours victim/actor/witness distincts | E2E sécurité/consentement |
| P2 MEDIUM | Awareness/agrégats/accessibilité/RTL/performance | tests et politiques |

# 72. Roadmap

**Phase 2 — corrections seulement, après autorisation explicite** : 1) erreurs analyzer et safety UI ; 2) cohérence repositories/permissions et textes locaux ; 3) tests de régression et E2E locaux. **Phase 3 — nouvelles fonctions, après Phase 2** : backend sécurisé et gouvernance, victim/reporting/transmission réelle, partner directory/matching national, awareness partners et agrégats. Ne pas mélanger corrections et fonctionnalités nouvelles.

# 73. Final Verdict

**INCOMPLETE.** Demain, une personne peut parcourir un questionnaire, recevoir une information locale, consulter des contenus, chercher des profils seed et, après acceptation locale, discuter sur le même appareil. Une victime peut remplir une évaluation/rapport local et recevoir guidance informative, mais aucun signalement ni protection n'est transmis à une autorité. Un psychologue/admin local peut consulter/manipuler les données de l'appareil selon les routes/repositories, sans barrière serveur. Les partenaires éducatifs, entreprises, universités, institutions et le réseau national ne disposent d'aucun parcours opérationnel. Les données ne sortent pas de l'appareil — sauf si du code non présent est ajouté — et aucune orientation institutionnelle réelle n'est effectuée.

## Matrice globale des fonctionnalités

| ID | Domaine | Fonctionnalité | Code/route | Rôle | Service/modèle | Backend | Réel/Mock | Statut | Gravité |
|---|---|---|---|---|---|---|---|---|---|
| F-01 | Assessment | questionnaire adaptatif | `/assessment` | guest/user | provider/engines/Hive | non | réel local | partiel | HIGH |
| F-02 | Safety | red flags psycho | assessment | guest/user | SafetyEngine | non | réel local/UI cassée | partiel | CRITICAL |
| F-03 | Violence | victim assessment | `/protection/flow` | public | ViolenceRiskEngine/Hive | non | réel local | partiel | HIGH |
| F-04 | Reports | rapport violence | `/protection/report` | public | HiveProtectionRepository | non | local | non transmis | CRITICAL |
| F-05 | Legal | questionnaire/orientation | `/legal/*` | public | LegalOrientationEngine/Hive | non | local | partiel | HIGH |
| F-06 | Consent | consent/draft | `/legal/consent` | public/user | ConsentRecord/Hive | non | local | partiel | CRITICAL |
| F-07 | Partner | matching national | aucune UI | n/a | PartnerMatchingEngine | non | engine isolé | non | HIGH |
| F-08 | Directory | psychologues | `/professional-search` | public | Hive profiles/seed | non | seed local | partiel | HIGH |
| F-09 | Chat | user-pro relation | communications | user/psychologist | HiveMessageRepository | non | local | partiel | HIGH |
| F-10 | Awareness | campagnes partenaires | admin awareness | admin | models only | non | ghost | non | MEDIUM |
| F-11 | Sync | queue/retry | none | n/a | SyncQueueService | non | fake success | non | CRITICAL |

## Matrice document → code

| Exigence document | Fichier code | Classe/fonction | Implémenté | Partiel | Mock | Manquant |
|---|---|---|---|---|---|---|---|
| prévention/repérage précoce | assessment/protection | engines |  | oui |  | validation/exécution terrain |
| orientation spécialiste | partner matching | `matchPartners` |  | engine | oui données | raccordement/UI/réseau |
| protection victime | protection | `ViolenceRiskEngine.evaluateAssessment` |  | oui |  | intervention réelle |
| signalement volontaire | legal/protection | `saveReport`, `saveReportDraft` |  | local |  | transmission/ack |
| info juridique indicative | legal | `LegalOrientationEngine.evaluate` | oui local |  |  | validation indépendante |
| institutions/partenaires | core models | `Partner`, `Institution`, `AwarenessPartner` |  | modèles | oui | CRUD/roles/API |

## Matrice des partenaires

| Type | Modèle | Route/dashboard | Validation | Matching | Status |
|---|---|---|---|---|---|
| Psychologue | ProfessionalProfile | oui | admin local | recherche wilaya, pas engine | pending/approved local |
| Neurologue/médecin/autre | PartnerType | non | non | engine isolé | enum only |
| Association | Partner/AwarenessPartner | non | non | engine isolé | model only |
| Établissement/université/entreprise | AwarenessPartner | non | non | non | model only |
| Institution publique | Institution | non | non | non | model only |

## Matrice des parcours

| Parcours | Début | Étapes réelles | Fin | Fonctionnel | Problèmes |
|---|---|---|---|---|---|
| User | guest/login | assessment→score→résultat→Hive | orientation informative | partiel | build/safety/aucun matching |
| Victim | `/protection` | catégories→contexte→questions→risk→guidance | rapport local optionnel | partiel | consentement inactif/transmission absente |
| Actor | assessment général | vulnérabilité→orientation | ressource | partiel | pas de parcours distinct |
| Witness | aucun | aucun | aucun | non | module absent |
| Professional | login pending | demandes→acceptation→patient/chat | Hive | partiel | vérification/RBAC serveur absents |
| Partner | aucun | aucun | aucun | non | modèle seul |
| Admin | login | dashboard/gestion locale | Hive | partiel | pouvoirs non sécurisés |

## Matrice des données sensibles

| Donnée | Source | Stockage | Transmission | Qui peut voir | Consentement | Risque |
|---|---|---|---|---|---|---|
| réponses/résultats | assessment | Hive AES | aucune | user/local pro relation UI/admin appareil | absent/partiel | HIGH |
| violence report | protection | Hive AES maps | aucune | appareil/local filtre user | formulaire, pas exécutoire | CRITICAL |
| légal/consent/draft | legal | Hive AES | aucune | appareil/admin possible | local seulement | CRITICAL |
| messages | chat | Hive AES | aucune | UI relation/admin | relation, pas consent granulaire | HIGH |
| wilaya/location approx. | profil/report | Hive AES | aucune | appareil | non détaillé | MEDIUM |
| agrégats awareness | non produit | n/a | n/a | n/a | n/a | MISSING |

## Matrice juridique

| Fonction | Code | Source juridique | Version | Validation nécessaire | Risque |
|---|---|---|---|---|---|
| qualification indicative | LegalOrientationEngine | catégories/articles Hive | locale `v2026.1-DZ-OFFICIAL` | juriste/source officielle | HIGH |
| procédures/contacts | LegalProcedure/repository | chaînes locales | locale | institutions compétentes | HIGH |
| rapport légal | ReportDraft/Hive | aucune transmission | n/a | légal + technique | CRITICAL |

## Matrice des risques

| ID | Niveau | Fichier:ligne | Problème | Impact | Cause | Correction |
|---|---|---|---|---|---|---|
| R-01 | CRITICAL | `sync_queue_service.dart:194-199` | sync fictive | faux sentiment de transmission | stub renvoie true | API/ack ou désactiver |
| R-02 | CRITICAL | `hive_professional_repository.dart:121-138` | ACL sans acteur | accès/manipulation locale | absence RBAC serveur | authorization backend |
| R-03 | CRITICAL | `assessment_provider.dart:80-92` | safety non dirigée | risque immédiat mal géré | UI non raccordée | flow urgence sûr |
| R-04 | CRITICAL | `scoring_engine.dart:26,36` | analyse en erreur | build non prêt | symbole manquant | correction/test |
| R-05 | HIGH | `api_client.dart:14` | HTTP | confidentialité transport | URL hard-coded | HTTPS/auth/pinning selon besoin |
| R-06 | HIGH | `violence_understanding_flow_page.dart:26` | consent non effectif | collecte sans mécanisme | champ inutilisé | consent state réel |
| R-07 | HIGH | `partner_matching_engine.dart:16-77` | matching isolé/sans distance | orientation non réelle | modèles sans données | repository+GPS/validation |

## Scores

| Axe | /10 |
|---|---:|
| Architecture | 3 |
| Fonctionnalités | 4 |
| Psychologie | 3 |
| Violence | 4 |
| Victime | 3 |
| Safety | 2 |
| Orientation | 3 |
| Matching | 2 |
| Réseau national | 1 |
| Partenaires | 1 |
| Prévention | 4 |
| Sensibilisation | 3 |
| Juridique | 3 |
| Signalement | 1 |
| Consentement | 2 |
| Security | 2 |
| Privacy | 3 |
| Offline | 6 |
| Backend | 0 |
| UX/UI | 5 |
| Tests | 3 |
| Production readiness | 1 |
| **GLOBAL SCORE** | **3,4 / 10** |
