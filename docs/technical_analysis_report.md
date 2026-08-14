# Rapport d'Analyse Technique : NeuroSync 4.0

Ce document présente une analyse détaillée du projet NeuroSync 4.0, couvrant son architecture, ses fonctionnalités, sa logique métier et l'état actuel de son implémentation.

---

## 1. Architecture du Projet

Le projet adopte une architecture **Feature-First** (par fonctionnalités), favorisant la modularité et la maintenabilité.

### Technologies Clés
*   **Framework** : Flutter & Dart (sdk: ^3.12.2)
*   **Gestion d'État** : Riverpod (flutter_riverpod: ^2.5.1)
*   **Navigation** : GoRouter (^14.2.1) avec système de permissions (Guards)
*   **Base de Données Locale** : Hive (^2.2.3) pour le mode "Offline-first"
*   **Internationalisation** : l10n (FR/AR) avec support complet du RTL

### Structure des Dossiers
*   `lib/core/` : Socle commun (Auth, Navigation, Thème, Services globaux).
*   `lib/features/` : Modules métier (Assessment, Engine, Results, Dashboard, Professional, Admin).
*   `lib/l10n/` : Fichiers de traduction `.arb`.
*   `lib/generated/` : Code généré par Flutter (Localisation, Hive Adapters).

---

## 2. Système d'Authentification et Rôles

NeuroSync 4.0 gère quatre types de comptes via un système de rôles (`UserRole`).

| Rôle | Accès & Fonctionnalités | Stockage |
| :--- | :--- | :--- |
| **Visiteur** | Anonyme, Questionnaire, Résultats locaux, Ressources. | Hive (Local uniquement) |
| **Utilisateur** | Profil, Historique, Rapport clinique, Consentement professionnel. | Hive + Sync Queue |
| **Psychologue** | Dashboard pro, Demandes d'accès, Statistiques (Mock), Rapports autorisés. | Hive + Sync Queue |
| **Administrateur** | Gestion utilisateurs, Validation psychologues, Logs (Mock), Paramètres. | Hive + Sync Queue |

> [!NOTE]
> L'authentification actuelle utilise `MockAuthService`. Elle simule les interactions avec un backend mais les données restent locales. Les comptes de test sont `admin@test.com` et `psy@test.com`.

---

## 3. Le Questionnaire et DecisionEngine

Le système repose sur une évaluation en 8 dimensions :
1. **Sécurité (Red Flags)** : Détection immédiate du risque suicidaire.
2. **Stress & Tension** : Niveau de tension globale.
3. **Sommeil** : Impact sur le repos et la fatigue.
4. **PHQ-4** : Dépression et Anxiété.
5. **Fonctionnement** : Impact sur la vie quotidienne.
6. **Relations Sociales** : Tensions et isolement.
7. **Biais Cognitifs** : Interprétations et impulsivité.
8. **Trauma (SART)** : Flashbacks et évitement.

### Logique du `DeterministicDecisionEngine`
Le calcul de l'orientation suit une priorité stricte :
*   **Priorité 1** : Si un **Red Flag** est activé -> **Niveau 4 (Urgent)**.
*   **Priorité 2** : Score total cumulé :
    *   `>= 40` : **Niveau 3** (Contact recommandé).
    *   `>= 20` : **Niveau 2** (Consultation conseillée).
    *   `< 20` : **Niveau 1** (Auto-apaisement).

---

## 4. État de l'Implémentation

| Composant | État Réel | Observation |
| :--- | :--- | :--- |
| **Questionnaire** | ✅ FONCTIONNEL | 25 questions, calculs de progression ok. |
| **Moteur de Décision**| ✅ FONCTIONNEL | Logique déterministe validée par tests. |
| **Stockage Hive** | ✅ FONCTIONNEL | Persistance locale robuste. |
| **Migration Guest->User**| ✅ FONCTIONNEL | Transfert des données après inscription. |
| **Rapport Clinique** | ✅ FONCTIONNEL | Génération et partage via SharePlus. |
| **Localisation** | ✅ FONCTIONNEL | Français et Arabe (RTL). |
| **Dashboard Psy/Admin**| 🟠 PARTIEL | UI fonctionnelle, actions de gestion mockées. |
| **Backend / Sync** | 🔴 MOCK | File d'attente prête mais pas de serveur réel. |

---

## 5. Guide d'Apprentissage (Top 10 Fichiers)

Pour comprendre le projet rapidement, étudiez les fichiers dans cet ordre :
1.  [`lib/features/engine/decision_engine.dart`](file:///home/hafid/Bureau/projetmascara/lib/features/engine/decision_engine.dart) : Le cerveau logique.
2.  [`lib/core/navigation/app_router.dart`](file:///home/hafid/Bureau/projetmascara/lib/core/navigation/app_router.dart) : La structure des routes.
3.  [`lib/main.dart`](file:///home/hafid/Bureau/projetmascara/lib/main.dart) : L'initialisation.
4.  [`lib/features/assessment/assessment_state.dart`](file:///home/hafid/Bureau/projetmascara/lib/features/assessment/assessment_state.dart) : La gestion du flux.
5.  [`lib/core/auth/auth_provider.dart`](file:///home/hafid/Bureau/projetmascara/lib/core/auth/auth_provider.dart) : La session utilisateur.
6.  [`lib/features/results/clinical_report.dart`](file:///home/hafid/Bureau/projetmascara/lib/features/results/clinical_report.dart) : L'analyse clinique.
7.  [`lib/core/services/mock_auth_service.dart`](file:///home/hafid/Bureau/projetmascara/lib/core/services/mock_auth_service.dart) : La simulation API.
8.  [`lib/features/auth/screens/register_screen.dart`](file:///home/hafid/Bureau/projetmascara/lib/features/auth/screens/register_screen.dart) : L'inscription.
9.  [`lib/features/assessment/assessment_record.dart`](file:///home/hafid/Bureau/projetmascara/lib/features/assessment/assessment_record.dart) : Le stockage Hive.
10. [`lib/core/services/sync_service.dart`](file:///home/hafid/Bureau/projetmascara/lib/core/services/sync_service.dart) : Le moteur de synchronisation.

---

## 6. Schéma de Flux de Données

`Utilisateur` → `Interface (Widget)` → `Provider (Riverpod)` → `Service/Repo (Mock/Remote)` → `Modèle` → `Stockage (Hive)` → `DecisionEngine` → `Résultat` → `Interface`.

---

**Note finale** : NeuroSync 4.0 est actuellement un prototype avancé de haute qualité, fonctionnant de manière autonome en local. La prochaine étape majeure est la connexion à un backend réel pour la synchronisation centralisée et la gestion réelle des accès professionnels.
