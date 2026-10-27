# Audit linguistique et qualité de contenu

## Verdict

L'application prend en charge le français et l'arabe via les catalogues ARB et les délégués Flutter. Les parcours corrigés respectent maintenant la langue active. L'application ne peut cependant pas être déclarée entièrement bilingue ni prête pour diffusion institutionnelle : plusieurs écrans secondaires conservent des textes français codés en dur et le corpus santé ne dispose pas encore de traductions arabes complètes.

## Contrôles réalisés

| Contrôle | Résultat |
| --- | --- |
| Marqueurs de traduction `[AR]` | 0 restant |
| Clés dupliquées dans `app_fr.arb` et `app_ar.arb` | 0 |
| Génération `flutter gen-l10n` | Réussie |
| Analyse des écrans modifiés | 0 erreur de compilation |
| Suite `flutter test` | 19 tests affichés, tous passants |

## Correctifs appliqués

- Traduction arabe de tous les libellés auparavant marqués provisoires.
- Libellés FR/AR centralisés pour l'orientation, les wilayas, la messagerie, la sécurité, le journal de confiance, la santé, la progression, l'analytique et les tableaux professionnels.
- Wilaya : une seule appellation est affichée, française ou arabe selon la locale, au lieu de deux lignes mélangées.
- Compagnon : accueil, saisie, suggestions et réponses suivent la locale. Les citations utilisent `textFr` en français et `textAr` en arabe.
- Statuts de demandes de rendez-vous : localisation des valeurs techniques de l'énumération (`PENDING`, `ACCEPTED`, etc.).
- Articles santé : la page arabe ne mélange plus un titre arabe avec un article français. L'absence actuelle de traduction est annoncée explicitement en arabe.

## Restes à traiter

L'inventaire par recherche statique contient encore 116 candidats de chaînes visibles. Ce nombre inclut des identifiants et des exemples, mais révèle un travail de centralisation encore nécessaire.

| Zone | Problème | Action requise |
| --- | --- | --- |
| Juridique | Plusieurs résultats présentent simultanément un titre arabe et une description française. | Sélectionner systématiquement `titleFr/descriptionFr` ou `titleAr/descriptionAr` selon la locale. |
| Administration | Formulaires et libellés métier sont majoritairement écrits directement en français. | Ajouter des clés ARB et vérifier l'interface arabe. |
| Santé | Les modèles ne stockent qu'un `arabicTitle`; description, bienfaits, précautions et synthèses sont français. | Étendre le modèle avec champs arabes, traduire et faire migrer les données Hive. |
| Professionnels | Certains messages d'erreur et écrans de détail gardent du français en dur. | Centraliser les messages et les statuts restants. |
| Contenu éditorial | Traductions, références et validation médicale ne sont pas tracées par version. | Mettre en place une relecture humaine FR/AR, un statut de validation et une date de révision. |

## Conditions de validation professionnelle

1. Aucun texte visible ne doit être directement écrit dans un widget ; il doit provenir d'ARB ou d'une donnée éditoriale localisée.
2. Toute donnée affichée doit posséder une variante française et arabe, sans repli silencieux dans l'autre langue.
3. Les écrans clés doivent être testés manuellement en LTR et RTL : inscription, orientation, évaluation, sécurité, santé, messagerie, rendez-vous et paramètres.
4. Les contenus santé, spirituels et juridiques doivent être relus et approuvés par les responsables compétents avant publication.
5. La dette signalée par `flutter analyze` doit être réduite avant livraison : 490 avertissements/informations à la dernière analyse complète.

## Limites fonctionnelles importantes

Cette correction améliore la cohérence de langue, mais elle ne transforme pas l'application locale en service institutionnel complet. L'authentification et les autorisations restent locales à l'appareil, le backend actif n'est pas vérifié, la réinitialisation de mot de passe et les notifications réelles ne sont pas implémentées. Ces éléments doivent être résolus indépendamment avant toute mise en production.
