import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'NeuroSync 4.0'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Outil d\'expertise en repérage précoce et orientation.'**
  String get welcomeMessage;

  /// No description provided for @startAssessment.
  ///
  /// In fr, this message translates to:
  /// **'Lancer l\'expertise'**
  String get startAssessment;

  /// No description provided for @languageSelection.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageSelection;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Professionnelle'**
  String get login;

  /// No description provided for @register.
  ///
  /// In fr, this message translates to:
  /// **'Créer un profil'**
  String get register;

  /// No description provided for @continueAsGuest.
  ///
  /// In fr, this message translates to:
  /// **'Accès Visiteur Anonyme'**
  String get continueAsGuest;

  /// No description provided for @professionalAccount.
  ///
  /// In fr, this message translates to:
  /// **'Expert / Psychologue'**
  String get professionalAccount;

  /// No description provided for @userAccount.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get userAccount;

  /// No description provided for @assessmentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bilan de Santé Mentale'**
  String get assessmentTitle;

  /// No description provided for @resultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Synthèse et Orientation'**
  String get resultsTitle;

  /// No description provided for @reportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compte Rendu Clinique'**
  String get reportTitle;

  /// No description provided for @recommendations.
  ///
  /// In fr, this message translates to:
  /// **'Préconisations Thérapeutiques'**
  String get recommendations;

  /// No description provided for @privacyPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Politique de Confidentialité'**
  String get privacyPolicy;

  /// No description provided for @resources.
  ///
  /// In fr, this message translates to:
  /// **'Annuaire des Ressources'**
  String get resources;

  /// No description provided for @q_safety_immediate_harm.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous un besoin urgent d\'aide pour ne pas vous faire du mal ou en faire à autrui ?'**
  String get q_safety_immediate_harm;

  /// No description provided for @q_safety_red_flag_loss_control.
  ///
  /// In fr, this message translates to:
  /// **'Craignez-vous une perte d\'autocontrôle imminente ?'**
  String get q_safety_red_flag_loss_control;

  /// No description provided for @q_phq_anxiety.
  ///
  /// In fr, this message translates to:
  /// **'Au cours des 2 dernières semaines, avez-vous eu du mal à vous détendre ?'**
  String get q_phq_anxiety;

  /// No description provided for @q_phq_depression.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes-vous senti triste, sans espoir ou dévalorisé ?'**
  String get q_phq_depression;

  /// No description provided for @q_phq_pleasure.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous eu peu d\'intérêt ou de plaisir à faire les choses ?'**
  String get q_phq_pleasure;

  /// No description provided for @q_phq_nervous.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes-vous senti nerveux, anxieux ou sur le qui-vive ?'**
  String get q_phq_nervous;

  /// No description provided for @q_stress_tension.
  ///
  /// In fr, this message translates to:
  /// **'Évaluez votre niveau de tension intérieure globale.'**
  String get q_stress_tension;

  /// No description provided for @q_stress_irritability.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous une irritabilité inhabituelle ?'**
  String get q_stress_irritability;

  /// No description provided for @q_stress_physical.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous des symptômes physiques de stress (maux de tête, tensions musculaires) ?'**
  String get q_stress_physical;

  /// No description provided for @q_sleep_difficulty.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous des difficultés persistantes de sommeil ?'**
  String get q_sleep_difficulty;

  /// No description provided for @q_sleep_impact.
  ///
  /// In fr, this message translates to:
  /// **'Votre fatigue impacte-t-elle votre fonctionnement diurne ?'**
  String get q_sleep_impact;

  /// No description provided for @q_sleep_early_wake.
  ///
  /// In fr, this message translates to:
  /// **'Vous arrive-t-il de vous réveiller trop tôt sans pouvoir vous rendormir ?'**
  String get q_sleep_early_wake;

  /// No description provided for @q_func_concentration.
  ///
  /// In fr, this message translates to:
  /// **'Votre capacité de concentration est-elle altérée ?'**
  String get q_func_concentration;

  /// No description provided for @q_func_daily_tasks.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous des difficultés à accomplir vos tâches quotidiennes habituelles ?'**
  String get q_func_daily_tasks;

  /// No description provided for @q_rel_tension.
  ///
  /// In fr, this message translates to:
  /// **'Vivez-vous des tensions conflictuelles majeures ?'**
  String get q_rel_tension;

  /// No description provided for @q_rel_isolation.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous un besoin de retrait social total ?'**
  String get q_rel_isolation;

  /// No description provided for @q_rel_support.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous le sentiment de pouvoir compter sur un proche ?'**
  String get q_rel_support;

  /// No description provided for @q_rel_loneliness.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous un sentiment profond de solitude même entouré ?'**
  String get q_rel_loneliness;

  /// No description provided for @q_gen_wellbeing.
  ///
  /// In fr, this message translates to:
  /// **'Comment vous sentez-vous globalement en ce moment ?'**
  String get q_gen_wellbeing;

  /// No description provided for @q_gen_stress_level.
  ///
  /// In fr, this message translates to:
  /// **'Sur une échelle de 0 à 10, quel est votre niveau de stress actuel ?'**
  String get q_gen_stress_level;

  /// No description provided for @why_gen_wellbeing.
  ///
  /// In fr, this message translates to:
  /// **'Cette question permet de situer votre état émotionnel général avant d\'aborder des points spécifiques.'**
  String get why_gen_wellbeing;

  /// No description provided for @why_q_gen_wellbeing.
  ///
  /// In fr, this message translates to:
  /// **'Cette question permet de situer votre état émotionnel général avant d\'aborder des points spécifiques.'**
  String get why_q_gen_wellbeing;

  /// No description provided for @why_gen_stress.
  ///
  /// In fr, this message translates to:
  /// **'Le stress impacte directement votre santé physique et mentale.'**
  String get why_gen_stress;

  /// No description provided for @why_q_gen_stress.
  ///
  /// In fr, this message translates to:
  /// **'Le stress impacte directement votre santé physique et mentale.'**
  String get why_q_gen_stress;

  /// No description provided for @why_q_emotions_mood.
  ///
  /// In fr, this message translates to:
  /// **'L\'humeur générale est un indicateur de base pour comprendre votre état émotionnel actuel.'**
  String get why_q_emotions_mood;

  /// No description provided for @why_q_emotions_sadness.
  ///
  /// In fr, this message translates to:
  /// **'La tristesse inexpliquée peut être un signe de surcharge émotionnelle.'**
  String get why_q_emotions_sadness;

  /// No description provided for @why_q_emotions_interest.
  ///
  /// In fr, this message translates to:
  /// **'La perte de plaisir est un signe important d\'épuisement émotionnel.'**
  String get why_q_emotions_interest;

  /// No description provided for @why_q_stress_tension.
  ///
  /// In fr, this message translates to:
  /// **'Les tensions physiques sont souvent le premier signal d\'alarme du corps.'**
  String get why_q_stress_tension;

  /// No description provided for @why_q_sleep_quality.
  ///
  /// In fr, this message translates to:
  /// **'Un sommeil réparateur est le pilier de la régulation émotionnelle.'**
  String get why_q_sleep_quality;

  /// No description provided for @why_q_productivity_focus.
  ///
  /// In fr, this message translates to:
  /// **'La concentration reflète la disponibilité de vos ressources cognitives.'**
  String get why_q_productivity_focus;

  /// No description provided for @why_q_social_support.
  ///
  /// In fr, this message translates to:
  /// **'Le soutien social est le principal facteur de protection contre le stress.'**
  String get why_q_social_support;

  /// No description provided for @why_q_self_confidence.
  ///
  /// In fr, this message translates to:
  /// **'L\'auto-compassion réduit l\'impact des échecs perçus.'**
  String get why_q_self_confidence;

  /// No description provided for @q_soc_support.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous des personnes sur qui compter en cas de difficulté ?'**
  String get q_soc_support;

  /// No description provided for @q_econ_stability.
  ///
  /// In fr, this message translates to:
  /// **'Votre situation financière actuelle est-elle source d\'inquiétude ?'**
  String get q_econ_stability;

  /// No description provided for @q_cog_blame.
  ///
  /// In fr, this message translates to:
  /// **'Pensez-vous que les autres cherchent délibérément à vous nuire ?'**
  String get q_cog_blame;

  /// No description provided for @q_cog_control.
  ///
  /// In fr, this message translates to:
  /// **'Éprouvez-vous des difficultés à inhiber vos impulsions ?'**
  String get q_cog_control;

  /// No description provided for @q_cog_negative_bias.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous tendance à n\'interpréter que le côté négatif des événements ?'**
  String get q_cog_negative_bias;

  /// No description provided for @q_trauma_flashbacks.
  ///
  /// In fr, this message translates to:
  /// **'Des souvenirs douloureux s\'imposent-ils à vous brusquement ?'**
  String get q_trauma_flashbacks;

  /// No description provided for @q_trauma_avoidance.
  ///
  /// In fr, this message translates to:
  /// **'Évitez-vous activement certains lieux ou discussions liés au passé ?'**
  String get q_trauma_avoidance;

  /// No description provided for @q_trauma_nightmares.
  ///
  /// In fr, this message translates to:
  /// **'Faites-vous des cauchemars répétés liés à des événements marquants ?'**
  String get q_trauma_nightmares;

  /// No description provided for @q_future_hopelessness.
  ///
  /// In fr, this message translates to:
  /// **'Comment envisagez-vous votre avenir à court terme ?'**
  String get q_future_hopelessness;

  /// No description provided for @opt_never.
  ///
  /// In fr, this message translates to:
  /// **'Jamais'**
  String get opt_never;

  /// No description provided for @opt_sometimes.
  ///
  /// In fr, this message translates to:
  /// **'Parfois'**
  String get opt_sometimes;

  /// No description provided for @opt_often.
  ///
  /// In fr, this message translates to:
  /// **'Fréquemment'**
  String get opt_often;

  /// No description provided for @opt_always.
  ///
  /// In fr, this message translates to:
  /// **'Systématiquement'**
  String get opt_always;

  /// No description provided for @opt_yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get opt_yes;

  /// No description provided for @opt_no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get opt_no;

  /// No description provided for @explanation.
  ///
  /// In fr, this message translates to:
  /// **'Analyse du Profil'**
  String get explanation;

  /// No description provided for @level1Title.
  ///
  /// In fr, this message translates to:
  /// **'Équilibre Fonctionnel'**
  String get level1Title;

  /// No description provided for @level2Title.
  ///
  /// In fr, this message translates to:
  /// **'Vigilance Modérée'**
  String get level2Title;

  /// No description provided for @level3Title.
  ///
  /// In fr, this message translates to:
  /// **'Alerte Clinique'**
  String get level3Title;

  /// No description provided for @level4Title.
  ///
  /// In fr, this message translates to:
  /// **'Urgence Prioritaire'**
  String get level4Title;

  /// No description provided for @summary_urgent_help.
  ///
  /// In fr, this message translates to:
  /// **'Votre sécurité est notre priorité. Contactez immédiatement un service d\'aide.'**
  String get summary_urgent_help;

  /// No description provided for @summary_contact_recommended.
  ///
  /// In fr, this message translates to:
  /// **'Plusieurs indicateurs sont élevés. Un contact rapide avec un professionnel est recommandé.'**
  String get summary_contact_recommended;

  /// No description provided for @summary_consultation_advised.
  ///
  /// In fr, this message translates to:
  /// **'Certaines tensions sont présentes. Une consultation pourrait vous aider à y voir plus clair.'**
  String get summary_consultation_advised;

  /// No description provided for @summary_self_care.
  ///
  /// In fr, this message translates to:
  /// **'Votre état semble stable, mais des outils d\'auto-apaisement peuvent vous aider au quotidien.'**
  String get summary_self_care;

  /// No description provided for @priority_safety_alert.
  ///
  /// In fr, this message translates to:
  /// **'Alerte de sécurité prioritaire détectée.'**
  String get priority_safety_alert;

  /// No description provided for @high_stress_detected.
  ///
  /// In fr, this message translates to:
  /// **'Niveau de stress important rapporté.'**
  String get high_stress_detected;

  /// No description provided for @sleep_issues_detected.
  ///
  /// In fr, this message translates to:
  /// **'Difficultés de sommeil impactantes.'**
  String get sleep_issues_detected;

  /// No description provided for @mood_tension_detected.
  ///
  /// In fr, this message translates to:
  /// **'Signes de tension émotionnelle ou d\'anxiété.'**
  String get mood_tension_detected;

  /// No description provided for @relational_tension_detected.
  ///
  /// In fr, this message translates to:
  /// **'Tensions dans vos relations personnelles.'**
  String get relational_tension_detected;

  /// No description provided for @cognitive_bias_detected.
  ///
  /// In fr, this message translates to:
  /// **'Biais d\'interprétation ou d\'attribution détectés.'**
  String get cognitive_bias_detected;

  /// No description provided for @functioning_impact_detected.
  ///
  /// In fr, this message translates to:
  /// **'Impact sur le fonctionnement quotidien rapporté.'**
  String get functioning_impact_detected;

  /// No description provided for @trauma_indicators_detected.
  ///
  /// In fr, this message translates to:
  /// **'Indicateurs liés à des événements traumatiques.'**
  String get trauma_indicators_detected;

  /// No description provided for @general_wellness.
  ///
  /// In fr, this message translates to:
  /// **'Aucun indicateur de tension majeure détecté.'**
  String get general_wellness;

  /// No description provided for @consentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Protection de vos Données'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In fr, this message translates to:
  /// **'NeuroSync garantit l\'anonymat total en mode visiteur. Vos données sont traitées localement.'**
  String get consentBody;

  /// No description provided for @acceptConsent.
  ///
  /// In fr, this message translates to:
  /// **'Accepter et Continuer'**
  String get acceptConsent;

  /// No description provided for @redFlagWarning.
  ///
  /// In fr, this message translates to:
  /// **'Alerte de Sécurité'**
  String get redFlagWarning;

  /// No description provided for @greeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour,'**
  String get greeting;

  /// No description provided for @quickActions.
  ///
  /// In fr, this message translates to:
  /// **'Actions rapides'**
  String get quickActions;

  /// No description provided for @history.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get history;

  /// No description provided for @adviceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conseil du jour'**
  String get adviceTitle;

  /// No description provided for @dailyAdvice.
  ///
  /// In fr, this message translates to:
  /// **'Prendre 5 minutes pour respirer calmement peut réduire votre stress de 30%. Essayez la respiration carrée.'**
  String get dailyAdvice;

  /// No description provided for @lastAssessmentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dernière évaluation'**
  String get lastAssessmentTitle;

  /// No description provided for @viewDetails.
  ///
  /// In fr, this message translates to:
  /// **'Voir les détails'**
  String get viewDetails;

  /// No description provided for @noAssessmentsYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune évaluation réalisée pour le moment.'**
  String get noAssessmentsYet;

  /// No description provided for @reportPersonStatus.
  ///
  /// In fr, this message translates to:
  /// **'État de la personne'**
  String get reportPersonStatus;

  /// No description provided for @reportDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte rendu est un outil d\'aide à l\'orientation et ne remplace pas un diagnostic clinique officiel.'**
  String get reportDisclaimer;

  /// No description provided for @savePromptTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder vos résultats ?'**
  String get savePromptTitle;

  /// No description provided for @savePromptBody.
  ///
  /// In fr, this message translates to:
  /// **'Créez un compte pour conserver votre historique, accéder à un suivi professionnel et recevoir des recommandations personnalisées.'**
  String get savePromptBody;

  /// No description provided for @savePromptButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte NeuroSync'**
  String get savePromptButton;

  /// No description provided for @profile_intrusion_symptoms.
  ///
  /// In fr, this message translates to:
  /// **'Présence de symptômes d\'intrusion liés à des événements passés.'**
  String get profile_intrusion_symptoms;

  /// No description provided for @profile_high_stress.
  ///
  /// In fr, this message translates to:
  /// **'Niveau de stress élevé impactant le quotidien.'**
  String get profile_high_stress;

  /// No description provided for @profile_cognitive_bias.
  ///
  /// In fr, this message translates to:
  /// **'Biais cognitifs marqués et difficultés de régulation des impulsions.'**
  String get profile_cognitive_bias;

  /// No description provided for @profile_hostile_attribution.
  ///
  /// In fr, this message translates to:
  /// **'Tendance à l\'attribution d\'intentions hostiles à autrui.'**
  String get profile_hostile_attribution;

  /// No description provided for @profile_relational_distress.
  ///
  /// In fr, this message translates to:
  /// **'Détresse relationnelle et isolement social marqué.'**
  String get profile_relational_distress;

  /// No description provided for @profile_hopelessness.
  ///
  /// In fr, this message translates to:
  /// **'Vision pessimiste ou sans espoir de l\'avenir.'**
  String get profile_hopelessness;

  /// No description provided for @profile_sleep_disturbance.
  ///
  /// In fr, this message translates to:
  /// **'Perturbation majeure du cycle veille-sommeil.'**
  String get profile_sleep_disturbance;

  /// No description provided for @profile_balanced.
  ///
  /// In fr, this message translates to:
  /// **'Profil psychologique globalement équilibré et fonctionnel.'**
  String get profile_balanced;

  /// No description provided for @rec_hygiene.
  ///
  /// In fr, this message translates to:
  /// **'Maintenir une hygiène de vie stable.'**
  String get rec_hygiene;

  /// No description provided for @rec_mindfulness.
  ///
  /// In fr, this message translates to:
  /// **'Pratiquer des exercices de pleine conscience.'**
  String get rec_mindfulness;

  /// No description provided for @rec_routine_consultation.
  ///
  /// In fr, this message translates to:
  /// **'Consultation de routine recommandée pour prévenir l\'épuisement.'**
  String get rec_routine_consultation;

  /// No description provided for @rec_sleep_eval.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation approfondie du sommeil.'**
  String get rec_sleep_eval;

  /// No description provided for @rec_weekly_followup.
  ///
  /// In fr, this message translates to:
  /// **'Suivi psychologique hebdomadaire conseillé.'**
  String get rec_weekly_followup;

  /// No description provided for @rec_social_support.
  ///
  /// In fr, this message translates to:
  /// **'Renforcer le réseau de soutien social.'**
  String get rec_social_support;

  /// No description provided for @rec_immediate_psychiatry.
  ///
  /// In fr, this message translates to:
  /// **'Consultation psychiatrique immédiate requise.'**
  String get rec_immediate_psychiatry;

  /// No description provided for @rec_safety_protocol.
  ///
  /// In fr, this message translates to:
  /// **'Protocole de sécurité environnemental.'**
  String get rec_safety_protocol;

  /// No description provided for @rec_specialized_care.
  ///
  /// In fr, this message translates to:
  /// **'Prise en charge en milieu spécialisé.'**
  String get rec_specialized_care;

  /// No description provided for @professionalPortal.
  ///
  /// In fr, this message translates to:
  /// **'Portail Professionnel'**
  String get professionalPortal;

  /// No description provided for @pendingFollowupRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de suivi en attente'**
  String get pendingFollowupRequests;

  /// No description provided for @noPendingRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande en attente'**
  String get noPendingRequests;

  /// No description provided for @professionalTools.
  ///
  /// In fr, this message translates to:
  /// **'Outils professionnels'**
  String get professionalTools;

  /// No description provided for @directories.
  ///
  /// In fr, this message translates to:
  /// **'Annuaires'**
  String get directories;

  /// No description provided for @reports.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get reports;

  /// No description provided for @statsPatients.
  ///
  /// In fr, this message translates to:
  /// **'Patients'**
  String get statsPatients;

  /// No description provided for @statsAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get statsAlerts;

  /// No description provided for @statsConsultations.
  ///
  /// In fr, this message translates to:
  /// **'Consultations'**
  String get statsConsultations;

  /// No description provided for @administration.
  ///
  /// In fr, this message translates to:
  /// **'Administration'**
  String get administration;

  /// No description provided for @userManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des utilisateurs'**
  String get userManagement;

  /// No description provided for @psychologistValidation.
  ///
  /// In fr, this message translates to:
  /// **'Validation Psychologues'**
  String get psychologistValidation;

  /// No description provided for @securityLogs.
  ///
  /// In fr, this message translates to:
  /// **'Logs de sécurité'**
  String get securityLogs;

  /// No description provided for @globalSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres globaux'**
  String get globalSettings;

  /// No description provided for @stepCounter.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String stepCounter(int current, int total);

  /// No description provided for @assessmentFinished.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation terminée'**
  String get assessmentFinished;

  /// No description provided for @seeResults.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes résultats'**
  String get seeResults;

  /// No description provided for @finish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get finish;

  /// No description provided for @next.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get previous;

  /// No description provided for @quitAssessment.
  ///
  /// In fr, this message translates to:
  /// **'Quitter l\'évaluation'**
  String get quitAssessment;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez NeuroSync'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez un compte pour sauvegarder vos évaluations et accéder à plus de ressources.'**
  String get registerSubtitle;

  /// No description provided for @roleSelection.
  ///
  /// In fr, this message translates to:
  /// **'Quel est votre profil ?'**
  String get roleSelection;

  /// No description provided for @accountCreated.
  ///
  /// In fr, this message translates to:
  /// **'Compte créé avec succès !'**
  String get accountCreated;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Content de vous revoir'**
  String get loginTitle;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPassword;

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas de compte ?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get signUp;

  /// No description provided for @migratePromptTitle.
  ///
  /// In fr, this message translates to:
  /// **'Transférer votre historique ?'**
  String get migratePromptTitle;

  /// No description provided for @migratePromptBody.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez effectué des évaluations en tant que visiteur. Souhaitez-vous les ajouter à votre nouveau compte ?'**
  String get migratePromptBody;

  /// No description provided for @transfer.
  ///
  /// In fr, this message translates to:
  /// **'Transférer'**
  String get transfer;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get all;

  /// No description provided for @call.
  ///
  /// In fr, this message translates to:
  /// **'Appeler'**
  String get call;

  /// No description provided for @locate.
  ///
  /// In fr, this message translates to:
  /// **'Localiser'**
  String get locate;

  /// No description provided for @searchService.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un service...'**
  String get searchService;

  /// No description provided for @typeEmergency.
  ///
  /// In fr, this message translates to:
  /// **'Urgences'**
  String get typeEmergency;

  /// No description provided for @typeListening.
  ///
  /// In fr, this message translates to:
  /// **'Écoute'**
  String get typeListening;

  /// No description provided for @typeCounseling.
  ///
  /// In fr, this message translates to:
  /// **'Consultations'**
  String get typeCounseling;

  /// No description provided for @typeSelfCare.
  ///
  /// In fr, this message translates to:
  /// **'Auto-aide'**
  String get typeSelfCare;

  /// No description provided for @privacyEngagement.
  ///
  /// In fr, this message translates to:
  /// **'Engagement de Confidentialité NeuroSync'**
  String get privacyEngagement;

  /// No description provided for @dataSovereigntyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Souveraineté des Données'**
  String get dataSovereigntyTitle;

  /// No description provided for @dataSovereigntyDesc.
  ///
  /// In fr, this message translates to:
  /// **'En mode visiteur, vos données sont stockées uniquement sur votre appareil. Elles ne sont jamais transmises sans votre consentement explicite.'**
  String get dataSovereigntyDesc;

  /// No description provided for @anonymityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Anonymat Garanti'**
  String get anonymityTitle;

  /// No description provided for @anonymityDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les indicateurs sont générés par un algorithme local. Aucune information nominative n\'est requise pour l\'évaluation initiale.'**
  String get anonymityDesc;

  /// No description provided for @professionalSecretTitle.
  ///
  /// In fr, this message translates to:
  /// **'Secret Professionnel'**
  String get professionalSecretTitle;

  /// No description provided for @professionalSecretDesc.
  ///
  /// In fr, this message translates to:
  /// **'Les rapports partagés sont protégés par le secret professionnel et via un canal sécurisé.'**
  String get professionalSecretDesc;

  /// No description provided for @userRightsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Droit des Personnes'**
  String get userRightsTitle;

  /// No description provided for @userRightsDesc.
  ///
  /// In fr, this message translates to:
  /// **'Vous disposez d\'un droit d\'accès, de rectification et de suppression totale de vos données à tout moment.'**
  String get userRightsDesc;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @purposeTitle.
  ///
  /// In fr, this message translates to:
  /// **'À quoi sert NeuroSync ?'**
  String get purposeTitle;

  /// No description provided for @purposeItem1.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre son état actuel et identifier certaines tensions.'**
  String get purposeItem1;

  /// No description provided for @purposeItem2.
  ///
  /// In fr, this message translates to:
  /// **'Obtenir une orientation adaptée et accéder à des ressources.'**
  String get purposeItem2;

  /// No description provided for @purposeItem3.
  ///
  /// In fr, this message translates to:
  /// **'Précision : Ce n\'est PAS un diagnostic médical.'**
  String get purposeItem3;

  /// No description provided for @continueLabel.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueLabel;

  /// No description provided for @decline.
  ///
  /// In fr, this message translates to:
  /// **'REFUSER'**
  String get decline;

  /// No description provided for @finalMessageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Maintenant, c\'est ton espace.'**
  String get finalMessageTitle;

  /// No description provided for @finalMessageSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Écris ce que tu ressens avec tes propres mots.'**
  String get finalMessageSubtitle;

  /// No description provided for @finalMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Je ressens...\nCe qui me préoccupe...\nCe que j\'aimerais changer...'**
  String get finalMessageHint;

  /// No description provided for @skip.
  ///
  /// In fr, this message translates to:
  /// **'Je préfère passer'**
  String get skip;

  /// No description provided for @encouragementMessage.
  ///
  /// In fr, this message translates to:
  /// **'Merci de continuer. Chaque réponse nous aide à mieux vous orienter. 🌿'**
  String get encouragementMessage;

  /// No description provided for @encouragementMessageShort.
  ///
  /// In fr, this message translates to:
  /// **'Merci de continuer. 🌿'**
  String get encouragementMessageShort;

  /// No description provided for @guestTitle.
  ///
  /// In fr, this message translates to:
  /// **'NeuroSync - Visiteur'**
  String get guestTitle;

  /// No description provided for @welcomeGuest.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur NeuroSync'**
  String get welcomeGuest;

  /// No description provided for @guestSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Explorez nos outils et ressources en toute confidentialité. Vos données restent sur votre appareil.'**
  String get guestSubtitle;

  /// No description provided for @assessment.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation'**
  String get assessment;

  /// No description provided for @assessmentDesc.
  ///
  /// In fr, this message translates to:
  /// **'Réalisez une auto-évaluation anonyme pour situer vos besoins.'**
  String get assessmentDesc;

  /// No description provided for @resourcesDesc.
  ///
  /// In fr, this message translates to:
  /// **'Consultez les informations et annuaires de professionnels.'**
  String get resourcesDesc;

  /// No description provided for @privacyDesc.
  ///
  /// In fr, this message translates to:
  /// **'En savoir plus sur la protection de vos données locales.'**
  String get privacyDesc;

  /// No description provided for @resourceModuleDev.
  ///
  /// In fr, this message translates to:
  /// **'Module ressources en cours de développement'**
  String get resourceModuleDev;

  /// No description provided for @privacyEngagementVersion.
  ///
  /// In fr, this message translates to:
  /// **'Engagement de confidentialité NeuroSync v4.0'**
  String get privacyEngagementVersion;

  /// No description provided for @res_emergency_name.
  ///
  /// In fr, this message translates to:
  /// **'Service d\'Urgence'**
  String get res_emergency_name;

  /// No description provided for @res_emergency_desc.
  ///
  /// In fr, this message translates to:
  /// **'Assistance immédiate 24/7 pour les situations de crise.'**
  String get res_emergency_desc;

  /// No description provided for @res_listening_name.
  ///
  /// In fr, this message translates to:
  /// **'Ligne d\'Écoute NeuroSync'**
  String get res_listening_name;

  /// No description provided for @res_listening_desc.
  ///
  /// In fr, this message translates to:
  /// **'Parlez à un professionnel de vos tensions et de votre stress.'**
  String get res_listening_desc;

  /// No description provided for @res_selfcare_name.
  ///
  /// In fr, this message translates to:
  /// **'Guide d\'Auto-Apaisement'**
  String get res_selfcare_name;

  /// No description provided for @res_selfcare_desc.
  ///
  /// In fr, this message translates to:
  /// **'Exercices de respiration et de gestion du stress à faire chez soi.'**
  String get res_selfcare_desc;

  /// No description provided for @res_counseling_name.
  ///
  /// In fr, this message translates to:
  /// **'Centre de Consultation Locale'**
  String get res_counseling_name;

  /// No description provided for @res_counseling_desc.
  ///
  /// In fr, this message translates to:
  /// **'Prenez rendez-vous pour un suivi personnalisé.'**
  String get res_counseling_desc;

  /// No description provided for @error_occurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get error_occurred;

  /// No description provided for @min_password_length.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 6 caractères'**
  String get min_password_length;

  /// No description provided for @user_label.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get user_label;

  /// No description provided for @status_label.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get status_label;

  /// No description provided for @recommended_resources.
  ///
  /// In fr, this message translates to:
  /// **'Ressources recommandées'**
  String get recommended_resources;

  /// No description provided for @restart_assessment.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer / Suppression des données'**
  String get restart_assessment;

  /// No description provided for @myPatients.
  ///
  /// In fr, this message translates to:
  /// **'Mes Patients'**
  String get myPatients;

  /// No description provided for @accessRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes d\'accès'**
  String get accessRequests;

  /// No description provided for @accept.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get reject;

  /// No description provided for @patientDetail.
  ///
  /// In fr, this message translates to:
  /// **'Détail Patient'**
  String get patientDetail;

  /// No description provided for @noPatients.
  ///
  /// In fr, this message translates to:
  /// **'Aucun patient pour le moment'**
  String get noPatients;

  /// No description provided for @assessmentHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des évaluations'**
  String get assessmentHistory;

  /// No description provided for @lastAssessment.
  ///
  /// In fr, this message translates to:
  /// **'Dernière évaluation'**
  String get lastAssessment;

  /// No description provided for @alerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes'**
  String get alerts;

  /// No description provided for @noAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Aucune alerte'**
  String get noAlerts;

  /// No description provided for @authorizedAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accès autorisé'**
  String get authorizedAccess;

  /// No description provided for @pendingAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accès en attente'**
  String get pendingAccess;

  /// No description provided for @deniedAccess.
  ///
  /// In fr, this message translates to:
  /// **'Accès refusé'**
  String get deniedAccess;

  /// No description provided for @patientInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations Patient'**
  String get patientInfo;

  /// No description provided for @clinicalData.
  ///
  /// In fr, this message translates to:
  /// **'Données Cliniques'**
  String get clinicalData;

  /// No description provided for @searchPatient.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un patient...'**
  String get searchPatient;

  /// No description provided for @orientationLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau d\'orientation'**
  String get orientationLevel;

  /// No description provided for @redFlags.
  ///
  /// In fr, this message translates to:
  /// **'Points de vigilance (Red Flags)'**
  String get redFlags;

  /// No description provided for @noRedFlags.
  ///
  /// In fr, this message translates to:
  /// **'Aucun point de vigilance détecté'**
  String get noRedFlags;

  /// No description provided for @activeUsers.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs actifs'**
  String get activeUsers;

  /// No description provided for @pendingProfessionals.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels en attente'**
  String get pendingProfessionals;

  /// No description provided for @totalAssessments.
  ///
  /// In fr, this message translates to:
  /// **'Total évaluations'**
  String get totalAssessments;

  /// No description provided for @securityAlerts.
  ///
  /// In fr, this message translates to:
  /// **'Alertes sécurité'**
  String get securityAlerts;

  /// No description provided for @recentActivity.
  ///
  /// In fr, this message translates to:
  /// **'Activité récente'**
  String get recentActivity;

  /// No description provided for @viewAll.
  ///
  /// In fr, this message translates to:
  /// **'Voir tout'**
  String get viewAll;

  /// No description provided for @statusApproved.
  ///
  /// In fr, this message translates to:
  /// **'Approuvé'**
  String get statusApproved;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get statusPending;

  /// No description provided for @statusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejeté'**
  String get statusRejected;

  /// No description provided for @statusSuspended.
  ///
  /// In fr, this message translates to:
  /// **'Suspendu'**
  String get statusSuspended;

  /// No description provided for @approve.
  ///
  /// In fr, this message translates to:
  /// **'Approuver'**
  String get approve;

  /// No description provided for @suspend.
  ///
  /// In fr, this message translates to:
  /// **'Suspendre'**
  String get suspend;

  /// No description provided for @activate.
  ///
  /// In fr, this message translates to:
  /// **'Activer'**
  String get activate;

  /// No description provided for @professionalDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails du professionnel'**
  String get professionalDetails;

  /// No description provided for @userDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails de l\'utilisateur'**
  String get userDetails;

  /// No description provided for @action.
  ///
  /// In fr, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @actor.
  ///
  /// In fr, this message translates to:
  /// **'Acteur'**
  String get actor;

  /// No description provided for @target.
  ///
  /// In fr, this message translates to:
  /// **'Cible'**
  String get target;

  /// No description provided for @timestamp.
  ///
  /// In fr, this message translates to:
  /// **'Horodatage'**
  String get timestamp;

  /// No description provided for @systemStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques Système'**
  String get systemStats;

  /// No description provided for @professionalManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des Professionnels'**
  String get professionalManagement;

  /// No description provided for @searchUser.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un utilisateur...'**
  String get searchUser;

  /// No description provided for @noLogsFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun log trouvé'**
  String get noLogsFound;

  /// No description provided for @downloadPdf.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger PDF'**
  String get downloadPdf;

  /// No description provided for @exporting.
  ///
  /// In fr, this message translates to:
  /// **'Exportation en cours...'**
  String get exporting;

  /// No description provided for @pdfError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la génération du PDF'**
  String get pdfError;

  /// No description provided for @adminRole.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get adminRole;

  /// No description provided for @what_we_understood.
  ///
  /// In fr, this message translates to:
  /// **'Ce que nous avons compris'**
  String get what_we_understood;

  /// No description provided for @module_calm.
  ///
  /// In fr, this message translates to:
  /// **'Calme'**
  String get module_calm;

  /// No description provided for @module_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Confiance'**
  String get module_confidence;

  /// No description provided for @module_sleep.
  ///
  /// In fr, this message translates to:
  /// **'Sommeil'**
  String get module_sleep;

  /// No description provided for @module_support.
  ///
  /// In fr, this message translates to:
  /// **'Soutien'**
  String get module_support;

  /// No description provided for @module_emotions.
  ///
  /// In fr, this message translates to:
  /// **'Émotions'**
  String get module_emotions;

  /// No description provided for @module_balance.
  ///
  /// In fr, this message translates to:
  /// **'Équilibre'**
  String get module_balance;

  /// No description provided for @priority_high.
  ///
  /// In fr, this message translates to:
  /// **'Priorité'**
  String get priority_high;

  /// No description provided for @priority_moderate.
  ///
  /// In fr, this message translates to:
  /// **'Modéré'**
  String get priority_moderate;

  /// No description provided for @priority_stable.
  ///
  /// In fr, this message translates to:
  /// **'Stable'**
  String get priority_stable;

  /// No description provided for @need_support.
  ///
  /// In fr, this message translates to:
  /// **'Besoin de soutien'**
  String get need_support;

  /// No description provided for @globally_stable.
  ///
  /// In fr, this message translates to:
  /// **'Globalement stable'**
  String get globally_stable;

  /// No description provided for @how_feel_today.
  ///
  /// In fr, this message translates to:
  /// **'Comment te sens-tu aujourd\'hui ?'**
  String get how_feel_today;

  /// No description provided for @take_minutes_for_you.
  ///
  /// In fr, this message translates to:
  /// **'Prends quelques minutes pour toi.'**
  String get take_minutes_for_you;

  /// No description provided for @mood_ok.
  ///
  /// In fr, this message translates to:
  /// **'Ça va'**
  String get mood_ok;

  /// No description provided for @mood_neutral.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get mood_neutral;

  /// No description provided for @mood_difficult.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get mood_difficult;

  /// No description provided for @mood_very_difficult.
  ///
  /// In fr, this message translates to:
  /// **'Très difficile'**
  String get mood_very_difficult;

  /// No description provided for @action_assess.
  ///
  /// In fr, this message translates to:
  /// **'Évaluer'**
  String get action_assess;

  /// No description provided for @action_calm.
  ///
  /// In fr, this message translates to:
  /// **'Me calmer'**
  String get action_calm;

  /// No description provided for @action_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Confiance'**
  String get action_confidence;

  /// No description provided for @action_support.
  ///
  /// In fr, this message translates to:
  /// **'Soutien'**
  String get action_support;

  /// No description provided for @breathe_in.
  ///
  /// In fr, this message translates to:
  /// **'Inspire'**
  String get breathe_in;

  /// No description provided for @breathe_hold.
  ///
  /// In fr, this message translates to:
  /// **'Garde'**
  String get breathe_hold;

  /// No description provided for @breathe_out.
  ///
  /// In fr, this message translates to:
  /// **'Expire'**
  String get breathe_out;

  /// No description provided for @breathing_instruction.
  ///
  /// In fr, this message translates to:
  /// **'Laisse ton corps se détendre à chaque expiration.'**
  String get breathing_instruction;

  /// No description provided for @module_social.
  ///
  /// In fr, this message translates to:
  /// **'Social'**
  String get module_social;

  /// No description provided for @module_economic.
  ///
  /// In fr, this message translates to:
  /// **'Économique'**
  String get module_economic;

  /// No description provided for @module_trauma.
  ///
  /// In fr, this message translates to:
  /// **'Trauma'**
  String get module_trauma;

  /// No description provided for @module_bias.
  ///
  /// In fr, this message translates to:
  /// **'Biais'**
  String get module_bias;

  /// No description provided for @q_pref_spiritual.
  ///
  /// In fr, this message translates to:
  /// **'Souhaitez-vous inclure une dimension spirituelle et des ressources inspirées du Coran et des Hadiths dans vos recommandations ?'**
  String get q_pref_spiritual;

  /// No description provided for @why_q_pref_spiritual.
  ///
  /// In fr, this message translates to:
  /// **'Cette option permet de personnaliser vos conseils avec des ressources spirituelles si elles font partie de vos leviers de réconfort.'**
  String get why_q_pref_spiritual;

  /// No description provided for @q_emotions_loneliness.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous un sentiment de solitude même lorsque vous êtes entouré ?'**
  String get q_emotions_loneliness;

  /// No description provided for @why_q_emotions_loneliness.
  ///
  /// In fr, this message translates to:
  /// **'Le sentiment de solitude impacte profondément le bien-être émotionnel.'**
  String get why_q_emotions_loneliness;

  /// No description provided for @q_emotions_overload.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous l\'impression que vos émotions sont trop lourdes à porter ?'**
  String get q_emotions_overload;

  /// No description provided for @why_q_emotions_overload.
  ///
  /// In fr, this message translates to:
  /// **'Identifier la surcharge permet de proposer des outils d\'apaisement adaptés.'**
  String get why_q_emotions_overload;

  /// No description provided for @q_stress_overwhelmed.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous l\'impression de ne plus pouvoir faire face aux événements ?'**
  String get q_stress_overwhelmed;

  /// No description provided for @why_q_stress_overwhelmed.
  ///
  /// In fr, this message translates to:
  /// **'Le sentiment d\'impuissance est un indicateur fort de besoin de soutien.'**
  String get why_q_stress_overwhelmed;

  /// No description provided for @q_mgmt_difficulty_reaction.
  ///
  /// In fr, this message translates to:
  /// **'Comment réagissez-vous face à une difficulté imprévue ?'**
  String get q_mgmt_difficulty_reaction;

  /// No description provided for @why_q_mgmt_reaction.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre votre réactivité aide à renforcer vos stratégies d\'adaptation.'**
  String get why_q_mgmt_reaction;

  /// No description provided for @q_mgmt_asking_help.
  ///
  /// In fr, this message translates to:
  /// **'Est-ce facile pour vous de demander de l\'aide quand vous en avez besoin ?'**
  String get q_mgmt_asking_help;

  /// No description provided for @why_q_mgmt_help.
  ///
  /// In fr, this message translates to:
  /// **'La capacité à demander du soutien est une force protectrice majeure.'**
  String get why_q_mgmt_help;

  /// No description provided for @q_rel_family_tension.
  ///
  /// In fr, this message translates to:
  /// **'Vivez-vous des tensions au sein de votre environnement familial ?'**
  String get q_rel_family_tension;

  /// No description provided for @why_q_rel_family.
  ///
  /// In fr, this message translates to:
  /// **'Le contexte familial est un pilier central de l\'équilibre personnel.'**
  String get why_q_rel_family;

  /// No description provided for @q_rel_belonging.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous le sentiment d\'appartenir à un groupe ou une communauté qui vous soutient ?'**
  String get q_rel_belonging;

  /// No description provided for @why_q_rel_belonging.
  ///
  /// In fr, this message translates to:
  /// **'Le sentiment d\'appartenance réduit le risque d\'isolement.'**
  String get why_q_rel_belonging;

  /// No description provided for @q_est_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Quelle confiance accordez-vous à vos capacités actuelles ?'**
  String get q_est_confidence;

  /// No description provided for @why_q_est_confidence.
  ///
  /// In fr, this message translates to:
  /// **'L\'estime de soi influence directement votre manière de traverser les épreuves.'**
  String get why_q_est_confidence;

  /// No description provided for @q_est_value.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous le sentiment que votre valeur personnelle est reconnue ?'**
  String get q_est_value;

  /// No description provided for @why_q_est_value.
  ///
  /// In fr, this message translates to:
  /// **'La perception de sa propre valeur est essentielle à la santé mentale.'**
  String get why_q_est_value;

  /// No description provided for @q_beh_organization.
  ///
  /// In fr, this message translates to:
  /// **'Arrivez-vous à maintenir une organisation qui vous convient au quotidien ?'**
  String get q_beh_organization;

  /// No description provided for @why_q_beh_organization.
  ///
  /// In fr, this message translates to:
  /// **'L\'organisation impacte la charge mentale et le sentiment de contrôle.'**
  String get why_q_beh_organization;

  /// No description provided for @q_beh_motivation.
  ///
  /// In fr, this message translates to:
  /// **'Comment évalueriez-vous votre niveau de motivation pour vos projets ?'**
  String get q_beh_motivation;

  /// No description provided for @why_q_beh_motivation.
  ///
  /// In fr, this message translates to:
  /// **'La baisse de motivation peut refléter un besoin de repos ou de sens.'**
  String get why_q_beh_motivation;

  /// No description provided for @q_cog_ruminations.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous des pensées répétitives qui vous empêchent de vous détendre ?'**
  String get q_cog_ruminations;

  /// No description provided for @why_q_cog_ruminations.
  ///
  /// In fr, this message translates to:
  /// **'Les ruminations sont un mécanisme courant du stress qu\'il est possible de réguler.'**
  String get why_q_cog_ruminations;

  /// No description provided for @q_cog_decisions.
  ///
  /// In fr, this message translates to:
  /// **'Éprouvez-vous des difficultés à prendre des décisions simples en ce moment ?'**
  String get q_cog_decisions;

  /// No description provided for @why_q_cog_decisions.
  ///
  /// In fr, this message translates to:
  /// **'La difficulté décisionnelle peut être le signe d\'une fatigue cognitive.'**
  String get why_q_cog_decisions;

  /// No description provided for @q_env_safety.
  ///
  /// In fr, this message translates to:
  /// **'Vous sentez-vous en sécurité et respecté dans votre environnement habituel ?'**
  String get q_env_safety;

  /// No description provided for @why_q_env_safety.
  ///
  /// In fr, this message translates to:
  /// **'Le sentiment de sécurité est la base fondamentale du bien-être.'**
  String get why_q_env_safety;

  /// No description provided for @q_env_pressure.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous une pression sociale ou environnementale trop forte ?'**
  String get q_env_pressure;

  /// No description provided for @why_q_env_pressure.
  ///
  /// In fr, this message translates to:
  /// **'Les pressions externes impactent la capacité de résilience.'**
  String get why_q_env_pressure;

  /// No description provided for @q_spi_hope.
  ///
  /// In fr, this message translates to:
  /// **'Quelle place accordez-vous à l\'espoir dans votre situation actuelle ?'**
  String get q_spi_hope;

  /// No description provided for @why_q_spi_hope.
  ///
  /// In fr, this message translates to:
  /// **'L\'espoir est un puissant moteur de reconstruction spirituelle et psychologique.'**
  String get why_q_spi_hope;

  /// No description provided for @q_spi_gratitude.
  ///
  /// In fr, this message translates to:
  /// **'Arrivez-vous à identifier des moments de gratitude malgré les épreuves ?'**
  String get q_spi_gratitude;

  /// No description provided for @why_q_spi_gratitude.
  ///
  /// In fr, this message translates to:
  /// **'La gratitude aide à rééquilibrer la perception des événements de vie.'**
  String get why_q_spi_gratitude;

  /// No description provided for @my_strengths.
  ///
  /// In fr, this message translates to:
  /// **'Vos forces et ressources'**
  String get my_strengths;

  /// No description provided for @focus_areas.
  ///
  /// In fr, this message translates to:
  /// **'Points d\'attention'**
  String get focus_areas;

  /// No description provided for @strength_calm.
  ///
  /// In fr, this message translates to:
  /// **'Capacité de calme'**
  String get strength_calm;

  /// No description provided for @strength_social_support.
  ///
  /// In fr, this message translates to:
  /// **'Soutien social présent'**
  String get strength_social_support;

  /// No description provided for @strength_self_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Confiance en soi préservée'**
  String get strength_self_confidence;

  /// No description provided for @strength_organization.
  ///
  /// In fr, this message translates to:
  /// **'Bonne organisation personnelle'**
  String get strength_organization;

  /// No description provided for @strength_resilience.
  ///
  /// In fr, this message translates to:
  /// **'Résilience naturelle'**
  String get strength_resilience;

  /// No description provided for @rec_title_stress.
  ///
  /// In fr, this message translates to:
  /// **'Gestion du Stress'**
  String get rec_title_stress;

  /// No description provided for @rec_desc_stress.
  ///
  /// In fr, this message translates to:
  /// **'Des outils pour apaiser votre tension intérieure.'**
  String get rec_desc_stress;

  /// No description provided for @rec_spiritual_title_stress.
  ///
  /// In fr, this message translates to:
  /// **'Réconfort Spirituel (Stress)'**
  String get rec_spiritual_title_stress;

  /// No description provided for @rec_spiritual_desc_stress.
  ///
  /// In fr, this message translates to:
  /// **'Des versets et hadiths pour trouver la paix.'**
  String get rec_spiritual_desc_stress;

  /// No description provided for @rec_title_emotions.
  ///
  /// In fr, this message translates to:
  /// **'Équilibre Émotionnel'**
  String get rec_title_emotions;

  /// No description provided for @rec_desc_emotions.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre et accueillir vos émotions.'**
  String get rec_desc_emotions;

  /// No description provided for @rec_actions_title.
  ///
  /// In fr, this message translates to:
  /// **'Micro-actions recommandées'**
  String get rec_actions_title;

  /// No description provided for @rec_actions_desc.
  ///
  /// In fr, this message translates to:
  /// **'Petits pas concrets pour aujourd\'hui.'**
  String get rec_actions_desc;

  /// No description provided for @res_breathing_title.
  ///
  /// In fr, this message translates to:
  /// **'Respiration Carrée'**
  String get res_breathing_title;

  /// No description provided for @res_breathing_desc.
  ///
  /// In fr, this message translates to:
  /// **'Technique simple pour apaiser le système nerveux.'**
  String get res_breathing_desc;

  /// No description provided for @res_breathing_content.
  ///
  /// In fr, this message translates to:
  /// **'La respiration carrée consiste à inspirer, bloquer, expirer et bloquer pendant la même durée (4 secondes par phase).'**
  String get res_breathing_content;

  /// No description provided for @res_reframing_title.
  ///
  /// In fr, this message translates to:
  /// **'Recadrage Cognitif'**
  String get res_reframing_title;

  /// No description provided for @res_reframing_desc.
  ///
  /// In fr, this message translates to:
  /// **'Apprendre à voir les situations sous un autre angle.'**
  String get res_reframing_desc;

  /// No description provided for @res_reframing_content.
  ///
  /// In fr, this message translates to:
  /// **'Essayez d\'identifier une pensée négative et de trouver une alternative plus réaliste ou nuancée.'**
  String get res_reframing_content;

  /// No description provided for @res_sleep_hygiene_title.
  ///
  /// In fr, this message translates to:
  /// **'Hygiène du Sommeil'**
  String get res_sleep_hygiene_title;

  /// No description provided for @res_sleep_hygiene_desc.
  ///
  /// In fr, this message translates to:
  /// **'Conseils pour retrouver un sommeil réparateur.'**
  String get res_sleep_hygiene_desc;

  /// No description provided for @res_sleep_hygiene_content.
  ///
  /// In fr, this message translates to:
  /// **'Évitez les écrans 1h avant le coucher, maintenez une température fraîche et des horaires réguliers.'**
  String get res_sleep_hygiene_content;

  /// No description provided for @res_emotional_exp_title.
  ///
  /// In fr, this message translates to:
  /// **'L\'expression des émotions'**
  String get res_emotional_exp_title;

  /// No description provided for @res_emotional_exp_desc.
  ///
  /// In fr, this message translates to:
  /// **'Comment mettre des mots sur ce que vous vivez.'**
  String get res_emotional_exp_desc;

  /// No description provided for @res_emotional_exp_content.
  ///
  /// In fr, this message translates to:
  /// **'Essayez de décrire votre émotion actuelle sans la juger. \'Je me sens... parce que...\'.'**
  String get res_emotional_exp_content;

  /// No description provided for @res_social_support_title.
  ///
  /// In fr, this message translates to:
  /// **'Renforcer son cercle'**
  String get res_social_support_title;

  /// No description provided for @res_social_support_desc.
  ///
  /// In fr, this message translates to:
  /// **'Identifier les personnes de confiance.'**
  String get res_social_support_desc;

  /// No description provided for @res_social_support_content.
  ///
  /// In fr, this message translates to:
  /// **'Faites une liste de 3 personnes à qui vous pourriez envoyer un message aujourd\'hui.'**
  String get res_social_support_content;

  /// No description provided for @act_glass_water_title.
  ///
  /// In fr, this message translates to:
  /// **'S\'hydrater'**
  String get act_glass_water_title;

  /// No description provided for @act_glass_water_desc.
  ///
  /// In fr, this message translates to:
  /// **'Buvez un grand verre d\'eau maintenant.'**
  String get act_glass_water_desc;

  /// No description provided for @act_deep_breath_title.
  ///
  /// In fr, this message translates to:
  /// **'Trois grandes respirations'**
  String get act_deep_breath_title;

  /// No description provided for @act_deep_breath_desc.
  ///
  /// In fr, this message translates to:
  /// **'Prenez trois inspirations profondes et expirez lentement.'**
  String get act_deep_breath_desc;

  /// No description provided for @act_gratitude_list_title.
  ///
  /// In fr, this message translates to:
  /// **'Liste de gratitude'**
  String get act_gratitude_list_title;

  /// No description provided for @act_gratitude_list_desc.
  ///
  /// In fr, this message translates to:
  /// **'Notez trois choses pour lesquelles vous êtes reconnaissant aujourd\'hui.'**
  String get act_gratitude_list_desc;

  /// No description provided for @act_write_emotion_title.
  ///
  /// In fr, this message translates to:
  /// **'Écriture émotionnelle'**
  String get act_write_emotion_title;

  /// No description provided for @act_write_emotion_desc.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez 2 minutes sur votre ressenti sans filtre.'**
  String get act_write_emotion_desc;

  /// No description provided for @act_call_friend_title.
  ///
  /// In fr, this message translates to:
  /// **'Appel de soutien'**
  String get act_call_friend_title;

  /// No description provided for @act_call_friend_desc.
  ///
  /// In fr, this message translates to:
  /// **'Appelez un ami ou un proche pour discuter.'**
  String get act_call_friend_desc;

  /// No description provided for @act_sunlight_title.
  ///
  /// In fr, this message translates to:
  /// **'Lumière naturelle'**
  String get act_sunlight_title;

  /// No description provided for @act_sunlight_desc.
  ///
  /// In fr, this message translates to:
  /// **'Sortez 10 minutes au soleil si possible.'**
  String get act_sunlight_desc;

  /// No description provided for @act_tidy_title.
  ///
  /// In fr, this message translates to:
  /// **'Petit rangement'**
  String get act_tidy_title;

  /// No description provided for @act_tidy_desc.
  ///
  /// In fr, this message translates to:
  /// **'Rangez 5 objets autour de vous pour clarifier l\'espace.'**
  String get act_tidy_desc;

  /// No description provided for @act_stretch_title.
  ///
  /// In fr, this message translates to:
  /// **'Étirements doux'**
  String get act_stretch_title;

  /// No description provided for @act_stretch_desc.
  ///
  /// In fr, this message translates to:
  /// **'Étirez votre cou et vos épaules pendant 1 minute.'**
  String get act_stretch_desc;

  /// No description provided for @q_cog_concentration.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous du mal à fixer votre attention sur une seule chose ?'**
  String get q_cog_concentration;

  /// No description provided for @why_q_cog_concentration.
  ///
  /// In fr, this message translates to:
  /// **'La concentration est un indicateur de la charge cognitive actuelle.'**
  String get why_q_cog_concentration;

  /// No description provided for @q_anx_nervous.
  ///
  /// In fr, this message translates to:
  /// **'Vous sentez-vous nerveux ou tendu la majeure partie de la journée ?'**
  String get q_anx_nervous;

  /// No description provided for @q_anx_worry.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous des inquiétudes excessives difficiles à contrôler ?'**
  String get q_anx_worry;

  /// No description provided for @q_life_balance.
  ///
  /// In fr, this message translates to:
  /// **'Parvenez-vous à équilibrer vos temps de repos et d\'activité ?'**
  String get q_life_balance;

  /// No description provided for @q_life_digital.
  ///
  /// In fr, this message translates to:
  /// **'Votre consommation d\'écrans vous semble-t-elle excessive ?'**
  String get q_life_digital;

  /// No description provided for @q_soc_support_people.
  ///
  /// In fr, this message translates to:
  /// **'Combien de personnes pouvez-vous solliciter en cas de coup dur ?'**
  String get q_soc_support_people;

  /// No description provided for @q_soc_isolation.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous le besoin de vous couper du monde extérieur ?'**
  String get q_soc_isolation;

  /// No description provided for @q_prod_efficiency.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous l\'impression d\'être moins efficace dans votre travail ou vos études ?'**
  String get q_prod_efficiency;

  /// No description provided for @q_prod_motivation.
  ///
  /// In fr, this message translates to:
  /// **'Est-il difficile de trouver la motivation pour commencer une tâche ?'**
  String get q_prod_motivation;

  /// No description provided for @q_est_comparison.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous tendance à vous comparer négativement aux autres ?'**
  String get q_est_comparison;

  /// No description provided for @q_est_shame.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous souvent un sentiment de honte ou de culpabilité ?'**
  String get q_est_shame;

  /// No description provided for @q_rel_conflict_freq.
  ///
  /// In fr, this message translates to:
  /// **'La fréquence des conflits avec vos proches a-t-elle augmenté ?'**
  String get q_rel_conflict_freq;

  /// No description provided for @q_rel_trust.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous du mal à faire confiance aux personnes qui vous entourent ?'**
  String get q_rel_trust;

  /// No description provided for @q_hlth_chronic_pain.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous des douleurs physiques inexpliquées ?'**
  String get q_hlth_chronic_pain;

  /// No description provided for @q_hlth_appetite.
  ///
  /// In fr, this message translates to:
  /// **'Votre appétit a-t-il subi des changements notables ?'**
  String get q_hlth_appetite;

  /// No description provided for @q_env_noise.
  ///
  /// In fr, this message translates to:
  /// **'Votre environnement quotidien est-il trop bruyant ou agité ?'**
  String get q_env_noise;

  /// No description provided for @q_env_housing.
  ///
  /// In fr, this message translates to:
  /// **'Votre logement actuel vous apporte-t-il le confort nécessaire ?'**
  String get q_env_housing;

  /// No description provided for @q_safety_hopeless.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous l\'impression que rien ne pourra jamais s\'améliorer ?'**
  String get q_safety_hopeless;

  /// No description provided for @emotional_imbalance_detected.
  ///
  /// In fr, this message translates to:
  /// **'Signes d\'un déséquilibre émotionnel marqué.'**
  String get emotional_imbalance_detected;

  /// No description provided for @self_esteem_concerns.
  ///
  /// In fr, this message translates to:
  /// **'Préoccupations liées à l\'estime de soi.'**
  String get self_esteem_concerns;

  /// No description provided for @q_mgmt_emotions_control.
  ///
  /// In fr, this message translates to:
  /// **'Parvenez-vous à garder le contrôle sur vos émotions fortes ?'**
  String get q_mgmt_emotions_control;

  /// No description provided for @q_mgmt_calm_speed.
  ///
  /// In fr, this message translates to:
  /// **'Retrouvez-vous rapidement votre calme après un événement stressant ?'**
  String get q_mgmt_calm_speed;

  /// No description provided for @q_rel_communication.
  ///
  /// In fr, this message translates to:
  /// **'Est-il facile pour vous d\'exprimer vos besoins à votre entourage ?'**
  String get q_rel_communication;

  /// No description provided for @q_est_decision_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous confiance en votre capacité à prendre les bonnes décisions ?'**
  String get q_est_decision_confidence;

  /// No description provided for @q_est_future_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Vous sentez-vous capable d\'affronter les défis que l\'avenir vous réserve ?'**
  String get q_est_future_confidence;

  /// No description provided for @q_beh_procrastination.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous tendance à remettre les tâches importantes au lendemain ?'**
  String get q_beh_procrastination;

  /// No description provided for @q_beh_routine.
  ///
  /// In fr, this message translates to:
  /// **'Parvenez-vous à maintenir une routine quotidienne stable ?'**
  String get q_beh_routine;

  /// No description provided for @q_cog_memory.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous remarqué des oublis fréquents ou des difficultés de mémoire ?'**
  String get q_cog_memory;

  /// No description provided for @q_anx_panic.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous parfois des sensations de panique soudaine ?'**
  String get q_anx_panic;

  /// No description provided for @q_sleep_fatigue_day.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous une fatigue intense durant la journée ?'**
  String get q_sleep_fatigue_day;

  /// No description provided for @q_life_activity.
  ///
  /// In fr, this message translates to:
  /// **'Pratiquez-vous une activité physique régulière ?'**
  String get q_life_activity;

  /// No description provided for @q_soc_help_ease.
  ///
  /// In fr, this message translates to:
  /// **'Est-ce facile pour vous de solliciter l\'aide de votre entourage ?'**
  String get q_soc_help_ease;

  /// No description provided for @q_prod_pressure_academic.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous une pression excessive liée à vos études ?'**
  String get q_prod_pressure_academic;

  /// No description provided for @q_prod_pressure_work.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous une pression excessive liée à votre travail ?'**
  String get q_prod_pressure_work;

  /// No description provided for @q_prod_future_pressure.
  ///
  /// In fr, this message translates to:
  /// **'L\'incertitude quant à votre avenir professionnel vous inquiète-t-elle ?'**
  String get q_prod_future_pressure;

  /// No description provided for @q_spi_meaning.
  ///
  /// In fr, this message translates to:
  /// **'Avez-vous le sentiment que votre vie a un sens profond ?'**
  String get q_spi_meaning;

  /// No description provided for @q_spi_connection.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous une connexion spirituelle qui vous apaise ?'**
  String get q_spi_connection;

  /// No description provided for @rec_desc_text_stress.
  ///
  /// In fr, this message translates to:
  /// **'Ce conseil est proposé car vous avez mentionné vivre une période de stress intense.'**
  String get rec_desc_text_stress;

  /// No description provided for @rec_desc_text_functioning.
  ///
  /// In fr, this message translates to:
  /// **'Ce conseil est proposé suite à vos mentions de difficultés dans votre quotidien.'**
  String get rec_desc_text_functioning;

  /// No description provided for @rec_desc_text_social.
  ///
  /// In fr, this message translates to:
  /// **'Ce conseil est proposé car vous avez évoqué un sentiment d\'isolement.'**
  String get rec_desc_text_social;

  /// No description provided for @rec_desc_text_relationship.
  ///
  /// In fr, this message translates to:
  /// **'Ce conseil est proposé suite à vos partages concernant vos relations.'**
  String get rec_desc_text_relationship;

  /// No description provided for @rec_desc_text_spiritual.
  ///
  /// In fr, this message translates to:
  /// **'Ce conseil est proposé car vous recherchez un sens ou un soutien spirituel.'**
  String get rec_desc_text_spiritual;

  /// No description provided for @rec_desc_text_dailyPressures.
  ///
  /// In fr, this message translates to:
  /// **'Ce conseil est proposé car vous ressentez une forte pression actuellement.'**
  String get rec_desc_text_dailyPressures;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
