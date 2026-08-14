# Rapport Technique Complet : Projet NeuroSync 4.0

## 1. PRÉSENTATION GÉNÉRALE DU PROJET

*   **Nom du projet** : NeuroSync 4.0
*   **Objectif général** : Repérage précoce des risques psychologiques et orientation clinique automatisée.
*   **Problématique traitée** : Difficulté d'accès à une première évaluation psychologique fiable et anonyme, et besoin d'orientation rapide vers des professionnels.
*   **Besoin auquel le projet répond** : Fournir un outil d'auto-évaluation basé sur des échelles cliniques validées, avec un moteur de décision intelligent.
*   **Public cible** : Personnes en situation de stress ou de détresse psychologique, psychologues et administrateurs de santé.
*   **Utilisateurs concernés** : Visiteurs anonymes, Utilisateurs inscrits, Psychologues (Professionnels), Administrateurs.
*   **Contexte d'utilisation** : Mobile (Android/iOS) et Web.
*   **Fonctionnement général** : L'utilisateur remplit un questionnaire adaptatif ; le système analyse les réponses (scores par dimension et alertes de sécurité) et propose une recommandation d'orientation.
*   **Architecture globale** : Architecture modulaire par fonctionnalités (Feature-First) développée avec Flutter.
*   **Technologies utilisées** : Flutter (SDK ^3.12.2), Riverpod (État), Hive (Base de données locale), GoRouter (Navigation).
*   **Environnement de développement** : Flutter SDK, Android Studio.
*   **Environnement d'exécution** : Mobile (Android/iOS), Web, Desktop (Windows).
*   **Plateformes supportées** : Android, iOS, Web, Windows.

**Pourquoi ce système existe ?**
Il vise à démocratiser le diagnostic précoce en santé mentale en réduisant les barrières (stigmate, coût, délai) grâce à une application experte bilingue (Français/Arabe).

