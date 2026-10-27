# Gouvernance du pilote institutionnel local

## Périmètre réel

Cette configuration protège les données stockées sur un appareil de confiance : Hive est chiffré avec une clé conservée dans le stockage sécurisé de l'appareil. Elle convient uniquement à un pilote interne hors ligne, administré sur un équipement institutionnel contrôlé.

Elle ne constitue pas une architecture de production publique. Une personne ayant le contrôle de l'appareil, de sa sauvegarde ou de son stockage sécurisé peut contourner les garanties locales. Les validations enregistrées sont donc des traces de pilotage, pas des signatures institutionnelles opposables.

## Comptes et contrôles disponibles

- Les professionnels inscrits restent `pending` jusqu'à une décision administrative.
- L'administrateur peut activer ou suspendre un compte.
- L'administrateur peut délivrer un mot de passe temporaire d'au moins 12 caractères. Le mot de passe n'est ni stocké dans Hive ni écrit dans le journal. L'utilisateur doit ensuite le modifier depuis son profil.
- L'administrateur peut imposer un second code local de 6 à 10 chiffres. Ce code est vérifié à la connexion et son empreinte est conservée dans le stockage sécurisé.
- Les connexions, échecs de MFA, enregistrements, changements de mot de passe, changements de statut et décisions de validation sont ajoutés au journal d'audit.
- Le journal ne peut plus être vidé depuis l'application.

## Procédure avant tout pilote

1. Désigner un administrateur nommé et conserver le compte administrateur hors de l'usage quotidien.
2. Faire valider séparément les volets juridique, médical et institutionnel par les responsables compétents.
3. Dans **Administration > Paramètres globaux > Validation institutionnelle**, enregistrer pour chaque volet le nom du valideur et une référence de décision (numéro, date, procès-verbal ou note signée).
4. Ne pas ouvrir l'accès public tant que les trois statuts ne sont pas validés. Le tableau affiche explicitement le blocage tant qu'une validation manque.
5. Donner les mots de passe temporaires et les codes MFA par un canal séparé, jamais dans les notes d'audit, SMS non sécurisé ou captures d'écran.
6. Exporter ou archiver périodiquement le journal selon la règle de conservation décidée par l'institution. La présente application ne fournit pas encore d'archivage signé.

## Conditions non négociables pour une production publique

- Serveur d'identité et base de données contrôlés par l'institution ; contrôle des rôles côté serveur.
- Réinitialisation de mot de passe avec preuve de possession et expiration des jetons.
- MFA fondée sur un authentificateur standard (TOTP/WebAuthn) ou un fournisseur institutionnel, jamais sur un code géré dans la même application.
- Journaux centralisés, horodatés, immuables et exportables.
- Signatures ou procédures formelles de validation juridique, médicale et de protection des données.
- Tests de sécurité, sauvegardes, gestion d'incident, supervision et revue complète des contenus FR/AR.
