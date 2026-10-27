# SCHÉMA CLIENT - VUE PRÉSENTATION

```mermaid
flowchart LR
    A[Utilisateur] --> B[Créer compte]
    B --> C{Rôle}
    C -->|Patient| D[Choisir wilaya]
    C -->|Psychologue| E[Créer profil pro]
    C -->|Admin| F[Dashboard admin]

    D --> G[Voir psychologues de la wilaya]
    G --> H[Choisir psychologue]
    H --> I[Demander accès]
    I --> J[Psychologue valide]
    J --> K[Messagerie activée]

    E --> E1[Statut pending]
    E1 --> F1[Admin valide]
    F1 --> E2[Compte actif]
    E2 --> G

    D --> P1[Check-in émotionnel]
    P1 --> P2[Gain XP]
    P2 --> P3[Niveau + badge]
```

```mermaid
flowchart TB
    P[Patient] -->|recherche + accès| S[Psychologue]
    S -->|répond| P
    A[Admin] -->|validation| S
    P -->|progression| G[Gamification]
    G -->|badges + xp| P
```

## MISSION DU SYSTÈME

- Trouver le bon psychologue selon la wilaya
- Valider les comptes professionnels
- Sécuriser les accès
- Activer la messagerie uniquement après accord
- Suivre la progression du patient
- Motiver grâce aux badges et au niveau