**Quel problème cherche-t-il à résoudre ?**
Le retard dans la détection des Red Flags (signaux d'alerte critiques) et le manque de clarté sur le parcours de soin nécessaire.

**Comment les différents utilisateurs interagissent-ils avec le système ?**
Les **visiteurs** testent l'outil ; les **utilisateurs** suivent leur évolution ; les **psychologues** gèrent les alertes de leurs patients ; les **admins** valident les professionnels.

---

## 2. ARCHITECTURE GLOBALE

L'architecture suit les principes de la **Feature-First Architecture** (Clean Architecture simplifiée).

*   **Frontend** : Flutter avec Material Design et animations personnalisées (`lib/core/theme/app_animations.dart`).
*   **Backend** : Actuellement **MOCKÉ**. Toute la logique de persistance et d'authentification est simulée localement.
*   **API** : Définie dans `lib/core/data/remote_data_source.dart` mais non implémentée (utilisant des Mock Services).
*   **Base de données** : **Hive** (NoSQL local) avec chiffrement AES pour les données sensibles (Profils, Évaluations).
*   **Authentification** : Gérée par `MockAuthService` avec persistance dans un box Hive sécurisé.
*   **Navigation** : **GoRouter** avec gestion centrale des routes et guards de sécurité par rôle.

**Flux de données type :**
Utilisateur → Interface (Flutter) → Provider (Riverpod) → Repository (Interface) → Mock Service (Hive) → Réponse → UI.

---

## 3. TECHNOLOGIES UTILISÉES

| Technologie | Version | Rôle | Pourquoi ? |
| :--- | :--- | :--- | :--- |
| **Flutter** | ^3.12.2 | Framework UI | Multiplateforme et performance. |
| **Riverpod** | ^2.5.1 | Gestion d'état | Modularité, testabilité et sécurité des types. |
| **Hive** | ^2.2.3 | Base de données locale | Rapide, NoSQL, supporte le chiffrement nativement. |
| **GoRouter** | ^14.2.1 | Navigation | Gestion déclarative des routes et des liens profonds. |
| **Intl** | ^0.20.2 | Internationalisation | Support bilingue FR/AR et support RTL. |
| **Secure Storage** | ^9.2.2 | Stockage sécurisé | Conservation de la clé de chiffrement AES. |
| **Google Fonts** | ^6.2.1 | Typographie | Uniformité visuelle. |

---

## 4. TYPES DE COMPTES / RÔLES

### 4.1 Visiteur (Guest)
*   **Objectif** : Permettre une évaluation rapide sans engagement.
*   **Identification** : Anonyme (pas d'ID utilisateur dans Hive).
*   **Accès** : Écran d'accueil spécifique (`GuestHomeScreen`), Assessment, Résultats.
*   **Restrictions** : Pas d'historique persistant après effacement des données, pas de profil, pas de suivi professionnel.

### 4.2 Utilisateur (User)
*   **Objectif** : Suivi personnel et historique des évaluations.
*   **Inscription** : Email, Mot de passe. Activation immédiate (`status: active`).
*   **Fonctionnalités** : Dashboard personnalisé, Historique des évaluations, Profil, Accès aux ressources.
*   **Restrictions** : Ne peut pas voir les données des autres, ne peut pas valider de professionnels.

### 4.3 Psychologue (Psychologist)
*   **Objectif** : Suivi clinique et gestion des alertes patients.
*   **Inscription** : Requiert une validation par l'administrateur (`status: pending` initialement).
*   **Dashboard** : Statistiques (Patients, Alertes), Liste des demandes de suivi (`AccessRequest`).
*   **Fonctionnalités** : Consultation des rapports cliniques des patients ayant donné leur accord.
*   **Restrictions** : Ne peut consulter que les patients liés par une `AccessRequest` acceptée.

### 4.4 Administrateur (Admin)
*   **Objectif** : Gestion globale du système et validation des professionnels.
*   **Identification** : Détecté par le mot "admin" dans l'email (dans le Mock Service).
*   **Fonctionnalités** : Validation/Rejet des psychologues, Gestion des utilisateurs (prévu), Logs de sécurité (prévu).
*   **Restrictions** : Ne participe pas aux évaluations cliniques.

---

## 5. MATRICE DES PERMISSIONS

| Fonctionnalité | Visiteur | Utilisateur | Psychologue | Admin |
| :--- | :---: | :---: | :---: | :---: |
| Passer une évaluation | ✅ | ✅ | ❌ | ❌ |
| Voir ses résultats | ✅ | ✅ | ❌ | ❌ |
| Sauvegarder historique | ❌ | ✅ | ❌ | ❌ |
| Voir statistiques patients | ❌ | ❌ | ✅ | ❌ |
| Valider un psychologue | ❌ | ❌ | ❌ | ✅ |
| Modifier paramètres globaux | ❌ | ❌ | ❌ | ✅ |
| Accès mode expert | ❌ | ❌ | ✅ | ✅ |

---

## 6. ANALYSE DES FONCTIONNALITÉS CLÉS

### 6.1 Évaluation Adaptative (Assessment)
*   **Objectif** : Questionnaire intelligent variant selon les réponses.
*   **Logic** : Utilise le `AdaptiveAssessmentEngine`. Les questions sont filtrées par `QuestionCondition` et triées par `priorityBoost`.
*   **Dimensions** : Safety, PHQ-4 (Dépression/Anxiété), Sommeil, Stress, Fonctionnement, Social, etc.
*   **État** : ✅ Implémenté (Logiciel), 🟡 Partiel (UI de navigation entre questions).

### 6.2 Moteur de Décision (Decision Engine)
*   **Traitement** : Calcul des scores par module. Détection des Red Flags.
*   **Résultats** : 4 niveaux d'orientation (du self-care à l'urgence).
*   **État** : ✅ Implémenté et Testé (`engine_test.dart`).

### 6.3 Système Multilingue & RTL
*   **Mécanisme** : `LocaleProvider` gère la bascule FR/AR.
*   **Interface** : Inversion automatique des layouts pour l'Arabe (RTL).
*   **État** : ✅ Implémenté.

---

## 7. BASE DE DONNÉES (HIVE SCHEMA)

| Table (Box) | Type de données | Description |
| :--- | :--- | :--- |
| `auth_box` | `UserModel` | Stocke l'utilisateur courant et son état de session. |
| `users_box` | `UserModel` | Liste de tous les utilisateurs (Mock DB). |
| `assessments` | `AssessmentRecord` | Historique des évaluations (Score, Réponses, Date). |
| `access_requests` | `AccessRequest` | Demandes de liaison Patient-Psychologue. |
| `prof_profiles` | `ProfessionalProfile` | Détails sur les psychologues (Spécialité, Ville). |

---

## 8. SÉCURITÉ

*   **Authentification** : Basée sur des tokens simulés.
*   **Chiffrement local** : **AES-256** utilisé pour tous les box Hive. La clé est stockée dans le `FlutterSecureStorage` de l'OS.
*   **Guards de navigation** : Les routes `/admin` et `/psychologist` sont protégées par le `routerProvider`.
*   **⚠️ Risque détecté** : La logique de détermination du rôle Admin est basée sur une simple vérification de chaîne dans l'email (`email.contains('admin')`), ce qui est acceptable pour un mock mais critique pour une production.

---

## 9. ÉTAT ACTUEL DU PROJET (Résumé)

*   **✅ Fonctionnalités Terminées** :
    *   Architecture de base et navigation.
    *   Système d'authentification (Mock).
    *   Moteur de décision clinique et scoring.
    *   Interface bilingue et support RTL.
    *   Persistance locale chiffrée.
*   **🟡 Fonctionnalités Partielles** :
    *   Questionnaire adaptatif (manque de profondeur dans les règles complexes).
    *   Validation des psychologues (UI basique dans un dialogue).
    *   Dashboard professionnel (UI présente, logique de consultation de rapports à finaliser).
*   **🔴 Fonctionnalités Non Implémentées / Manquantes** :
    *   **Backend réel** (Firebase ou API REST).
    *   Synchronisation Cloud.
    *   Export PDF des rapports (squelette présent mais logique d'impression absente).
    *   Gestion fine des notifications Push.

---

## 10. ANALYSE DE LA QUALITÉ DU CODE

*   **Organisation** : Excellente. Le projet suit les standards Flutter modernes (Riverpod 2.0).
*   **Maintenabilité** : Haute grâce à l'architecture modulaire.
*   **Tests** : Présence de tests unitaires pour le moteur de décision et l'adaptive engine.
*   **Dette technique** :
    *   Incohérence dans les modèles de résultats entre `DecisionEngine` et `AdaptiveEngine`.
    *   Utilisation massive de `Future.delayed` pour simuler le réseau.

---

## 11. RECOMMANDATIONS & ROADMAP

1.  **Phase 1 (Urgent)** : Corriger les incohérences de types dans `AdaptiveAssessmentEngine.computeResult` pour éviter les crashs à l'exécution.
2.  **Phase 2 (Infrastructure)** : Connecter un backend réel (Firebase Auth & Firestore) en remplaçant les `MockServices`.
3.  **Phase 3 (Fonctionnel)** : Finaliser l'UI de consultation des rapports pour les psychologues.
4.  **Phase 4 (UX/UI)** : Ajouter un système de feedback pour les utilisateurs lors de la saisie du questionnaire.

---

## CONCLUSION

Le projet **NeuroSync 4.0** est une application Flutter **très mature architecturalement** et fonctionnellement riche pour un stade de développement initial. La séparation des rôles et la sécurité locale sont bien pensées. Le cœur du système (Moteur de décision) est robuste et testé. Le défi principal réside désormais dans le passage d'une persistance locale mockée à une infrastructure backend réelle pour permettre le suivi multi-appareils et la collaboration en temps réel entre patients et professionnels.
