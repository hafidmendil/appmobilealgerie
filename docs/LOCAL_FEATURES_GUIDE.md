# Guide des Fonctionnalités Locales (NeuroSync)

Ce document résume les fonctionnalités avancées implémentées en mode local pour le test et la démonstration.

## 1. Gamification
- **Système d'XP** : Les utilisateurs gagnent des points XP en effectuant des évaluations, en discutant avec le compagnon et en complétant des objectifs.
- **Niveaux** : Le niveau de l'utilisateur augmente tous les 500 XP.
- **Badges** : Système de badges (statique pour le moment) visible dans l'écran de progrès.
- **Persistance** : Toutes les données sont sauvegardées localement via Hive dans `user_stats_box`.

## 2. Compagnon IA Amélioré
- **Interface Chat** : Design épuré avec animations `flutter_animate`.
- **Logique Intelligente** :
    - Réponses basées sur des mots-clés (stress, tristesse).
    - **Proactivité** : Si une évaluation récente montre un besoin élevé (Sommeil ou Productivité), le compagnon propose des conseils spécifiques dès le début.
    - **Engagement** : Chaque interaction rapporte 10 XP.

## 3. Dashboard Professionnel
- **Header Dynamique** : Affiche le niveau de l'utilisateur.
- **Radar de Besoins** : Graphique en barres interactif (`fl_chart`) montrant les axes de besoin actuels.
- **Insight IA** : Une carte générée dynamiquement qui résume l'état actuel de l'utilisateur.

## 4. Analytics et Reporting
- **Radar Chart** : Visualisation globale de l'équilibre psychologique.
- **Détails par Axe** : Barres de progression détaillées pour chaque dimension (`AssessmentAxis`).
- **Mode Rapport** : Bouton prêt pour l'exportation de rapport PDF.

---
**Note technique** : Ces fonctionnalités utilisent Riverpod pour la gestion d'état et Hive pour la persistence locale. Aucun backend réel n'est requis pour cette phase de test.
