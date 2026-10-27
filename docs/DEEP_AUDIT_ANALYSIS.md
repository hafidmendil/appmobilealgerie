# Analyse approfondie — état réel de NeuroSync

Date de l'analyse : 1 septembre 2026.

## Verdict

**PARTIALLY FUNCTIONAL.**

L'application est un prototype Flutter local cohérent sur plusieurs parcours : évaluation adaptative, persistance Hive, protection/orientation, recherche de professionnels et administration locale. Elle n'est pas prête à gérer de vrais comptes, des données de santé ou des signalements réels en production.

La distinction est importante : les écrans et les flux locaux peuvent fonctionner, mais il n'existe pas de backend autoritaire opérationnel, de récupération de compte vérifiée, de notifications natives, de preuve d'identité des professionnels ni de validation sur appareils réels.

## 1. Méthode et périmètre

- Lecture de l'architecture Flutter, des services, repositories, modèles, providers, routes et données locales.
- Cartographie statique de **69 déclarations GoRoute** (routes imbriquées comprises).
- Exécution de `flutter analyze` et de `flutter test`.
- **38 tests unitaires** exécutés avec succès ; **0 test widget** et **0 test d'intégration**.
- Vérification des flux critiques de semis/connexion professionnelle, suspension de compte, migration, sécurité des moteurs d'orientation et protection.

Une route lue ou compilée n'est pas considérée comme validée visuellement sur Android/iOS/Web. Aucun émulateur ni appareil réel n'a été utilisé dans cette passe.

## 2. Architecture observée

| Couche | Implémentation | Évaluation |
|---|---|---|
| Interface | Flutter Material, composants SIND, localisation FR/AR | Fonctionnelle, mais traduction incomplète |
| État | Riverpod `Provider` / `StateNotifier` | Architecture globalement lisible |
| Navigation | `go_router` avec redirections par rôle | Gardes principales présentes |
| Données | Hive + `flutter_secure_storage` + `SharedPreferences` | Locale et offline ; non suffisante pour production clinique |
| Authentification | `HiveAuthRepository` via `HybridAuthService` | Authentification locale, pas un service d'identité distant |
| Moteurs métier | Évaluation adaptative, sécurité, protection, orientation juridique | Tests unitaires significatifs |
| Réseau | Interfaces/API présentes, mais les flux actifs sont locaux | Intégration distante non validée |

## 3. Routes et contrôle d'accès

### Couverture

- Administration : 12 routes ou sous-routes.
- Protection : 12 routes.
- Juridique : 5 routes.
- Santé : route parente avec article et quiz paramétrés.
- Parcours transversal : accueil, invité, orientation, évaluation, résultat, profil, ressources, progression, professionnels et messagerie.

### Ce qui est correctement protégé

- `/admin/*` exige le rôle `admin`.
- `/psychologist/*` exige le rôle `psychologist`.
- `/user` exige le rôle `user`.
- `/session-request` exige le rôle `user`.
- Un utilisateur non authentifié est redirigé hors des espaces privés.
- Les comptes `suspended` ou non actifs ne peuvent plus conserver un accès : ils sont dirigés vers `/account-disabled`.
- Les routes dépendant de `state.extra` affichent maintenant une reprise utilisateur au lieu d'un cast qui plante.
- Une route non trouvée affiche une page de récupération.

### Limites à corriger

1. Les autorisations sont **côté client uniquement**. Modifier le stockage local sur un appareil compromis peut contourner une garde locale. Un vrai backend doit toujours revérifier rôle, statut et propriété de donnée.
2. Beaucoup de routes de bien-être sont publiques par intention. C'est acceptable pour du contenu général, mais toute future donnée personnelle doit rester exclue des routes publiques.
3. La route de résultats repose sur l'état Riverpod en mémoire. Après fermeture de l'app ou lien direct, la synthèse complète n'est pas reconstituée depuis Hive.
4. Les rôles et statuts utilisent des chaînes libres (`active`, `approved`, `pending`, `suspended`). Des enums centralisés réduiraient les incohérences.

## 4. Authentification et comptes

### Fonctionnel localement

