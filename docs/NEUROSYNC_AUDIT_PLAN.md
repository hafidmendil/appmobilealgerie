# Audit NeuroSync 4.0 — EXISTANT / MANQUANT / À CORRIGER / À AMÉLIORER / À AJOUTER

## 1. EXISTANT

Le projet est déjà doté d’une base fonctionnelle solide :

- architecture Flutter + Riverpod + GoRouter + Hive ;
- rôles `user`, `psychologist`, `admin` avec navigation conditionnelle ;
- moteur d’évaluation adaptative avec sélection de questions, traces et résultats ;
- moteur de sécurité avec déclenchement de red flags ;
- tableau de bord patient, psychologue et admin ;
- localisations FR/AR, support RTL et navigation multi-rôles ;
- persistance locale via Hive avec chiffrement ;
- services de contenu, de progression et de ressources.

## 2. MANQUANT

- modélisation métier complète des relations patient ↔ psychologue ;
- consentement explicite et versionné ;
- système centralisé de notifications, signalements et blocages ;
- espace de rendez-vous avec historique et statut de disponibilité ;
- chat professionnel avec permissions et accès contrôlé ;
- suivi longitudinal structuré via `AssessmentRecord` enrichi ;
- moteur de recommandations basé sur historique, check-ins et préférences ;
- dashboard administratif complet avec sécurité, logs et statistiques ;
- tests unitaires et intégration sur les permissions et accès.

## 3. À CORRIGER

- la logique de sécurité ne doit jamais être masquée par le score normal ;
- la neutralité diagnostique doit être explicite dans tous les résultats et recommandations ;
- les modèles d’évaluation doivent être cohérents avec les spécifications métier demandées (category, subcategory, rules, safety_level, etc.) ;
- le flux de relation patient/psychologue doit être vérifié par permission et non par simple liste de professionnels ;
- les données sensibles doivent être séparées de données publiques/professionnelles ;
- les états de chargement, erreur, vide et accès interdit doivent être homogènes dans l’UX.

## 4. À AMÉLIORER

- architecture de données : mieux séparer layout UI / state / domain / data ;
- persistance Hive : ajouter des modèles métier dédiés et mieux gérer les migrations ;
- navigation : sécuriser les routes sensibles avec contrôle de rôle et de statut ;
- gamification : garder le système de récompense sans récompenser la détresse ;
- contenu : validation de source, attribution et statut de vérification ;
- accessibilité et conformité UX (contraste, lisibilité, RTL, responsive).

## 5. À AJOUTER

- `UserModel` enrichi pour consentement, wilaya, préférences, profils dédiés ;
- `PatientProfile`, `PsychologistProfile`, `AdminModel` ;
- `ConsentRecord`, `PatientPsychologistRelation`, `Appointment`, `Report`, `Block`, `NotificationModel` ;
- `AdaptiveQuestionEngine`, `ScoringEngine`, `SafetyEngine`, `RecommendationEngine` formalisés et documentés ;
- modèles de test RBAC et sécurité sur les droits d’accès.

## 6. Plan de mise en œuvre par priorité

### Priorité 1 — Sécurité & conformité

1. sécuriser le moteur d’évaluation et empêcher toute logique de diagnostic implicite ;
2. clarifier les règles de sécurité et les messages de soutien ;
3. renforcer le modèle des rôles et l’accès par permission.

### Priorité 2 — Évaluation & suivi longitudinal

1. enrichir les données de résultats et d’engine trace ;
2. structurer les domaines, recommandations et tendances ;
3. ajouter le check-in quotidien et le suivi par période.

### Priorité 3 — Relations professionnelles

1. ajouter les relations patient-psychologue et contrôles d’autorisation ;
2. sécuriser la messagerie et la gestion des rendez-vous ;
3. centraliser les notifications et les reports.

### Priorité 4 — Administration & contenu

1. dashboard admin complet ;
2. validation des psychologues, permissions, logs sécurité ;
3. gestion des contenus éducatifs et leurs statuts de validation.

### Priorité 5 — Tests et stabilisation

1. tests unitaires sur moteur de sécurité ;
2. tests sur permissions multi-rôles ;
3. validation Flutter analyze / tests ciblés.

## 7. Matrice synthèse

| FEATURE | STATUS | FILES | DATABASE | API | TEST | SECURITY |
|---|---|---|---|---|---|---|
| Auth & rôles | Partiel | lib/core/auth, lib/core/navigation | Hive | Local service | À prévoir | Moyen |
| Adaptive assessment | Fonctionnel | lib/features/adaptive_assessment | Hive | Local | À prévoir | Moyen |
| Safety engine | Partiel | lib/features/adaptive_assessment/domain/engines | Hive | Local | À prévoir | Élevé |
| Patient/Psychologist relation | Manquant | lib/features/professional | À créer | À prévoir | À prévoir | Élevé |
| Messaging | Partiel | lib/features/professional, lib/features/messaging | Hive | Local | À prévoir | Élevé |
| Appointments | Manquant | À créer | À créer | À prévoir | À prévoir | Moyen |
| Notifications | Manquant | À créer | À créer | À prévoir | À prévoir | Moyen |
| Admin dashboard | Partiel | lib/features/admin | Hive | Local | À prévoir | Élevé |
| Consent / privacy | Partiel | lib/features/onboarding | À créer | À prévoir | À prévoir | Élevé |

## 8. Conclusion

Le projet a déjà une base utile et cohérente pour une première version exploratoire, mais il reste à professionnaliser les couches métier, sécurité et relations professionnelles. L’effort doit se concentrer sur les éléments à forte valeur métier et à fort impact sécurité.
