# NeuroSync 4.0 (SIND) - Outil d'Expertise en Santé Mentale

NeuroSync est une plateforme d'expertise clinique et de repérage précoce conçue pour offrir un accompagnement personnalisé en santé mentale. L'application combine des outils psycho-métriques modernes avec une approche culturelle et spirituelle (Médecine Prophétique), tout en garantissant un anonymat total pour les visiteurs.

## 🏗 Architecture du Projet

Le projet suit une architecture modulaire basée sur les **Features** (Clean Architecture simplifiée) :

- **`lib/core/`** : Noyau de l'application (Thème, Configuration, Authentification, Internationalisation, Services de synchronisation).
- **`lib/features/`** :
    - **`adaptive_assessment/`** : Moteur de questionnaire adaptatif (`AdaptiveQuestionEngine`) et calcul des résultats.
    - **`auth/`** : Gestion de la connexion et de l'inscription (Utilisateur / Expert).
    - **`dashboard/`** : Hub central personnalisé selon le profil (Visiteur, Patient, Psychologue, Admin).
    - **`professional/`** : Annuaire des professionnels, centres et gestion des demandes de suivi.
    - **`wellness/`** : Exercices de respiration, journal de confiance et soutien spirituel.
    - **`health/`** : Bibliothèque de connaissances sur la nutrition et la santé.
- **`lib/l10n/`** : Fichiers de traduction ARB (Français / Arabe) gérant le support RTL complet.

## 🔄 Workflow de l'Application

### 1. Accueil & Onboarding
- **Changement de Langue** : Sélection entre Français et Arabe (Standard + Darja en sous-titre). Le passage à l'arabe active automatiquement le mode **RTL (Right-to-Left)**.
- **Accès Visiteur** : Permet d'utiliser les outils d'évaluation et de consulter l'annuaire sans compte.
- **Authentification** : Connexion sécurisée pour les patients et validation manuelle par l'admin pour les psychologues.

### 2. Évaluation Adaptive (Cœur du projet)
- Le questionnaire ajuste dynamiquement les questions posées en fonction des réponses précédentes pour cibler les axes en tension (Humeur, Stress, Sommeil, etc.).
- **Mots Scientifiques** : Utilisation de termes cliniques (*Anhédonie*, *Ruminations*, *Asthénie*) pour une approche professionnelle.

### 3. Synthèse & Orientation
- **Profil Clinique** : Analyse transversale des indicateurs avec graphiques de besoins.
- **Plan 7 Jours** : Micro-actions quotidiennes recommandées.
- **Soutien Spirituel** : Versets et Hadiths sélectionnés selon l'état émotionnel.
- **Niveaux d'Orientation** : Du "Maintien de l'équilibre" à l' "Urgence Psychiatrique".

### 4. Annuaire & Ressources
- Recherche par **Wilaya** (58 Wilayas d'Algérie couvertes).
- Filtrage par type de service (Urgence, Écoute, Centres).
- Mise en relation directe via WhatsApp ou Téléphone.

## 🚀 Guide d'Installation

### Prérequis
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### Étapes
1. **Récupérer les dépendances** :
   ```bash
   flutter pub get
   ```
2. **Générer les fichiers de localisation** :
   ```bash
   flutter gen-l10n
   ```
3. **Lancer l'application** :
   ```bash
   flutter run
   ```

## 🛠 Technologies Utilisées
- **State Management** : Riverpod
- **Local Database** : Hive (avec chiffrement pour les données sensibles)
- **Backend** : Supabase (Authentification et Synchronisation)
- **UI/UX** : Flutter Animate, Lucide Icons, Design System "Sind" sur-mesure.

---
*Note : Cette application est un outil d'aide à l'orientation et ne remplace pas un diagnostic clinique officiel.*