- Inscription utilisateur et professionnel.
- Normalisation de l'e-mail à l'inscription et à la connexion.
- Sessions locales stockées dans Hive.
- Comptes professionnels semés et profils Hive persistants.
- Compte professionnel approuvé testé : connexion réussie.
- Compte suspendu testé : connexion refusée.
- Les mots de passe et hashes ne sont plus journalisés.

### Risques critiques de production

| Gravité | Constat | Conséquence |
|---|---|---|
| P0 | Le mot de passe de démonstration `NeuroSync2024!` est dans le code et appliqué aux comptes semés. | Accès trivial aux comptes locaux semés. |
| P0 | La vérification est un SHA-256 simple sans sel ni algorithme de dérivation lent. | Protection insuffisante contre l'extraction et les attaques hors ligne. |
| P0 | Aucun serveur d'identité ne valide rôle, statut, compte supprimé ou sessions. | Le modèle de permission ne peut pas être fiable contre un client modifié. |
| P1 | La réinitialisation de mot de passe est volontairement refusée faute de canal sûr. | Correct du point de vue sécurité, mais parcours utilisateur incomplet. |
| P1 | La vérification e-mail active localement un compte sans preuve externe. | Ne doit pas être appelée « vérification e-mail » en production. |

### Recommandation

Ne pas distribuer les comptes semés. Mettre en place OAuth/OIDC ou un backend d'authentification avec mots de passe dérivés côté serveur (Argon2id/bcrypt/scrypt), rate limiting, réinitialisation par lien à durée limitée, rotation/révocation de session et journal d'audit serveur.

## 5. Données, persistance et suppression

### Ce qui persiste réellement

- Évaluations : Hive, associées à l'identifiant local de l'utilisateur.
- Profils professionnels, demandes d'accès, demandes de séance et messages : Hive.
- Progression et humeur : Hive/paramètres, désormais séparées par utilisateur.
- Contenu santé, juridique et protection : boxes Hive locales.
- Langue, thème et préférence de rappel : stockage local.

### Problème historique Hive corrigé

Deux IDs de TypeAdapter étaient dupliqués : `ProfessionalProfile` utilisait 7 (déjà utilisé par `SyncItem`) et `UserStats` utilisait 20 (déjà utilisé par `EvidenceLevel`). Hive ne pouvait donc pas sérialiser ces objets. Les IDs sont désormais 26 et 27 ; aucune collision ne subsiste dans les modèles détectés.

La migration v3 marque le schéma, mais elle **ne transforme pas** de données anciennes encodées avec les IDs erronés. Cela doit être testé sur une copie de vraies données d'un appareil avant diffusion d'une mise à jour.

### Droit à l'effacement : partiellement traité

La suppression de compte ne vide plus la base entière. Elle cible les évaluations, relations, messages, profil professionnel, sessions, progression et secret du compte courant.

Elle ne couvre pas encore explicitement tous les emplacements potentiellement liés à l'utilisateur : rapports de protection, évaluations/consentements/brouillons juridiques, entrées de confiance, progression santé, préférences et certains éléments de settings. Le bouton « supprimer mes données » ne peut donc pas encore promettre un effacement exhaustif.

## 6. Évaluation, sécurité et résultats

### Points validés

- Le moteur de sécurité donne priorité à un red flag urgent.
- Le moteur adaptatif ne répète pas les questions déjà traitées dans les cas testés.
- Les scénarios de niveaux faible, modéré, élevé et urgent sont testés.
- Les textes de résultat présentent l'orientation comme indicative et non comme un diagnostic.
- Les moteurs juridique et protection disposent de tests unitaires de base.

### Écart fonctionnel majeur

