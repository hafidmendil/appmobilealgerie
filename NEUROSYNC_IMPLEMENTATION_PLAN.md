# Plan de finalisation NeuroSync 4.0

Ce plan est volontairement une feuille de route de Phase 2 : aucune correction n'est effectuée par l'audit. Les estimations sont relatives (S/M/L/XL), pas des engagements calendaires. Chaque tâche doit inclure revue de sécurité, tests ciblés et test manuel du parcours concerné.

## 1. Critical fixes

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| C01 | Retirer comptes et credentials de démonstration du démarrage distribué; révoquer/rotater les secrets déjà exposés | `database_seed_service.dart`, docs, données test | stratégie bootstrap admin | rupture démo | Critical | M | aucun secret/cpte privilégié auto-créé en prod | scan secret, tests bootstrap |
| C02 | Remplacer le faux sync par API idempotente réelle, ou désactiver totalement queue/UI sync | `sync_queue_service.dart`, repos | backend C04 | perte de données | Critical | XL | aucun item supprimé sans ACK authentifié | offline/retry/error/conflict |
| C03 | Implémenter un écran safety immédiat, contacts locaux validés, trace et retour contrôlé; corriger Q452→Q453 | assessment provider/pages/engine/bank | validation clinique/juridique | safety UX | Critical | L | red flag ne mène jamais à résultat normal; Q453 proposé au bon moment | widget + engine + E2E red flag |
| C04 | Construire backend Auth/API + RBAC + ownership, puis migrer données sensibles hors de la confiance client | backend nouveau, providers/repos/auth/router | décision infra/DPO | architecture | Critical | XL | contrôles exécutés serveur, audit immuable, API HTTPS | integration/API/IDOR |

## 2. High priority

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| H01 | Migration guest ciblée, explicite, transactionnelle et appelée après register/login | auth repo, migration, assessment repo, UI | modèle session guest | confidentialité | High | L | seuls records de la session consentie migrent | guest→user, rollback |
| H02 | Contrôler acteur/propriétaire dans demandes, patient, chat et actions admin | repos/professional/chat/admin | C04 à terme | accès indu | High | L | appels non autorisés refusés sans UI | unit hostile + integration |
| H03 | Retirer API HTTP; config par build flavor, secrets hors code, logs PII minimisés | api/app_config/main/logger | C04 | config | High | M | build release prod sans logs PII/HTTP | config/release scan |
| H04 | Persist result, orientation, recommandations, safety et EngineTrace versionné | assessment models/repository/history | migration Hive/backend | compatibilité | High | M | résultat historique reproductible/expliqué | repository/migration |
| H05 | Mettre une source unique de question bank versionnée; brancher administration ou retirer UI | question bank/admin repo/adapter | gouvernance clinique | données | High | L | modification approuvée affecte moteur de façon contrôlée | engine/version/rollback |
| H06 | Consentement professionnel explicite : portée, version, expiration, revoke et audit | models/repo/session/access UI | C04/DPO | juridique | High | XL | revoke coupe immédiatement lecture/chat | consent E2E |
| H07 | Supprimer `hashCode` comme identifiant persistant des rendez-vous | session model/repository | migration | corruption relation | High | M | UUID/IDs stables de bout en bout | migration/appointment |

## 3. Medium priority

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| M01 | Ajouter détail, suppression, filtre et pagination history avec ownership | history/repository | H04 | UX | Medium | M | user voit/efface uniquement ses données | widget/ownership |
| M02 | Remplacer centres/professionnels mockés par registre sourcé et date de vérification | professional data/repository/UI | backend/gouvernance | orientation | Medium | L | source, statut et disponibilité affichés | repository/filter |
| M03 | Afficher recommandations réellement calculées et explication non clinique | results/recommendation | H04 | cohérence | Medium | M | IDs calculés visibles, lien sûr aux ressources | widget/engine |
| M04 | Stabiliser algorithme adaptive (priorités non cumulatives, conditions évaluées, all axes cohérents) | adaptive engines/models/bank | validation clinique | régression score | Medium | L | tests déterministes 10+ scénarios | unit golden matrix |
| M05 | Compléter FR/AR, RTL, dates/nombres et extraire chaînes | router/admin/legal/professional | l10n review | UX | Medium | L | aucune chaîne UI FR hardcodée, RTL smoke pass | locale/widget |
| M06 | Notifications : décider scope, implémenter ou retirer modèles/UI | notification feature | backend/push | attentes | Medium | L | événements/réception/opt-out testés | integration |

## 4. Low priority

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| L01 | Uniformiser design tokens, empty/error copy et formulaires | screens/widgets/theme | M05 | faible | Low | M | composants cohérents | widget snapshots |
| L02 | Ajouter semantics, contrast audit, touch targets et keyboard | widgets/screens | design review | faible | Low | M | parcours lecteur écran valide | a11y tests/manual |
| L03 | Optimiser listes, index de recherche et seed | providers/repos | M02 | faible | Low | M | pas de jank, listes paginées | profiling |

