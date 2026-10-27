# Protection: état d’implémentation

Cette tranche ajoute un socle testable et local au projet existant.

## Fonctionnel

- Modèles immuables pour signalement, évaluation, orientation, consentement, plan de sécurité, partenaires et numéros vérifiés.
- Catégories de violence bilingues français/arabe standard, sans ajout de Darija.
- `ViolenceRiskEngine` avec cinq niveaux, priorité aux red flags et version des règles.
- Questions adaptatives non répétées, avec refus de réponse distinct d’un non.
- Boxes Hive chiffrées dédiées et repository local pour rapports et évaluations.
- Parcours UI protection, urgence, confidentialité, signalement et résultat, avec support RTL.
- Scénario interactif non diagnostique et accès à l’exercice de respiration existant.
- Tests unitaires ciblés du moteur de risque et du moteur adaptatif.

## Périmètre volontairement local

- Aucun numéro d’urgence, professionnel ou partenaire n’est inventé; la configuration officielle reste à fournir.
- Aucun backend ni aucune synchronisation serveur ne sont prévus dans cette version. Les signalements et évaluations restent sur l’appareil, dans Hive chiffré.
- La permission microphone, l’espace professionnel complet, l’espace administrateur spécialisé, les statistiques anonymisées et les migrations Hive dédiées restent à intégrer.
- La validation juridique et la vérification des ressources doivent être réalisées par l’organisation responsable.
- `flutter analyze` et `flutter test` n’ont pas pu être exécutés dans l’environnement courant: ni `flutter` ni `dart` ne sont présents dans le `PATH`. Les diagnostics IDE des fichiers modifiés ne signalent aucune erreur.