La persistance enregistre principalement réponses, indicateurs de sécurité, date et message final. Le `AssessmentResult` complet (niveau d'orientation, besoins par axe, recommandations et justifications) reste surtout en mémoire. L'historique peut confirmer qu'une évaluation existe, mais ne sait pas encore reconstruire une fiche de résultats complète et déterministe après redémarrage.

Pour corriger : faire évoluer le modèle persistant ou créer une table de résultats versionnée, conserver le moteur/la version de règles, puis ajouter une route `history/:id` qui recharge et affiche le résultat enregistré.

## 7. Protection, signalement et juridique

### Ce qui fonctionne localement

- Questionnaire de protection et calcul de priorité.
- Enregistrement local chiffré de rapports et d'évaluations de risque.
- Orientation vers urgence ou ressources selon le niveau.
- Consentement et génération de brouillons juridiques locaux.

### Ce qui ne doit pas être présenté comme un service opérationnel

- Le signalement est stocké **sur l'appareil** ; il n'est pas transmis à une autorité, un professionnel ou un centre.
- Des éléments de l'outil local et l'analyse vocale sont explicitement simulés dans le code. Ils ne doivent jamais être utilisés pour prendre une décision clinique, juridique ou d'urgence.
- Les contenus juridiques sont locaux et doivent être validés, sourcés et maintenus par un juriste compétent.
- Les annuaires et partenaires semés demandent une vérification administrative, consentement, date de mise à jour et processus de retrait.

## 8. Localisation et accessibilité

- FR et AR sont configurées et un nouveau libellé de réessai est généré dans les deux langues.
- **67 marqueurs `[AR]`** restent dans la ressource arabe : ce sont des traductions provisoires, pas une version arabe livrable.
- **82 chaînes visibles codées en dur** ont été détectées dans les features ; elles contournent la localisation.
- RTL, tailles dynamiques, contraste et lecteur d'écran n'ont pas été validés sur appareils.

Priorité : achever la traduction arabe par un locuteur qualifié, éliminer les chaînes hardcodées, puis ajouter des tests de rendu LTR/RTL et petit écran.

## 9. Notifications, réseau et liens externes

- La préférence de rappel est maintenant persistante, mais aucun scheduler ni plugin de notification locale/push ne crée de notification.
- `connectivity_plus`, `http`, `url_launcher`, PDF et partage sont déclarés, mais ne prouvent pas une intégration de production.
- Une URL API HTTP (`http://neurosync-api.infinityfreeapp.com/api`) existe : aucune donnée sensible ne doit transiter par HTTP.
- Les liens téléphone, carte, WhatsApp et vidéo dépendent d'applications/services externes et n'ont pas été validés sur terminal.

## 10. Qualité et tests

| Indicateur | Résultat |
|---|---|
| Analyse statique | 0 erreur de compilation ; 490 avertissements/informations |
| Tests exécutés | 38/38 réussis |
| Tests widget | 0 |
| Tests d'intégration | 0 |
| Test appareil réel | Non effectué |
| Test accessibilité / RTL | Non effectué |

Les 490 remarques sont majoritairement des imports inutilisés, API Flutter dépréciées et améliorations de style. Certaines méritent cependant correction car elles signalent du code mort dans l'évaluation et la recherche professionnelle.

## 11. Risques de publication Android/iOS

- L'identifiant Android est encore le défaut `com.example.projetmascara` dans le Gradle.
- Aucune preuve de configuration de signature, versionning de release, politique de confidentialité distribuée, consentement légal, support, crash reporting ou surveillance n'a été trouvée dans la validation exécutée.
- La présence de données sensibles et d'orientation nécessite une revue légale, clinique et sécurité indépendante avant distribution.

## 12. Plan réaliste avant production

1. **P0 — Sécurité serveur :** retirer les comptes/mots de passe semés, imposer HTTPS, backend d'identité et autorisations côté serveur.
2. **P0 — Données sensibles :** définir le registre de traitements, consentement, durée de conservation, export/suppression complète et journal d'audit serveur.
3. **P1 — Résultats :** persister et versionner les résultats complets, avec historique détaillé par utilisateur.
4. **P1 — Intégrations :** connecter et tester réellement notifications, demandes de séance, messagerie, transmission de signalement et annuaire vérifié.
5. **P1 — Qualité :** tests widget, tests intégration multi-rôle, tests de deep links et d'appareil réel.
6. **P2 — Internationalisation :** achever AR/RTL et retirer les chaînes codées en dur.
7. **P2 — Release :** applicationId, signatures, gestion d'erreurs centralisée, politique de confidentialité et observabilité.

## Conclusion

Le prototype local est désormais plus robuste qu'à l'état initial : l'enregistrement Hive critique, la connexion professionnelle, la suspension, les liens incomplets, l'historique de base et plusieurs préférences ont été corrigés et testés. Le risque résiduel est cependant incompatible avec une mise en production pour des données sensibles. La prochaine étape doit être une phase dédiée de backend sécurisé, conformité et tests d'intégration, pas uniquement des améliorations visuelles.