## 5. Refactoring

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| R01 | Choisir une seule famille d'engines/models assessment; supprimer ou déprécier l'autre | `core/engines`, adaptive assessment | M04 | élevé | High | L | un seul call graph production | full regression |
| R02 | Unifier les deux systèmes chat/répositories | chat/message models/repos | H02 | données | Medium | M | une conversation/modèle/box | migration/chat |
| R03 | Encapsuler Hive dans repositories, supprimer accès UI/provider direct | features/core data | H04 | large | Medium | XL | widgets sans Hive direct | repository/widget |
| R04 | Typage des boîtes `dynamic`, adapters et migrations vérifiées | hive config/models | R03 | migration | Medium | L | aucune box sensible `dynamic` | migration tests |

## 6. Missing features

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| F01 | Password reset/verification/session expiration | auth/backend/UI | C04 | auth | High | L | parcours sécurisé complet | API/E2E |
| F02 | PDF export réellement autorisé, minimisé et audité | results/pdf/admin | H04/H06 | privacy | Medium | L | PDF justifié et sans PII non consentie | PDF snapshot |
| F03 | Téléconsultation : intégration réelle ou suppression du bouton | patient detail | product/legal | attentes | Medium | L | action correspond au libellé | E2E |
| F04 | Reprise assessment/drafts avec consentement et effacement | assessment/Hive | H04 | privacy | Medium | M | reprise/abandon robustes | persistence |

## 7. Security hardening

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| S01 | Threat model (IDOR, appareil compromis, admin, sync), DPO/security review | architecture/docs | C04 | fondation | Critical | M | risques/propriétaires/contrôles validés | review |
| S02 | Server authorization par rôle + ownership + RLS/ACL | backend | C04 | accès | Critical | XL | tests négatifs de chaque endpoint | pen test/API |
| S03 | Journal audit append-only, rétention/minimisation des PII | logs/backend | C04/H06 | conformité | High | L | logs consultables/immutables/expirables | audit tests |
| S04 | Gestion secrets CI/build, dependency scan, release flavor | CI/config | C01 | supply chain | High | M | aucun secret scan; build prod sûr | SAST/secret scan |

## 8. Testing plan

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| T01 | Matrice engine : 10+ seuils, nulls, inversions, Q451/Q452/Q453, no-repeat | `test/assessment_*` | M04 | régression clinique | High | M | résultats déterministes approuvés | unit |
| T02 | Routes/guards pour guest/user/psy/admin/suspendu | router/auth tests | H02 | accès | High | M | 4 rôles + deep links refusés/acceptés | widget/router |
| T03 | E2E des quatre parcours demandés | integration_test | C04 partial | qualité | High | L | pass réel sur device/emulator | integration |
| T04 | Consent revoke/IDOR/chat/admin hostile | API/repository tests | H02/H06 | sécurité | Critical | L | deny prouvé | integration/security |
| T05 | FR/AR RTL, a11y et erreur réseau/Hive | widget tests | M05 | UX | Medium | M | states visibles sans overflow | widget/a11y |

## 9. Backend integration

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| B01 | Choisir plateforme, schéma, régions/hébergement et responsable données | ADR/backend | DPO/S01 | choix | Critical | M | ADR validée | review |
| B02 | Modèles API : users, profiles, assessments/results, consent, access, messages, resources | backend/repos | B01 | migration | Critical | XL | validation, pagination, transactions | API contract |
| B03 | Auth HTTPS, rotation, sessions, MFA à vraie preuve | backend/auth/mobile | B01 | sécurité | Critical | XL | tokens/expiry/revocation réels | auth integration |
| B04 | Sync offline idempotent, conflit, observabilité | backend/mobile sync | B02/B03 | données | Critical | XL | queue durable, ACK, retry, conflict | device integration |

## 10. Production preparation

| ID | Description | Fichiers concernés | Dépendances | Risque | Priorité | Estimation | Critères d'acceptation | Tests nécessaires |
|---|---|---|---|---|---|---|---|---|
| P01 | Validation clinique, urgences, annuaire et contenu religieux/juridique par responsables nommés | banques/docs | C03/M02 | humain | Critical | L | versions, date, sources, approbations | review |
| P02 | Privacy notice, consentements, rétention, DSR et support incident | legal/product/backend | H06 | conformité | Critical | L | parcours et procédures publiés | legal/UAT |
| P03 | CI/CD, signing, flavors, monitoring sans PII, crash reporting | CI/app config | S04 | release | High | L | release candidate traçable | pipeline |
| P04 | UAT pilote contrôlé et go/no-go formel | all | tout ci-dessus | publication | Critical | L | critères C01–C04/T01–T05 passés | UAT |

## Gates de sortie

1. Aucun secret, compte privilégié de démonstration, HTTP ou faux succès de sync dans un build release.
2. Safety red flag validée par clinicien et testée E2E.
3. Toutes les actions sensibles refusées par le backend sans rôle/ownership/consentement.
4. Consentement et révocation effectifs, auditables.
5. Les parcours Guest/User/Psychologist/Admin et leurs scénarios négatifs passent sur appareil réel.
6. Documentation/README décrivent exactement le système livré.
