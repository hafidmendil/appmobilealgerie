# NEUROSYNC 4.0 — ACCOUNT & SYNCHRONIZATION REPORT

## 1. Types de comptes
- **GUEST** : Consultation anonyme et évaluation locale.
- **USER** : Utilisateur standard avec historique et synchronisation.
- **PSYCHOLOGIST** : Professionnel avec accès patient contrôlé par consentement.
- **ADMIN** : Administrateur système pour la gestion technique et validation.

## 2. Architecture Technique (Phase A - Prototype)
- **Local Storage** : Implémentation de **Hive** pour la persistance des `AssessmentRecord`, `UserModel` et `AccessRequest`.
- **Repository Pattern** : Séparation nette entre les interfaces (`AuthRepository`, `AssessmentRepository`) et les implémentations Mock.
- **Navigation & Sécurité** : Utilisation de **GoRouter** avec des `Route Guards` vérifiant dynamiquement le rôle et l'état d'authentification.
- **State Management** : Utilisation intensive de **Riverpod** pour une réactivité fluide de l'UI.

## 3. Fonctionnalités Implémentées
- **Authentification Mockée** : Flux complet Register/Login/Logout architecturé pour intégration future.
- **Mode Visiteur (Guest)** : Navigation accessible sans compte avec option de migration.
- **Migration Guest → User** : Rattachement automatique des données locales au nouveau compte lors de l'inscription.
- **Consentement Professionnel** : Modèle `AccessRequest` fonctionnel (Pending, Accepted, Revoked).
- **Synchronisation Simulée** : File d'attente de synchronisation gérant l'état `pending` → `synced`.

## 4. Sécurité & Confidentialité
- **Protection des Routes** : Accès refusé aux dossiers `/admin` et `/psychologist` pour les utilisateurs non autorisés.
- **Isolation des Données** : Les psychologues ne voient que les patients ayant validé une demande d'accès. L'admin n'a pas accès direct aux réponses psychosociales.

## 5. Tests Effectués (Logique)
- Validation du passage de Guest à User avec conservation des données.
- Blocage des routes Admin pour les profils User.
- Simulation de synchronisation lors du passage d'un assessment en mode connecté.

## 6. Prochaines Étapes (Phase B - Backend)
- Remplacer `MockAuthService` par `FirebaseAuthService` ou `SupabaseAuthService`.
- Connecter `MockAssessmentRepository` à une API REST ou base de données distante.
- Implémenter le stockage réel des documents de validation pour les psychologues.

---
*Ce système constitue une base solide, sécurisée et évolutive pour la version professionnelle de NeuroSync 4.0.*
