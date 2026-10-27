# 1. Executive Summary

**Verdict : CONTROLLED PROTOTYPE — score global 3.9/10.** L'application démarre, analyse et les 36 tests actuels passent, mais elle ne peut pas être distribuée comme produit de santé réel. L'état actuel est un pilote local chiffré, avec des données de démonstration ; ni le backend annoncé, ni la synchronisation, ni un contrôle d'accès indépendant du client ne sont implémentés.

Principales preuves : le `main` force l'environnement de développement ([lib/main.dart:19](lib/main.dart#L19)); tous les providers de données injectent Hive ([lib/core/providers/unified_data_providers.dart:44-65](lib/core/providers/unified_data_providers.dart#L44-L65)); le sync renvoie toujours `true` sans HTTP ([lib/core/data/sync/sync_queue_service.dart:194-199](lib/core/data/sync/sync_queue_service.dart#L194-L199)); et le README annonce Supabase alors que les fichiers Supabase sont supprimés ([README.md:64](README.md#L64), état Git observé).

| Mesure | Valeur |
|---|---:|
| Fichiers Dart analysés (`lib` + `test`) | 285 |
| Lignes Dart analysées | 54 423 |
| Routes GoRouter déclarées | 70 |
| Providers Riverpod déclarés | 77 |
| Classes Service/Repository | 39 |
| Classes/modèles Hive | 44 |
| Questions du questionnaire courant | 40 |
| Tests analysés | 9 fichiers, 36 tests passants |

# 2. État réel du projet

