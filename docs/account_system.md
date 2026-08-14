# Système Multi-Comptes NeuroSync 4.0

## 1. Vue d'ensemble
Le système gère quatre types de rôles avec une architecture "Offline-first" et une synchronisation mockée pour le prototype.

## 2. Rôles et Permissions
- **Guest** : Accès limité aux ressources et évaluation locale anonyme.
- **User** : Historique personnel, synchronisation, gestion de profil.
- **Psychologist** : Dashboard professionnel, accès aux patients sur consentement.
- **Admin** : Gestion des comptes, validation des psychologues, logs de sécurité.

## 3. Architecture Technique
- **Base de données** : Hive (Local Storage) pour les évaluations, le profil et la file d'attente de synchro.
- **Navigation** : GoRouter avec Route Guards pour protéger les zones sensibles.
- **Gestion d'état** : Riverpod pour l'authentification et les données.
- **Service Layer** : Repository Pattern permettant de basculer facilement vers un backend réel (Firebase/Supabase).

## 4. Fonctionnalités Clés
- **Migration Guest → User** : Les évaluations faites en mode visiteur sont automatiquement rattachées au compte lors de l'inscription.
- **Consentement Professionnel** : Système de `AccessRequest` permettant à l'utilisateur d'autoriser ou révoquer l'accès d'un psychologue à ses données.
- **Mode Hors-ligne** : Les évaluations sont sauvegardées localement et marquées pour synchronisation ultérieure.

## 5. Comptes de Test (Prototype)
- **Utilisateur** : `user@example.com`
- **Psychologue** : `psy@example.com`
- **Administrateur** : `admin@example.com`
*Note : Tout mot de passe est accepté dans le MockAuthService.*
