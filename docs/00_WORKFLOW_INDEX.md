# INDEX DES SCHÉMAS

```mermaid
flowchart TB
    A[APP]
    A --> B[Patient]
    A --> C[Psychologue]
    A --> D[Admin]

    B --> B1[Inscription]
    B --> B2[Choix wilaya]
    B --> B3[Recherche]
    B --> B4[Demande d'accès]
    B --> B5[Messagerie]
    B --> B6[Progression]

    C --> C1[Inscription]
    C --> C2[Pending]
    C --> C3[Validation Admin]
    C --> C4[Actif]
    C --> C5[Patients]
    C --> C6[Chat]

    D --> D1[Valider psycho]
    D --> D2[Approuver / refuser]
    D --> D3[Contrôler accès]

    B4 --> C5
    C3 --> C4
    B5 --> C6
    B6 --> B7[XP / niveau / badges]
```

## FICHIERS

- [01_WORKFLOW_ORGANIGRAMME.md](01_WORKFLOW_ORGANIGRAMME.md) — vue globale visuelle
- [02_WORKFLOW_PRESENTATION_CLIENT.md](02_WORKFLOW_PRESENTATION_CLIENT.md) — vue client / présentation
- [03_WORKFLOW_ETATS_COMPTES.md](03_WORKFLOW_ETATS_COMPTES.md) — états des comptes
- [04_WORKFLOW_PROGRESSION_BADGES.md](04_WORKFLOW_PROGRESSION_BADGES.md) — progression / badges / humeur

## RELATION PRINCIPALE

```mermaid
flowchart LR
    PATIENT[Patient] -->|demande accès| PSYCHO[Psychologue]
    PSYCHO -->|accepte / refuse| PATIENT
    ADMIN[Admin] -->|valide compte| PSYCHO
    PATIENT -->|check-in + xp| PROG[Progression]
    PROG -->|badge + niveau| PATIENT
```