Application Flutter/Riverpod réellement **locale**, utilisant Hive chiffré avec une clé dans `flutter_secure_storage` ([lib/core/data/hive_config.dart:139-251](lib/core/data/hive_config.dart#L139-L251)). Les rôles, l'historique, le chat, l'annuaire et l'administration partagent cette base sur l'appareil. Les écrans existent majoritairement, mais plusieurs fonctions exposent des données de démonstration ou ne protègent que l'interface.

# 3. Architecture

Architecture **Feature-First partielle**, pas Clean Architecture cohérente. `adaptive_assessment` a `data/domain/presentation`; `legal` et `protection` ont un découpage semblable. Les autres features mélangent widgets, providers, Hive et logique métier. `core/engines` duplique les engines de `features/adaptive_assessment/domain/engines`; le flux vivant utilise ceux de la feature ([assessment_provider.dart:3-12](lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart#L3-L12)), pas les providers core.

```
adaptive_assessment
 ├── Presentation: page/provider/widget
 ├── Domain: questions, session, engines
 └── Data: banque statique + repository Hive
professional
 ├── Presentation: screens/provider
 └── Data: HiveProfessionalRepository dans core
admin
 ├── Presentation: screens/provider
 └── Data: HiveAdminRepository dans core
```

Constats : provider `AssessmentNotifier` construit directement engines/repository (pas d'injection); UI chat lit Hive directement ([chat_page.dart:33,60,96](lib/features/messaging/chat_page.dart#L33)); providers health/team/progress accèdent aussi directement à Hive. **Note architecture : 4/10.**

# 4. Arborescence analysée

Analysés : `lib/` (core, 20+ features, l10n/generated), `test/`, assets, Android/iOS/web/windows, `pubspec.yaml/.lock`, README et `docs/`. Il n'existe pas de `integration_test/` ni de backend présent : le dossier `backend/` figure supprimé dans l'état Git observé. Le worktree est déjà très sale (nombreuses suppressions/modifications non attribuables à cet audit) ; aucune de ces sources n'a été modifiée.

# 5. Toutes les fonctionnalités

Fonctions vivantes : onboarding, guest local, inscription/login local, questionnaire, résultat, Hive history, recherche locale de professionnels, demande/acceptation, chat local, admin local, protection/légal locaux. Fonctions non réelles : synchronisation, notifications push/locales, backend/API, PDF clinique, téléconsultation, suppression/consultation détaillée de l'historique, consentement professionnel révocable.

# 6. Toutes les routes

Source unique : [lib/core/navigation/app_router.dart](lib/core/navigation/app_router.dart). 70 `GoRoute` sont déclarées. Les routes publiques comprennent aussi `/history`, `/results`, `/professional-search`, `/communications` et `/my-appointments` ([lignes 96-151](lib/core/navigation/app_router.dart#L96-L151)) : elles ne sont donc pas protégées avant que leur UI décide quoi afficher.

# 7. Authentification

**PARTIAL / INSECURE.** Login, logout et persistance fonctionnent localement : `HiveAuthRepository.login` lit l'utilisateur Hive et compare un hash dans secure storage ([auth_repository_impl.dart:94-188](lib/core/services/auth_repository_impl.dart#L94-L188)); logout efface `current_user` ([lignes 244-260](lib/core/services/auth_repository_impl.dart#L244-L260)). L'inscription autorise user et psychologist, jamais admin ([lignes 196-204](lib/core/services/auth_repository_impl.dart#L196-L204)); le psychologue devient `pending`.

Absences : backend, token, expiration, refresh, vérification email réelle, récupération de mot de passe. `verifyEmail` rend localement le compte actif sans preuve ([lignes 417-433](lib/core/services/auth_repository_impl.dart#L417-L433)). L'app démarre en `Environment.dev`, donc logs complets ([main.dart:19](lib/main.dart#L19), [app_config.dart:24-39](lib/core/config/app_config.dart#L24-L39)).

# 8. Rôles et permissions

Le redirect GoRouter bloque `/admin*`, `/psychologist*`, `/user` et `/session-request` selon rôle ([app_router.dart:155-174](lib/core/navigation/app_router.dart#L155-L174)). Les permissions déclarées dans `RolePermissions` ne sont jamais consultées par le routeur ni les repositories ([role_permissions.dart:3-51](lib/core/auth/role_permissions.dart#L3-L51)). Les repositories ne reçoivent pas l'acteur pour les opérations admin/acceptation : un client compromis peut écrire Hive.

# 9. Guest

**PARTIAL.** Guest sans `UserModel` peut parcourir `/guest → /assessment`; la page attribue littéralement `"guest"` comme `userId` ([assessment_page.dart:27-33](lib/features/adaptive_assessment/presentation/pages/assessment_page.dart#L27-L33)). L'historique guest se filtre bien par ce marqueur ([hive_assessment_repository.dart:18-26](lib/core/services/hive_assessment_repository.dart#L18-L26)). Mais la migration `migrateGuestData` existe sans appel depuis register/login ([auth_repository_impl.dart:436-440](lib/core/services/auth_repository_impl.dart#L436-L440)), et migre **tous** les enregistrements guest de l'appareil ([hive_assessment_repository.dart:29-45](lib/core/services/hive_assessment_repository.dart#L29-L45)); elle n'est ni reliée à une identité ni confirmée.

# 10. User

`UserModel` contient id, email, rôle, statut, dates, wilaya, préférence spirituelle, état assessment, nom, MFA et mot de passe temporaire ([user_model.dart:7-129](lib/core/models/user_model.dart#L7-L129)). Il ne contient ni consentements, historique relationnel, préférences complètes ni profil clinique. `wilaya` s'écrit depuis la page dédiée ([wilaya_selection_screen.dart:60-67](lib/features/dashboard/wilaya_selection_screen.dart#L60-L67)); nom/préférence ne disposent pas d'éditeur utilisateur complet.

# 11. Psychologist

**PARTIAL.** Inscription pending et route pending sont présentes. Après acceptation, les patients sont filtrés par `AccessRequest.accepted` ([hive_professional_repository.dart:141-190](lib/core/services/hive_professional_repository.dart#L141-L190)). Toutefois l'acceptation ne vérifie pas que l'appelant est le psychologue propriétaire ([lignes 121-138](lib/core/services/hive_professional_repository.dart#L121-L138)); pas de validation d'identité/titre; suivi et "téléconsultation" redirigent simplement vers chat ([patient_detail_screen.dart:204-249](lib/features/professional/screens/patient_detail_screen.dart#L204-L249)).

# 12. Admin

**PARTIAL / INSECURE.** Dashboard stats réelles seulement pour la base locale ([hive_admin_repository.dart:44-78](lib/core/services/admin/hive_admin_repository.dart#L44-L78)); gestion utilisateurs/professionnels et logs Hive sont accessibles via guard. Pas de PDF export. `HiveAdminRepository.update*Status` ne vérifie aucun admin ([lignes 101-134](lib/core/services/admin/hive_admin_repository.dart#L101-L134)). L'éditeur de questions écrit un `questions_box` non chiffré/non configuré avec des objets sans adapter, et l'engine lit toujours `QuestionBank.questions` : **BROKEN/INACCESSIBLE** ([lignes 17-41](lib/core/services/admin/hive_admin_repository.dart#L17-L41), [adaptive_question_engine.dart:52](lib/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart#L52)).

# 13. Assessment Engine

Call graph réel : `AssessmentPage → AssessmentNotifier.startSession/answerQuestion → Adaptive/Safety/Scoring/Orientation/Recommendation engines → AssessmentRepository → HiveAssessmentRepository → assessments`. Preuve [assessment_provider.dart:43-187](lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart#L43-L187). Le résultat n'est conservé en mémoire que pour la page courante; le record Hive conserve réponses et booléen urgent, mais pas axes/orientation/recommandations/traces ([assessment_record.dart:7-41](lib/features/assessment/assessment_record.dart#L7-L41)). Abandon, reprise de draft et progression restaurée : **NOT IMPLEMENTED**.

# 14. AdaptiveQuestionEngine

**PARTIAL.** Adaptation réelle par priorité, score, contexte, règles et pénalité de diversité ([adaptive_question_engine.dart:52-115](lib/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart#L52-L115)); pas de répétition grâce à `questionIds`. Les deux gates safety `Q451/Q452` sont obligatoires avant le reste ([lignes 24-30](lib/features/adaptive_assessment/domain/engines/adaptive_question_engine.dart#L24-L30)).

Défauts : `QuestionCondition`, `QuestionRule`, champs `conditions`/`rules` sont déclarés mais aucun moteur ne les évalue ([assessment_question.dart:22-46,85-88](lib/features/adaptive_assessment/domain/models/assessment_question.dart#L22-L46)); les 5 `NextQuestionRule` ne sont que des boosts, pas des branches garanties. `PriorityEngine` additionne la priorité historique à chaque question, gonflant les scores sans borne ([priority_engine.dart:11-43](lib/features/adaptive_assessment/domain/engines/priority_engine.dart#L11-L43)). UI affiche 15 étapes alors que l'arrêt est à 8–25 ([assessment_page.dart:80-96](lib/features/adaptive_assessment/presentation/pages/assessment_page.dart#L80-L96), [completion_engine.dart:5-29](lib/features/adaptive_assessment/domain/engines/completion_engine.dart#L5-L29)).

# 15. Question Bank

40 questions actives, 12 axes utilisés : emotions 5, stress 5, sleep 3, productivity 6, social 2, anger 2, confidence 4, pressures 2, lifestyle 4, safety 3, general 3, environmental 1. Les dimensions demandées General/Stress/Sleep/Social/Economic/Relational/Safety ne correspondent pas à l'enum : `economic`, `relationship`, `social`, `stress`, `sleep` existent mais ne sont pas alimentés ([assessment_axis.dart:1-27](lib/features/adaptive_assessment/domain/models/assessment_axis.dart#L1-L27)). Q453 est techniquement sélectionnable mais, après réponse urgente Q452, le provider termine immédiatement avant sa question ([assessment_provider.dart:80-92](lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart#L80-L92)); la règle Q452→Q453 est donc inatteignable pour ses valeurs critiques.

# 16. ScoringEngine

**IMPLEMENTED, validation clinique insuffisante.** Normalisation par réponse réellement donnée et protection via `ScoreDirection` ([scoring_engine.dart:5-63](lib/features/adaptive_assessment/domain/engines/scoring_engine.dart#L5-L63)); division zéro évitée. Cas : (1) aucun score→tous 0; (2) contextes non notés→0; (3) toutes réponses 0→0; (4) toutes 4→1 pour axes sollicités; (5) réponse inversée Q002=4→0; (6) Q002=0→1; (7) cross-weight alimente stress/sommeil; (8) null ignoré; (9) axe jamais questionné→0 indiscernable de "faible besoin"; (10) Q451 safety high est non scorée par max=4 mais safety override. Les scores ne sont pas persistés et aucun test de bornes/ensemble des 40 questions n'existe.

# 17. Safety Layer

**BROKEN — CRITICAL.** `SafetyEngine` détecte bien un trigger ([safety_engine.dart:22-93](lib/features/adaptive_assessment/domain/engines/safety_engine.dart#L22-L93)) et `OrientationEngine` lui donne priorité ([orientation_engine.dart:12-19](lib/features/adaptive_assessment/domain/engines/orientation_engine.dart#L12-L19)). Mais le provider n'affiche jamais `SafetyDecision` ni son message; il fixe `isSafetyAlert` puis rend la page résultat normale ([assessment_provider.dart:86-88](lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart#L86-L88)). Q451 ("pas en sécurité") est classée `high` et devient `urgentSupport` immédiatement ([question_bank.dart:506-522](lib/features/adaptive_assessment/data/question_bank.dart#L506-L522)), sans écran d'urgence ni contacts dédiés. Le disclaimer non-diagnostic existe en résultat ([results_page.dart:612-616](lib/features/adaptive_assessment/presentation/pages/results_page.dart#L612-L616)), mais il est insuffisant pour ce parcours.

# 18. DecisionEngine

L'application principale utilise `OrientationEngine`, pas le `DecisionEngine` core. Les règles effectives : urgent→L4, deux moyens→L3, max≥.85/deux axes≥.7→L3, max≥.55/un axe≥.7/3 moyens→L2, max≥.25→L1, sinon L0 ([orientation_engine.dart:8-49](lib/features/adaptive_assessment/domain/engines/orientation_engine.dart#L8-L49)). Les engines core sont une implémentation concurrente non reliée : **IMPLEMENTED BUT UNUSED**.

# 19. EngineTrace

**IMPLEMENTED BUT UNUSED.** Des traces détaillées sont créées en mémoire ([assessment_provider.dart:113-133](lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart#L113-L133)) mais ne sont ni persistées, ni affichées, ni jointes à `AssessmentResult`. Il existe de plus un autre `EngineTrace` Hive dans `core/models`, ce qui accroît la confusion.

# 20. Recommendation Engine

**PARTIAL.** Il sélectionne la recommandation statique de priorité maximale pour chaque axe ≥ .2 ([recommendation_engine.dart:5-32](lib/features/adaptive_assessment/domain/engines/recommendation_engine.dart#L5-L32)). Il ignore wilaya, consentement, disponibilité, sécurité, profil pro et les `recommendationIds` ne sont pas affichés par `ResultsPage`. Les vidéos, plan et contenu spirituel sont d'autres listes statiques.

# 21. Resources

`ResourcesScreen` filtre `mockResources` et `mockProfessionals` ([resources_screen.dart:92,234](lib/features/resources/screens/resources_screen.dart#L92)); **MOCK HIDING MISSING FEATURE**. Pas de recherche de ressources réelles, géolocalisation, source, disponibilité ou validation clinique.

# 22. Quran / Hadith / Hikam

122 versets, 40 hadiths, 25 hikam dans bibliothèques statiques; hadiths ont un test d'identifiants. `SpiritualSupportEngine` sélectionne par axes et mélange aléatoirement ([spiritual_support_engine.dart:11-52](lib/features/adaptive_assessment/domain/engines/spiritual_support_engine.dart#L11-L52)). Seul le premier est affiché, avec arabe/référence, pas traduction française ([results_page.dart:448-484](lib/features/adaptive_assessment/presentation/pages/results_page.dart#L448-L484)). Aucun statut de validation fiable de chaque source; ne pas présenter comme soin/diagnostic.

# 23. Wilaya / Orientation géographique

Les 58 wilayas sont listées exactement 01–58 ([wilaya_data.dart:3-77](lib/core/data/wilaya_data.dart#L3-L77)) et stockées au format `wNN`. La recherche professionnelle compare un entier, reconstruit depuis les comptes seed, et génère un centre fictif par wilaya ([professional_provider.dart:121-162](lib/features/professional/professional_provider.dart#L121-L162)). Wilaya est donc **PARTIAL** : filtre pro local, centres MOCK, aucune orientation moteur liée au résultat.

# 24. Psychologists / Centres

L'annuaire est dérivé de 232 comptes seed et profils Hive approved ([database_seed_service.dart:138-217](lib/core/data/database_seed_service.dart#L138-L217), [hive_professional_repository.dart:26-62](lib/core/services/hive_professional_repository.dart#L26-L62)). Ces identités, téléphones et disponibilités ne sont pas prouvés ni synchronisés. Les centres sont construits à la volée et inventés : **MOCK**.

# 25. Consentement

Deux systèmes incompatibles : `AccessRequest.accepted` pour le professionnel et `ConsentRecord` légal. La page session ne sauvegarde qu'un booléen `consentGiven` dans `SessionRequestModel` ([session_request_page.dart:206-228](lib/features/professional/screens/session_request_page.dart#L206-L228)); aucune portée, version, expiration ou révocation applicable. Le consentement légal est local/dynamique Hive, mais n'autorise pas les données cliniques professionnelles ([legal_repository.dart:213-240](lib/features/legal/data/repositories/legal_repository.dart#L213-L240)).

# 26. AccessRequest

Création, liste et status existent Hive. Acceptation ouvre l'accès aux patients et chat; revoked existe dans enum mais aucune UI/action user ne l'écrit. La méthode de réponse ne lie pas l'acteur au `professionalId` : **INSECURE** ([hive_professional_repository.dart:121-138](lib/core/services/hive_professional_repository.dart#L121-L138)).

# 27. Chat

**PARTIAL.** `ChatPage` vérifie l'acceptation avant envoi ([chat_page.dart:52-92](lib/features/messaging/chat_page.dart#L52-L92)) et stocke messages chiffrés. Cependant la lecture du conversation stream est faite avant toute couche serveur et l'admin a un bypass total ([lignes 43-77](lib/features/messaging/chat_page.dart#L43-L77)); aucun audit, signalement, suppression, chiffrement de bout en bout, push, rate limit ou serveur. Deux modèles/repositories de chat coexistent (`ChatMessage` et `MessageModel`).

# 28. Notifications

`NotificationModel` et box existent, mais aucun service, trigger, consumer UI, Firebase ou local-notification n'est trouvé. **NOT IMPLEMENTED.**

# 29. History

**PARTIAL.** création/sauvegarde/liste triée par propriétaire existent ([hive_assessment_repository.dart:11-26](lib/core/services/hive_assessment_repository.dart#L11-L26), [history_page.dart:9-80](lib/features/dashboard/history_page.dart#L9-L80)). Pas de détail, suppression, filtre, pagination ou export. User A ne peut pas obtenir User B via `HistoryPage`, mais l'isolation n'est pas résistante à l'accès au stockage local (pas de serveur).

# 30. Offline-First

| Étape sans Internet | État | Preuve |
|---|---|---|
| Guest / assessment / score / résultat / history | WORKS OFFLINE | parcours Hive + banques Dart |
| Login local préalablement seedé | WORKS OFFLINE | `HiveAuthRepository` |
| Register / demandes / chat local | PARTIAL | local seulement, pas partage multi-appareil |
| orientation pro réelle / notifications / backend | FAILS | absents |

# 31. Hive

Les boîtes sensibles essentielles sont ouvertes avec `HiveAesCipher`; de nombreuses boîtes `dynamic` empêchent validation/migration de schéma ([hive_config.dart:139-234](lib/core/data/hive_config.dart#L139-L234)). `questions_box` et `chat_messages` sont ouverts hors configuration; le second adapter est enregistré, pas le premier. Migrations V3/V4 sont vides ([database_migration_service.dart:74-86](lib/core/data/migration/database_migration_service.dart#L74-L86)).

# 32. Synchronisation

**MOCK.** Une queue, retry et conflict resolver sont codés, mais `_executeRemoteSync` attend 100ms et retourne toujours `true`, puis l'item est supprimé ([sync_queue_service.dart:139-199](lib/core/data/sync/sync_queue_service.dart#L139-L199)). Aucun repository du flux assessment/auth/professional ne l'enqueue, hors migration/protection. Cela ne doit jamais être présenté comme synchronisation.

# 33. Backend / API

**BACKEND NOT IMPLEMENTED.** `RemoteDataSource` ne contient que des interfaces ([remote_data_source.dart:1-22](lib/core/data/remote_data_source.dart#L1-L22)). `ApiClient` non consommé pointe en plus vers une URL HTTP claire, sans Authorization, token ni validation robuste ([api_client.dart:9-58](lib/core/api/api_client.dart#L9-L58)). Aucun endpoint actif, migration ou règles d'autorisation serveur à auditer.

# 34. Services

| Service | Responsabilité / état |
|---|---|
| HiveAuthRepository/HybridAuthService | auth locale, réel local |
| HiveAssessmentRepository | records Hive, réel local |
| HiveProfessionalRepository | annuaire/demandes local, partiel |
| HiveMessageRepository/ChatRepository | deux chats locaux, dupliqué |
| HiveAdminRepository/Content/Logs | administration Hive, partiel |
| SyncQueueService | MOCK |
| ApiClient/RemoteDataSource | DECLARED/non appelé |
| SecureStorageService | réel pour hashes/clé |
| WhatsApp/Location | intégrations locales/non vérifiées |

# 35. Repositories

Les abstractions existent mais ne garantissent pas les politiques : `AuthRepository`, `AssessmentRepository`, `ProfessionalRepository`, `AdminRepository`, `SecurityLogRepository`, `ProtectionRepository`. Le provider bind directement les implémentations Hive ([unified_data_providers.dart:44-65](lib/core/providers/unified_data_providers.dart#L44-L65)); aucune implémentation remote active ni transaction atomique multi-boîtes.

# 36. Riverpod Providers

77 providers déclarés. États utiles : auth, assessment, professional, admin, history, legal, protection. Problèmes : `latestResultProvider` ne charge jamais le repository ([assessment_provider.dart:198-203](lib/features/adaptive_assessment/presentation/providers/assessment_provider.dart#L198-L203)); nombreux providers core engines sont non consommés; ChangeNotifier et StateNotifier coexistent; Hive est appelé directement depuis providers/features. Loading/error sont présents seulement de façon inégale.

# 37. Data Models

Modèles réellement stockés : User, AssessmentRecord, AccessRequest, ProfessionalProfile, SessionRequest, MessageModel, SecurityLog, contenu/progression. Modèles déclarés sans flux complet : Notification, PatientPsychologistRelation, Appointment, ConsentRecord (professionnel), Referral/Report, core assessment models, plusieurs protection/legal. `AssessmentRecord` ne sérialise pas le résultat calculé, seulement réponses et `safetyAnswers` ([assessment_record.dart:7-35](lib/features/assessment/assessment_record.dart#L7-L35)).

# 38. Relations entre entités

| Source | Relation | Destination | Cardinalité | Autorisation | Implémentée | Problème |
|---|---|---|---|---|---|---|
| User | possède | AssessmentRecord | 1-N via `userId` | filtre local | Oui | pas serveur |
| User | demande | Professional | N-N via AccessRequest | UI+route | Partiel | réponse sans acteur |
| Professional | lit | User/records | N-N accepted | repository | Oui local | révocation UI absente |
| User/Professional | échange | Message | N-N ids | UI check | Partiel | admin bypass/local only |
| User | choisit | Wilaya | N-1 | self UI | Oui | non utilisée par moteur |
| User | donne | ConsentRecord légal | 1-N | local | Partiel | non relié au partage |

# 39. Localization FR/AR

873/874 clés ARB, delegates et locales FR/AR sont configurés ([main.dart:36-46](lib/main.dart#L36-L46)). **PARTIAL** : beaucoup de textes FR codés dans router/admin/legal/professional/results; ex. routes d'erreur ([app_router.dart:567-617](lib/core/navigation/app_router.dart#L567-L617)) et nombreux écrans admin. Les données locales et erreurs ne sont pas localisées intégralement.

# 40. RTL

Le changement locale fonctionne et plusieurs pages lisent `Directionality`, mais ce n'est pas systématique (rows, paddings `left`, texte hardcodé, formulaires admin). **PARTIAL**, pas de test RTL/overflow.

# 41. UI/UX

Pages majeures ont généralement loading/empty/error (history, listes pro/admin). Écarts : assessment affiche un loader indéfini si l'engine échoue; résultats ne montrent pas les recommandations stockées ni safety dédiée; history sans détail/action; teleconsult est chat; cards et formulaires admin ont des messages non localisés. Aucun test widget/E2E visuel.

# 42. Design System

Tokens couleur/spacing/typo, composants Sind et thème existent. Usage inégal : nombreux `Colors.*`, tailles/marges magiques, `ElevatedButton` directs et composants duplicatifs. **Note 5/10.**

# 43. Error Handling

Global handler logge mais ne remonte pas vers monitoring ([error_handler.dart:4-24](lib/core/error/error_handler.dart#L4-L24)). Beaucoup de FutureProvider affichent un texte; plusieurs `catch (_) {}` cachent les erreurs (sync). Les erreurs peuvent contenir exception brute dans SnackBar. Pas de stratégie réseau réelle.

# 44. Loading / Empty / Error States

Assessment : loading oui, empty/error non. History/professionnels/admin/chat : états principaux oui, parfois message simple. Recherche ressources/centres : pas de source distante donc état d'erreur non représentatif. Consentement/legal et dashboards sont inégaux. **PARTIAL.**

# 45. Security Audit

| ID | Gravité | Preuve | Impact |
|---|---|---|---|
| SEC-01 | CRITICAL | `database_seed_service.dart:154-191,263-328` | SECRET FOUND — mot de passe de démonstration partagé, comptes admin/professionnels seedés et approuvés |
| SEC-02 | CRITICAL | `sync_queue_service.dart:194-199` | faux succès puis suppression de données à synchroniser |
| SEC-03 | HIGH | repositories Hive sans acteur | RBAC non imposé hors UI/client |
| SEC-04 | HIGH | `main.dart:19`, logs auth | build forcé dev et logs comportant identifiants/email |
| SEC-05 | HIGH | `api_client.dart:14` | HTTP clair, aucun Auth header; même inactif est dangereux si raccordé |
| SEC-06 | MEDIUM | `hive_admin_repository.dart:17-41` | boîte questions hors config/chiffrement et inutilisée |
| SEC-07 | MEDIUM | `auth_repository_impl.dart:417-433` | activation email locale sans vérification |

Les credentials ne sont pas reproduits dans ce rapport. Rotation/retrait immédiat requis avant tout partage du build.

# 46. Privacy Audit

| Donnée | Collection/stockage | Accès | Suppression | État |
|---|---|---|---|---|
| email, rôle, wilaya | UserModel Hive chiffré | tout code local/admin | delete account | local seulement |
| réponses/safety/message libre | AssessmentRecord Hive chiffré | owner/pro accepté | delete account, pas UI record | sensible |
| messages | messages Hive chiffré | participants/admin bypass | delete account | pas de rétention |
| demandes/consentement légal | Hive | local | non complet | consentement non relié |
| logs | Hive | admin UI | suppression refusée | IDs/metadata exposés |

Pas de politique de rétention, export, droit à l'effacement complet, base légale serveur ni partage auditable. `deleteCurrentUserData` oublie plusieurs boîtes (legal/protection/content progress) et compare une relation avec `hashCode` ([auth_repository_impl.dart:445-498](lib/core/services/auth_repository_impl.dart#L445-L498)).

# 47. Performance

Banques statiques raisonnables, ListView souvent builder. Risques : seed de 232 profils au lancement; ouverture de nombreuses boîtes; `firstWhere` répétés par question/answer; `results.shuffle()` donne résultats instables; no pagination pour logs/messages/history; rebuilds/futures sans cache. **4/10.**

# 48. Accessibility

Icons et couleurs parfois sans semantic labels, contraste glassmorphism non vérifié, touch targets custom non audités, erreurs principalement textuelles. RTL partiel. Aucune suite a11y. **3/10.**

# 49. Tests

`flutter test --reporter compact` : **36 tests passants**. Tests unitaires couvrent engines protection/legal, safety, auth seed/login, chat serialization, migration Hive. Manquent : widget/UI, routes/guards, RBAC hostile, admin, consent revoke, E2E 4 rôles, persistence de résultats, notification, backend, a11y, localisation, performance. Les tests core engines peuvent valider l'autre engine que le flux assessment réel.

Matrice Decision/Assessment à ajouter : normal faible; faible; élevé; seuil .25/.4/.55/.7/.85; réponses null; toutes identiques; Q451; Q452=1/2/3/4; red flags multiples; Guest/User; Q452→Q453; enregistrement/history; orientation safety affichée.

# 50. Fonctionnalités fantômes

| Annonce | Code réel | Fonctionne | Réel/Mock |
|---|---|---|---|
| Supabase auth/sync (README) | fichiers supprimés/interfaces | Non | DECLARED |
| Sync offline | queue succès simulé | Non | MOCK |
| 58 wilayas/centres | list + centre généré | Partiel | MOCK centres |
| questionnaire adaptatif | priorités réelles | Partiel | réel local |
| chat professionnel sécurisé | Hive + contrôle UI | Partiel | local |
| téléconsultation | bouton ouvre chat | Non | BROKEN |
| notifications | modèle/box | Non | DECLARED |
| PDF export | dépendances seulement | Non | NOT IMPLEMENTED |

# 51. Mocks

`mockResources`, `mockProfessionals`, centres générés, `MockAdminService`, `MockSecurityLogService`, SyncQueue fake, contenus/demo accounts. Classification : données de prototype nécessaires pour maquette; centres/sync/directory comme **MOCK HIDING MISSING FEATURE**; comptes professionnels approuvés avec secret partagé comme **MOCK USED AS PRODUCTION LOGIC**.

# 52. Bugs

Voir matrice section 60. Bugs centraux : safety non affichée, Q453 inaccessible critique, migration guest non appelée/globalisée, IDs de rendez-vous via `hashCode`, historique pauvre, question admin non branchée, centres fictifs, sync mensongère.

# 53. Fonctionnalités manquantes

Backend sécurisé, auth serveur/token/reset/verify, true RBAC/ownership serveur, sync réelle, consentement professionnel révocable, notifications, PDF, détail/suppression history, reprise assessment, profil complet, annuaire/centres validés, sessions réelles, monitoring, E2E/a11y.

# 54. Matrice des permissions

| Fonctionnalité | Guest | User | Psychologist | Admin | Preuve / état |
|---|---|---|---|---|---|
| Assessment | ALLOW | ALLOW | ALLOW | ALLOW | public route |
| History | PARTIAL | ALLOW own | PARTIAL public route | PARTIAL public route | filtre UI/Hive |
| Profile | DENY route | ALLOW | ALLOW | ALLOW | shared `/profile` |
| Directory | ALLOW | ALLOW | ALLOW | ALLOW | public |
| Access request | DENY | ALLOW | DENY | DENY | `/session-request` user-only |
| Chat | DENY | PARTIAL accepted | PARTIAL accepted | ALLOW all | code chat |
| User management | DENY | DENY | DENY | ALLOW route only | no service actor check |
| Professional approval | DENY | DENY | DENY | ALLOW route only | no service actor check |
| Security logs | DENY | DENY | DENY | ALLOW route | local logs |
| PDF export | DENY | DENY | DENY | DENY | NOT IMPLEMENTED |

# 55. Matrice des routes

| Route(s) | Page/rôle | Guard réel | État |
|---|---|---|---|
| `/splash`, `/`, `/login`, `/register` | onboarding/auth | public; reconnect redirect | IMPLEMENTED local |
| `/guest`, `/guest/intro`, `/orientation` | guest | public | PARTIAL |
| `/assessment`, `/results` | assessment | public | PARTIAL; `/results` sans state→erreur |
| `/history`, `/resources`, `/professional-search`, `/professional-profile`, `/communications`, `/my-appointments` | history/resources/chat | public | PARTIAL/risque direct link |
| `/breathing`, `/spiritual`, `/plan7days`, `/confidence`, `/safety`, `/privacy`, `/progress`, `/analytics`, `/reflection`, `/health[/article/:id,/quiz/:id]`, `/team` | wellbeing/content | public | IMPLEMENTED/PARTIAL |
| `/protection`, `/flow`, `/emergency`, `/privacy`, `/report`, `/result`, `/resources`, `/breathing`, `/scenarios`, `/reports`, `/safety-plan`, `/voice` | protection | public | PARTIAL; voice simulated |
| `/legal`, `/questionnaire`, `/result`, `/consent`, `/report-builder` | legal | public | PARTIAL |
| `/user`, `/profile`, `/wilaya`, `/settings` | user | `/user` user-only; other shared | PARTIAL |
| `/session-request` | request | user-only + requires `extra` | IMPLEMENTED/PARTIAL |
| `/psychologist`, `/pending`, `/requests`, `/patients/:id` | psychologist | role + approved/pending redirect | PARTIAL |
| `/admin`, `/professionals`, `/users`, `/security-logs`, `/settings`, `/institutional-readiness`, `/health`, `/team`, `/quran`, `/hadith`, `/assessment`, `/awareness`, `/chat`, `/legal` | admin | role guard | PARTIAL |
| `/account-disabled` | suspended | status redirect | IMPLEMENTED |

# 56. Matrice des fonctionnalités

| ID | Domaine | Fonctionnalité | Statut | Route | Service/modèle | Tests | Gravité |
|---|---|---|---|---|---|---|---|
| F01 | Auth | login/logout local | IMPLEMENTED | login | HiveAuth/User | oui | MEDIUM |
| F02 | Auth | reset/verify/session refresh | NOT IMPLEMENTED | profile | local only | non | HIGH |
| F03 | RBAC | router role guard | PARTIAL | router | GoRouter | non | HIGH |
| F04 | Guest | assessment anonymous | PARTIAL | guest/assessment | Hive record | non | HIGH |
| F05 | Assessment | adaptive questions | PARTIAL | assessment | engines | partiel | HIGH |
| F06 | Safety | emergency escalation UI | BROKEN | assessment | SafetyEngine | unit only | CRITICAL |
| F07 | Result | score/orientation | IMPLEMENTED | results | engines | unit | MEDIUM |
| F08 | Explain | EngineTrace | INACCESSIBLE | none | memory only | non | MEDIUM |
| F09 | Recommendation | static recommendations | PARTIAL | results | bank | non | MEDIUM |
| F10 | History | list own Hive | PARTIAL | history | Hive | non | MEDIUM |
| F11 | Wilaya | 58 list/filter | PARTIAL | wilaya/search | static/seed | non | MEDIUM |
| F12 | Centres | geographic centres | MOCK | search | generated | non | HIGH |
| F13 | Professional | request/authorized patients | PARTIAL | psychologist | Hive | non | HIGH |
| F14 | Consent | request checkbox/legal record | PARTIAL | session/legal | Hive | unit legal | HIGH |
| F15 | Chat | local messages | PARTIAL | communications | Hive | serialization | HIGH |
| F16 | Notifications | model/box | NOT IMPLEMENTED | none | model only | non | HIGH |
| F17 | Admin | stats/manage accounts | PARTIAL | admin | Hive | non | HIGH |
| F18 | Admin | security logs | PARTIAL | security-logs | Hive | non | MEDIUM |
| F19 | Admin | question editing | BROKEN | admin/assessment | unused box | non | HIGH |
| F20 | Offline | encrypted local storage | IMPLEMENTED | n/a | Hive | migration | MEDIUM |
| F21 | Sync | cloud synchronization | MOCK | n/a | fake queue | misleading unit | CRITICAL |
| F22 | Backend | API/server authorization | NOT IMPLEMENTED | n/a | interfaces only | non | CRITICAL |
| F23 | Content | Quran/Hadith/Hikam | PARTIAL | results/admin | static | hadith | MEDIUM |
| F24 | Localization | FR/AR + RTL | PARTIAL | global | ARB | non | MEDIUM |
| F25 | PDF | export | NOT IMPLEMENTED | none | package only | non | HIGH |

# 57. Parcours End-to-End

| Parcours | État | Preuve |
|---|---|---|
| Guest → assessment → result | PARTIAL | score/Hive fonctionnent; safety et migration cassées |
| User → profile/wilaya → assessment/history → request | PARTIAL | request local, no backend/consent lifecycle |
| Psychologist → request → patient → chat | PARTIAL | accepted filter local, no ownership service/server |
| Admin → dashboard → users/pros/logs | PARTIAL | local only; no PDF/backend |

# 58. Scénarios négatifs

Internet OFF : local flow works; sync fake. DB/Hive error : nombreux écrans affichent erreur, assessment peut rester loader. Invalid login : message générique, oui. Expired session/token : NOT IMPLEMENTED. Unknown role : défaut `/user`. Unauthorized route : guard route oui, repository non. Empty bank : engine termine/résultat, non testé. Missing answer : null ignoré. Duplicate submit : request partiellement dédoublonnée seulement dans une méthode. Rejected/revoked : reject existe, revoke sans UI. Consent revoke : NOT IMPLEMENTED.

# 59. Dette technique

Deux familles engines/modèles assessment, deux chats, interfaces remote mortes, modèles/boîtes `dynamic`, tailles de fichiers/écrans très grandes, `hashCode` comme identifiant persistant, hardcoded strings, README obsolète, nombreuses suppressions Git non stabilisées. Dépendances `pdf`, `printing`, `http`, `connectivity_plus` ne matérialisent pas les fonctions annoncées.

# 60. Priorités de correction

| ID | Problème | Fichier:ligne | Gravité | Cause / impact | Correction recommandée |
|---|---|---|---|---|---|
| P01 | comptes/secret seedés | database_seed_service:154-191,263-328 | CRITICAL | prise de contrôle locale | retirer seeds prod, rotation, onboarding admin sécurisé |
| P02 | sync déclare succès sans réseau | sync_queue_service:194-199 | CRITICAL | perte/illusion de données | implémenter API idempotente ou désactiver feature |
| P03 | red flag sans écran urgence | assessment_provider:86-88 | CRITICAL | personne en danger reçoit résultat normal | action safety dédiée/contacts/stop persistant |
| P04 | pas de backend/RBAC serveur | providers:44-65 | CRITICAL | accès contrôlé par client | API Auth/RLS/ownership/audit serveur |
| P05 | Q453 inatteignable après Q452 urgent | provider:86-88; bank:551-590 | HIGH | triage incomplet | séquencer risk-immediate avant stop |
| P06 | migration guest jamais appelée et globale | auth_repo:436-440; assessment_repo:29-45 | HIGH | confidentialité/mauvais rattachement | migration ciblée, explicite, transactionnelle |
| P07 | réponse access request sans acteur | hive_professional_repo:121-138 | HIGH | Broken access control | exiger principal+ownership serveur |
| P08 | API HTTP/auth absente | api_client:14-47 | HIGH | interception si activée | HTTPS, tokens, pinning selon besoin |
| P09 | questions admin inutilisées | hive_admin_repo:17-41 | HIGH | UI trompeuse | source unique banque/versionnée |
| P10 | résultat/traces non persistés | assessment repo:19-31 | MEDIUM | historique inexpliquable | sérialiser result/trace |
| P11 | centres générés | professional_provider:145-162 | MEDIUM | fausse orientation | annuaire vérifié/attribution source |
| P12 | localisation incomplète | router:567-617 + écrans | MEDIUM | FR en arabe | extraire toutes chaînes |

# 61. Roadmap de finalisation

Ordre impératif : P01/P02/P03/P04, puis P05–P09, puis données/historique/localisation, puis UX/perf/a11y. Détails opérationnels dans `NEUROSYNC_IMPLEMENTATION_PLAN.md`.

# 62. Verdict final

**CONTROLLED PROTOTYPE.** Utilisable uniquement sur appareil institutionnel contrôlé, sans promesse de synchronisation, de sécurité multi-utilisateur, d'annuaire réel ou de prise en charge urgente. Il n'est ni "PRODUCTION READY" ni "NEAR PRODUCTION" : les quatre bloqueurs CRITICAL, les secrets de démonstration et l'absence de backend autorisé empêchent une diffusion publique.

## Score final (/10)

| Domaine | Score | Domaine | Score |
|---|---:|---|---:|
| Architecture | 4 | Fonctionnalités | 4 |
| Navigation | 5 | Auth | 3 |
| RBAC | 2 | Assessment | 5 |
| Adaptive Engine | 5 | Scoring | 5 |
| Safety | 2 | Decision Engine | 4 |
| Orientation | 3 | Consentement | 2 |
| Psychologist | 3 | Admin | 3 |
| Offline-First | 6 | Backend | 0 |
| Security | 2 | Privacy | 3 |
| Localization | 5 | UI/UX | 5 |
| Tests | 4 | Performance | 4 |
| Accessibility | 3 | Code Quality | 3 |
| Production Readiness | 1 | **Global** | **3.9** |

