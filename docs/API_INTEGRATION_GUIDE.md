# Guide d'Intégration API - NeuroSync 4.0

Ce document détaille les endpoints nécessaires pour connecter le frontend Flutter au backend (Supabase ou API REST personnalisée).

## 1. Authentification & Profils
L'application utilise **Supabase Auth** par défaut. Les profils sont stockés dans une table `profiles`.

### `GET /profiles/{user_id}`
- **Usage** : Récupérer les données de l'utilisateur ou du professionnel.
- **Réponse** :
  ```json
  {
    "id": "uuid",
    "email": "user@example.com",
    "role": "user | psychologist | admin",
    "name": "Nom Complet",
    "wilaya_id": "w16",
    "status": "active | pending | approved",
    "pref_spiritual": true
  }
  ```

### `PUT /profiles/{user_id}`
- **Usage** : Mettre à jour la Wilaya, le nom ou les préférences.
- **Corps** : `Partial<Profile>`

---

## 2. Évaluation Adaptive

### `POST /assessments`
- **Usage** : Sauvegarder les résultats d'une session terminée.
- **Corps** :
  ```json
  {
    "user_id": "uuid",
    "answers": { "Q001": 2, "Q051": 4 },
    "identified_themes": ["high_need_stress", "moderate_need_sleep"],
    "orientation_level": "level3",
    "created_at": "iso_timestamp"
  }
  ```

### `GET /assessments/history?user_id={id}`
- **Usage** : Charger l'historique pour le graphique de progression.

---

## 3. Annuaire Professionnel

### `GET /wilayas`
- **Usage** : Récupérer la liste officielle des 58 wilayas.

### `GET /professionals?wilaya_id={id}&type={category}`
- **Usage** : Rechercher des experts vérifiés.
- **Réponse** : `List<ProfessionalModel>`

### `GET /centers?wilaya_id={id}`
- **Usage** : Liste des centres de santé mentale par wilaya.

---

## 4. Gestion des Demandes (Suivi)

### `POST /access_requests`
- **Usage** : Un patient demande à partager son dossier avec un psychologue.
- **Corps** :
  ```json
  {
    "user_id": "uuid",
    "professional_id": "uuid",
    "message": "Demande de suivi pour anxiété."
  }
  ```

### `PUT /access_requests/{request_id}`
- **Usage** : Le psychologue accepte (`status: accepted`) ou refuse (`status: rejected`).

---

## 5. Synchronisation Hors-ligne
L'application possède un `SyncService` qui utilise ces endpoints pour vider la file d'attente locale (Hive) vers le serveur dès que la connexion est rétablie.
