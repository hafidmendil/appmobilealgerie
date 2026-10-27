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
  /// **'Profil Clinique et Orientation'**
  String get resultsTitle;

  /// No description provided for @reportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Synthèse Clinique et Phénoménologique'**
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
  /// **'Évaluation Phénotypique et Clinique'**
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
  /// **'Recommandation Psycho-éducative'**
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
  /// **'Nous valorisons votre engagement dans ce processus d\'auto-évaluation. 🌿'**
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

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher...'**
  String get searchHint;

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
  /// **'Analyse Transversale des Indicateurs'**
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

  /// No description provided for @why_q_help.
  ///
  /// In fr, this message translates to:
  /// **'La capacité à demander du soutien est une force protectrice majeure.'**
  String get why_q_help;

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

  /// No description provided for @health_nutrition_title.
  ///
  /// In fr, this message translates to:
  /// **'Santé, Nutrition & Médecine Prophétique'**
  String get health_nutrition_title;

  /// No description provided for @select_wilaya_title.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner ma Wilaya'**
  String get select_wilaya_title;

  /// No description provided for @cat_nutrition.
  ///
  /// In fr, this message translates to:
  /// **'Nutrition'**
  String get cat_nutrition;

  /// No description provided for @cat_lifestyle.
  ///
  /// In fr, this message translates to:
  /// **'Hygiène de vie'**
  String get cat_lifestyle;

  /// No description provided for @cat_islamic_nutrition.
  ///
  /// In fr, this message translates to:
  /// **'Alimentation dans la tradition'**
  String get cat_islamic_nutrition;

  /// No description provided for @cat_prophetic_medicine.
  ///
  /// In fr, this message translates to:
  /// **'Médecine prophétique'**
  String get cat_prophetic_medicine;

  /// No description provided for @cat_traditional_plants.
  ///
  /// In fr, this message translates to:
  /// **'Plantes et aliments traditionnels'**
  String get cat_traditional_plants;

  /// No description provided for @cat_physical_wellbeing.
  ///
  /// In fr, this message translates to:
  /// **'Bien-être physique'**
  String get cat_physical_wellbeing;

  /// No description provided for @cat_psychological_wellbeing.
  ///
  /// In fr, this message translates to:
  /// **'Bien-être psychologique'**
  String get cat_psychological_wellbeing;

  /// No description provided for @cat_sleep_habits.
  ///
  /// In fr, this message translates to:
  /// **'Sommeil et habitudes'**
  String get cat_sleep_habits;

  /// No description provided for @cat_prevention.
  ///
  /// In fr, this message translates to:
  /// **'Prévention et habitudes saines'**
  String get cat_prevention;

  /// No description provided for @cat_scientific_research.
  ///
  /// In fr, this message translates to:
  /// **'Recherche scientifique'**
  String get cat_scientific_research;

  /// No description provided for @cat_sources.
  ///
  /// In fr, this message translates to:
  /// **'Sources et références'**
  String get cat_sources;

  /// No description provided for @evidence_traditional.
  ///
  /// In fr, this message translates to:
  /// **'Source : patrimoine / tradition'**
  String get evidence_traditional;

  /// No description provided for @evidence_religious.
  ///
  /// In fr, this message translates to:
  /// **'Source : religieuse'**
  String get evidence_religious;

  /// No description provided for @evidence_academic.
  ///
  /// In fr, this message translates to:
  /// **'Source : recherche scientifique'**
  String get evidence_academic;

  /// No description provided for @evidence_clinical.
  ///
  /// In fr, this message translates to:
  /// **'Source : données médicales'**
  String get evidence_clinical;

  /// No description provided for @evidence_review.
  ///
  /// In fr, this message translates to:
  /// **'Source : revue de littérature'**
  String get evidence_review;

  /// No description provided for @evidence_uncertain.
  ///
  /// In fr, this message translates to:
  /// **'Source : incertaine'**
  String get evidence_uncertain;

  /// No description provided for @read_more.
  ///
  /// In fr, this message translates to:
  /// **'Lire plus'**
  String get read_more;

  /// No description provided for @tradition_view.
  ///
  /// In fr, this message translates to:
  /// **'Ce que dit la source traditionnelle'**
  String get tradition_view;

  /// No description provided for @research_view.
  ///
  /// In fr, this message translates to:
  /// **'Ce que montrent les recherches'**
  String get research_view;

  /// No description provided for @medical_disclaimer.
  ///
  /// In fr, this message translates to:
  /// **'Cette information est éducative et ne remplace pas l\'avis d\'un professionnel de santé.'**
  String get medical_disclaimer;

  /// No description provided for @progress_beginner.
  ///
  /// In fr, this message translates to:
  /// **'Débutant'**
  String get progress_beginner;

  /// No description provided for @progress_explorer.
  ///
  /// In fr, this message translates to:
  /// **'Explorateur'**
  String get progress_explorer;

  /// No description provided for @progress_learner.
  ///
  /// In fr, this message translates to:
  /// **'Apprenant'**
  String get progress_learner;

  /// No description provided for @progress_connoisseur.
  ///
  /// In fr, this message translates to:
  /// **'Connaisseur'**
  String get progress_connoisseur;

  /// No description provided for @knowledge_management.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des connaissances'**
  String get knowledge_management;

  /// No description provided for @publish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get publish;

  /// No description provided for @draft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get draft;

  /// No description provided for @verify_source.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier la source'**
  String get verify_source;

  /// No description provided for @unverified_source.
  ///
  /// In fr, this message translates to:
  /// **'Source non vérifiée'**
  String get unverified_source;

  /// No description provided for @project_team_title.
  ///
  /// In fr, this message translates to:
  /// **'Équipe du projet'**
  String get project_team_title;

  /// No description provided for @expert_label.
  ///
  /// In fr, this message translates to:
  /// **'Expert'**
  String get expert_label;

  /// No description provided for @professor_label.
  ///
  /// In fr, this message translates to:
  /// **'Professeur'**
  String get professor_label;

  /// No description provided for @programmer_label.
  ///
  /// In fr, this message translates to:
  /// **'Programmeur'**
  String get programmer_label;

  /// No description provided for @professional_orientation.
  ///
  /// In fr, this message translates to:
  /// **'Orientation Professionnelle'**
  String get professional_orientation;

  /// No description provided for @search_resources_wilaya.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez votre wilaya pour trouver des ressources adaptées.'**
  String get search_resources_wilaya;

  /// No description provided for @choose_wilaya.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une wilaya'**
  String get choose_wilaya;

  /// No description provided for @professionals.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels'**
  String get professionals;

  /// No description provided for @centers.
  ///
  /// In fr, this message translates to:
  /// **'Centres'**
  String get centers;

  /// No description provided for @no_results_wilaya.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat trouvé pour {wilaya}'**
  String no_results_wilaya(Object wilaya);

  /// No description provided for @orientation_level_4_title.
  ///
  /// In fr, this message translates to:
  /// **'Urgence Psychiatrique / Risque Vital'**
  String get orientation_level_4_title;

  /// No description provided for @orientation_level_4_text.
  ///
  /// In fr, this message translates to:
  /// **'Une intervention clinique immédiate est requise. Veuillez contacter sans délai un service d\'urgence ou un praticien référent.'**
  String get orientation_level_4_text;

  /// No description provided for @orientation_level_3_title.
  ///
  /// In fr, this message translates to:
  /// **'Orientation Clinique Spécialisée'**
  String get orientation_level_3_title;

  /// No description provided for @orientation_level_3_text.
  ///
  /// In fr, this message translates to:
  /// **'Le profil clinique présente des indicateurs significatifs nécessitant une investigation diagnostique par un professionnel qualifié.'**
  String get orientation_level_3_text;

  /// No description provided for @orientation_level_2_title.
  ///
  /// In fr, this message translates to:
  /// **'Vigilance et Accompagnement'**
  String get orientation_level_2_title;

  /// No description provided for @orientation_level_2_text.
  ///
  /// In fr, this message translates to:
  /// **'Présence de stresseurs impactant la régulation émotionnelle. Un soutien psychothérapeutique est suggéré pour prévenir une décompensation.'**
  String get orientation_level_2_text;

  /// No description provided for @orientation_level_1_title.
  ///
  /// In fr, this message translates to:
  /// **'Équilibre et Régulation'**
  String get orientation_level_1_title;

  /// No description provided for @orientation_level_1_text.
  ///
  /// In fr, this message translates to:
  /// **'Les mécanismes de défense et les facteurs de protection semblent opérants. Continuez le renforcement des ressources adaptatives.'**
  String get orientation_level_1_text;

  /// No description provided for @orientation_level_0_title.
  ///
  /// In fr, this message translates to:
  /// **'Stabilité Homéostatique'**
  String get orientation_level_0_title;

  /// No description provided for @orientation_level_0_text.
  ///
  /// In fr, this message translates to:
  /// **'Absence de symptomatologie clinique majeure. Le maintien des stratégies de coping actuelles est préconisé.'**
  String get orientation_level_0_text;

  /// No description provided for @empathy_message.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour votre confiance. Nous apprécions votre courage à partager vos ressentis.'**
  String get empathy_message;

  /// No description provided for @clinical_analysis_title.
  ///
  /// In fr, this message translates to:
  /// **'Analyse des indicateurs cliniques :'**
  String get clinical_analysis_title;

  /// No description provided for @focus_areas_title.
  ///
  /// In fr, this message translates to:
  /// **'Principaux axes d\'attention :'**
  String get focus_areas_title;

  /// No description provided for @spiritual_pause_title.
  ///
  /// In fr, this message translates to:
  /// **'Pause de sérénité'**
  String get spiritual_pause_title;

  /// No description provided for @week_plan_title.
  ///
  /// In fr, this message translates to:
  /// **'Votre plan pour la semaine prochaine'**
  String get week_plan_title;

  /// No description provided for @day_label.
  ///
  /// In fr, this message translates to:
  /// **'Jour'**
  String get day_label;

  /// No description provided for @search_pro_nearby.
  ///
  /// In fr, this message translates to:
  /// **'Chercher un professionnel ou un centre à proximité'**
  String get search_pro_nearby;

  /// No description provided for @back_to_home.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get back_to_home;

  /// No description provided for @disclaimer_text.
  ///
  /// In fr, this message translates to:
  /// **'Note : Cette évaluation repose sur des indicateurs psycho-métriques et ne saurait se substituer à une anamnèse clinique réalisée par un praticien.'**
  String get disclaimer_text;

  /// No description provided for @high_need_alert.
  ///
  /// In fr, this message translates to:
  /// **'Alerte élevée dans le domaine : {axis}'**
  String high_need_alert(Object axis);

  /// No description provided for @moderate_need_alert.
  ///
  /// In fr, this message translates to:
  /// **'Alerte modérée dans le domaine : {axis}'**
  String moderate_need_alert(Object axis);

  /// No description provided for @error_fill_all_fields.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs'**
  String get error_fill_all_fields;

  /// No description provided for @error_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: '**
  String get error_prefix;

  /// No description provided for @error_user_not_found.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non trouvé'**
  String get error_user_not_found;

  /// No description provided for @already_have_account.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Connexion'**
  String get already_have_account;

  /// No description provided for @forgot_password_label.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgot_password_label;

  /// No description provided for @login_button.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login_button;

  /// No description provided for @register_button.
  ///
  /// In fr, this message translates to:
  /// **'S\'inscrire'**
  String get register_button;

  /// No description provided for @axis_emotions.
  ///
  /// In fr, this message translates to:
  /// **'Régulation Affective'**
  String get axis_emotions;

  /// No description provided for @axis_stress.
  ///
  /// In fr, this message translates to:
  /// **'Tension Psychique et Anxiété'**
  String get axis_stress;

  /// No description provided for @axis_sleep.
  ///
  /// In fr, this message translates to:
  /// **'Cycles Veille-Sommeil et Énergie'**
  String get axis_sleep;

  /// No description provided for @axis_productivity.
  ///
  /// In fr, this message translates to:
  /// **'Fonctions Exécutives et Efficience'**
  String get axis_productivity;

  /// No description provided for @axis_social.
  ///
  /// In fr, this message translates to:
  /// **'Sphère Relationnelle et Soutien'**
  String get axis_social;

  /// No description provided for @axis_anger.
  ///
  /// In fr, this message translates to:
  /// **'Contrôle des Impulsions'**
  String get axis_anger;

  /// No description provided for @axis_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Estime de Soi et Auto-efficacité'**
  String get axis_confidence;

  /// No description provided for @axis_pressures.
  ///
  /// In fr, this message translates to:
  /// **'Charge Mentale et Adaptabilité'**
  String get axis_pressures;

  /// No description provided for @axis_lifestyle.
  ///
  /// In fr, this message translates to:
  /// **'Hygiène de Vie et Rythmes'**
  String get axis_lifestyle;

  /// No description provided for @axis_safety.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité et Intégrité Psychique'**
  String get axis_safety;

  /// No description provided for @axis_spiritual.
  ///
  /// In fr, this message translates to:
  /// **'Dimension Existentielle et Spirituelle'**
  String get axis_spiritual;

  /// No description provided for @my_profile.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get my_profile;

  /// No description provided for @my_journey.
  ///
  /// In fr, this message translates to:
  /// **'Mon Parcours'**
  String get my_journey;

  /// No description provided for @assessment_history.
  ///
  /// In fr, this message translates to:
  /// **'Historique des évaluations'**
  String get assessment_history;

  /// No description provided for @select_wilaya_label.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner ma Wilaya'**
  String get select_wilaya_label;

  /// No description provided for @wilaya_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Wilaya : {name}'**
  String wilaya_prefix(Object name);

  /// No description provided for @preferences_label.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get preferences_label;

  /// No description provided for @spiritual_content_label.
  ///
  /// In fr, this message translates to:
  /// **'Contenu spirituel'**
  String get spiritual_content_label;

  /// No description provided for @settings_label.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings_label;

  /// No description provided for @language_label.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language_label;

  /// No description provided for @security_privacy_label.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité & Confidentialité'**
  String get security_privacy_label;

  /// No description provided for @privacy_label.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get privacy_label;

  /// No description provided for @delete_data_label.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mes données'**
  String get delete_data_label;

  /// No description provided for @logout_label.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logout_label;

  /// No description provided for @change_language_title.
  ///
  /// In fr, this message translates to:
  /// **'Changer la langue'**
  String get change_language_title;

  /// No description provided for @application_section.
  ///
  /// In fr, this message translates to:
  /// **'Application'**
  String get application_section;

  /// No description provided for @dark_mode_label.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get dark_mode_label;

  /// No description provided for @auto_mode_label.
  ///
  /// In fr, this message translates to:
  /// **'Automatique'**
  String get auto_mode_label;

  /// No description provided for @notifications_section.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications_section;

  /// No description provided for @daily_reminders_label.
  ///
  /// In fr, this message translates to:
  /// **'Rappels quotidiens'**
  String get daily_reminders_label;

  /// No description provided for @support_section.
  ///
  /// In fr, this message translates to:
  /// **'Support'**
  String get support_section;

  /// No description provided for @help_faq_label.
  ///
  /// In fr, this message translates to:
  /// **'Aide & FAQ'**
  String get help_faq_label;

  /// No description provided for @about_label.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about_label;

  /// No description provided for @french_label.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get french_label;

  /// No description provided for @arabic_label.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get arabic_label;

  /// No description provided for @my_progress.
  ///
  /// In fr, this message translates to:
  /// **'Ma Progression'**
  String get my_progress;

  /// No description provided for @wellbeing_evolution.
  ///
  /// In fr, this message translates to:
  /// **'Évolution du Bien-être'**
  String get wellbeing_evolution;

  /// No description provided for @weekly_goals.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs de la semaine'**
  String get weekly_goals;

  /// No description provided for @respiration_goal.
  ///
  /// In fr, this message translates to:
  /// **'3 séances de respiration'**
  String get respiration_goal;

  /// No description provided for @spiritual_goal.
  ///
  /// In fr, this message translates to:
  /// **'Lire un verset inspirant par jour'**
  String get spiritual_goal;

  /// No description provided for @social_goal.
  ///
  /// In fr, this message translates to:
  /// **'Appeler un proche'**
  String get social_goal;

  /// No description provided for @level_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level} - {title}'**
  String level_prefix(Object level, Object title);

  /// No description provided for @pts_to_next.
  ///
  /// In fr, this message translates to:
  /// **'{pts} pts avant le prochain niveau'**
  String pts_to_next(Object pts);

  /// No description provided for @chart_placeholder.
  ///
  /// In fr, this message translates to:
  /// **'Graphique d\'évolution à venir'**
  String get chart_placeholder;

  /// No description provided for @patient_details_title.
  ///
  /// In fr, this message translates to:
  /// **'Détails Patient {id}'**
  String patient_details_title(Object id);

  /// No description provided for @expert_module_info.
  ///
  /// In fr, this message translates to:
  /// **'Informations détaillées du suivi (Module expert)'**
  String get expert_module_info;

  /// No description provided for @app_version.
  ///
  /// In fr, this message translates to:
  /// **'Version de l\'application'**
  String get app_version;

  /// No description provided for @environment.
  ///
  /// In fr, this message translates to:
  /// **'Environnement'**
  String get environment;

  /// No description provided for @add_knowledge.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une connaissance'**
  String get add_knowledge;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @add_member.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get add_member;

  /// No description provided for @continue_to_consent.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers le consentement'**
  String get continue_to_consent;

  /// No description provided for @all_wilayas.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les Wilayas'**
  String get all_wilayas;

  /// No description provided for @whatsapp_error.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir WhatsApp'**
  String get whatsapp_error;

  /// No description provided for @confidence_journal.
  ///
  /// In fr, this message translates to:
  /// **'Journal de Confiance'**
  String get confidence_journal;

  /// No description provided for @spiritual_dimension.
  ///
  /// In fr, this message translates to:
  /// **'Dimension Spirituelle'**
  String get spiritual_dimension;

  /// No description provided for @services_tab.
  ///
  /// In fr, this message translates to:
  /// **'Services'**
  String get services_tab;

  /// No description provided for @professionals_tab.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels'**
  String get professionals_tab;

  /// No description provided for @library_tab.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque'**
  String get library_tab;

  /// No description provided for @filter_wilaya.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par Wilaya'**
  String get filter_wilaya;

  /// No description provided for @no_professionals_found.
  ///
  /// In fr, this message translates to:
  /// **'Aucun professionnel trouvé.'**
  String get no_professionals_found;

  /// No description provided for @quran_verse_title.
  ///
  /// In fr, this message translates to:
  /// **'Verset Coranique'**
  String get quran_verse_title;

  /// No description provided for @hadith_title.
  ///
  /// In fr, this message translates to:
  /// **'Hadith'**
  String get hadith_title;

  /// No description provided for @resource_title.
  ///
  /// In fr, this message translates to:
  /// **'Ressource'**
  String get resource_title;

  /// No description provided for @contact_whatsapp.
  ///
  /// In fr, this message translates to:
  /// **'Contacter sur WhatsApp'**
  String get contact_whatsapp;

  /// No description provided for @phone_label.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone_label;

  /// No description provided for @assessment_app_bar_title.
  ///
  /// In fr, this message translates to:
  /// **'SIND 🤍'**
  String get assessment_app_bar_title;

  /// No description provided for @clinical_question_label.
  ///
  /// In fr, this message translates to:
  /// **'Question clinique'**
  String get clinical_question_label;

  /// No description provided for @result_understanding_title.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre vos résultats'**
  String get result_understanding_title;

  /// No description provided for @current_clinical_profile.
  ///
  /// In fr, this message translates to:
  /// **'Votre profil clinique actuel'**
  String get current_clinical_profile;

  /// No description provided for @resilience_warrior.
  ///
  /// In fr, this message translates to:
  /// **'Guerrier de la Résilience'**
  String get resilience_warrior;

  /// No description provided for @strength_engine.
  ///
  /// In fr, this message translates to:
  /// **'Moteur de Force'**
  String get strength_engine;

  /// No description provided for @haven_of_peace.
  ///
  /// In fr, this message translates to:
  /// **'Havre de Paix'**
  String get haven_of_peace;

  /// No description provided for @synthesis_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Sur la base de votre analyse clinique, '**
  String get synthesis_prefix;

  /// No description provided for @synthesis_vicious_cycle.
  ///
  /// In fr, this message translates to:
  /// **'nous observons un cercle vicieux entre un stress élevé et une altération du sommeil, ce qui épuise vos ressources neurobiologiques. '**
  String get synthesis_vicious_cycle;

  /// No description provided for @synthesis_mental_load.
  ///
  /// In fr, this message translates to:
  /// **'la charge mentale actuelle impacte directement vos capacités cognitives et votre concentration, suggérant un risque d\'épuisement. '**
  String get synthesis_mental_load;

  /// No description provided for @synthesis_high_emotions.
  ///
  /// In fr, this message translates to:
  /// **'Une dysrégulation affective marquée est identifiée.'**
  String get synthesis_high_emotions;

  /// No description provided for @synthesis_high_anxiety.
  ///
  /// In fr, this message translates to:
  /// **'Le niveau d\'anxiété dépasse les capacités d\'adaptation habituelles.'**
  String get synthesis_high_anxiety;

  /// No description provided for @synthesis_high_isolation.
  ///
  /// In fr, this message translates to:
  /// **'Le sentiment d\'isolement social semble profond et impactant.'**
  String get synthesis_high_isolation;

  /// No description provided for @synthesis_unstable_sleep.
  ///
  /// In fr, this message translates to:
  /// **'La qualité du sommeil est instable, impactant votre vitalité quotidienne.'**
  String get synthesis_unstable_sleep;

  /// No description provided for @synthesis_impulse_control.
  ///
  /// In fr, this message translates to:
  /// **'Des difficultés de contrôle des impulsions émergent sous pression.'**
  String get synthesis_impulse_control;

  /// No description provided for @synthesis_good_confidence.
  ///
  /// In fr, this message translates to:
  /// **'Cependant, la préservation de votre estime de soi constitue un levier majeur pour votre rétablissement.'**
  String get synthesis_good_confidence;

  /// No description provided for @synthesis_need_strategies.
  ///
  /// In fr, this message translates to:
  /// **'Il est essentiel de mettre en place les stratégies d\'apaisement préconisées.'**
  String get synthesis_need_strategies;

  /// No description provided for @quran_verse_label.
  ///
  /// In fr, this message translates to:
  /// **'Verset Coranique - {theme}'**
  String quran_verse_label(Object theme);

  /// No description provided for @hadith_label.
  ///
  /// In fr, this message translates to:
  /// **'Hadith - {theme}'**
  String hadith_label(Object theme);

  /// No description provided for @hikma_label.
  ///
  /// In fr, this message translates to:
  /// **'Sagesse - {author}'**
  String hikma_label(Object author);

  /// No description provided for @default_task_1.
  ///
  /// In fr, this message translates to:
  /// **'Prendre un moment pour soi.'**
  String get default_task_1;

  /// No description provided for @default_task_2.
  ///
  /// In fr, this message translates to:
  /// **'Observer ses pensées.'**
  String get default_task_2;

  /// No description provided for @default_task_3.
  ///
  /// In fr, this message translates to:
  /// **'Respirer calmement.'**
  String get default_task_3;

  /// No description provided for @default_task_4.
  ///
  /// In fr, this message translates to:
  /// **'Sourire à quelqu\'un.'**
  String get default_task_4;

  /// No description provided for @default_task_5.
  ///
  /// In fr, this message translates to:
  /// **'Écrire une gratitude.'**
  String get default_task_5;

  /// No description provided for @default_task_6.
  ///
  /// In fr, this message translates to:
  /// **'Se reposer tôt.'**
  String get default_task_6;

  /// No description provided for @default_task_7.
  ///
  /// In fr, this message translates to:
  /// **'Bilan positif.'**
  String get default_task_7;

  /// No description provided for @stress_task_1.
  ///
  /// In fr, this message translates to:
  /// **'Identifier un déclencheur de stress.'**
  String get stress_task_1;

  /// No description provided for @stress_task_2.
  ///
  /// In fr, this message translates to:
  /// **'Pratiquer 5 min de respiration.'**
  String get stress_task_2;

  /// No description provided for @stress_task_3.
  ///
  /// In fr, this message translates to:
  /// **'Prioriser 3 tâches seulement.'**
  String get stress_task_3;

  /// No description provided for @stress_task_4.
  ///
  /// In fr, this message translates to:
  /// **'Prendre une pause sans écran.'**
  String get stress_task_4;

  /// No description provided for @stress_task_5.
  ///
  /// In fr, this message translates to:
  /// **'Parler de sa tension à un proche.'**
  String get stress_task_5;

  /// No description provided for @stress_task_6.
  ///
  /// In fr, this message translates to:
  /// **'Faire une activité relaxante.'**
  String get stress_task_6;

  /// No description provided for @stress_task_7.
  ///
  /// In fr, this message translates to:
  /// **'Bilan : qu\'est-ce qui m\'a apaisé ?'**
  String get stress_task_7;

  /// No description provided for @confidence_task_1.
  ///
  /// In fr, this message translates to:
  /// **'Noter une petite réussite.'**
  String get confidence_task_1;

  /// No description provided for @confidence_task_2.
  ///
  /// In fr, this message translates to:
  /// **'Se dire une phrase positive.'**
  String get confidence_task_2;

  /// No description provided for @confidence_task_3.
  ///
  /// In fr, this message translates to:
  /// **'Identifier une de ses forces.'**
  String get confidence_task_3;

  /// No description provided for @confidence_task_4.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter de se comparer aujourd\'hui.'**
  String get confidence_task_4;

  /// No description provided for @confidence_task_5.
  ///
  /// In fr, this message translates to:
  /// **'Faire quelque chose qui rend fier.'**
  String get confidence_task_5;

  /// No description provided for @confidence_task_6.
  ///
  /// In fr, this message translates to:
  /// **'Accepter un compliment.'**
  String get confidence_task_6;

  /// No description provided for @confidence_task_7.
  ///
  /// In fr, this message translates to:
  /// **'Bilan : je suis capable de...'**
  String get confidence_task_7;

  /// No description provided for @general_task_1.
  ///
  /// In fr, this message translates to:
  /// **'Observer son humeur du jour.'**
  String get general_task_1;

  /// No description provided for @general_task_2.
  ///
  /// In fr, this message translates to:
  /// **'Boire assez d\'eau et bien manger.'**
  String get general_task_2;

  /// No description provided for @general_task_3.
  ///
  /// In fr, this message translates to:
  /// **'Marcher 15 minutes.'**
  String get general_task_3;

  /// No description provided for @general_task_4.
  ///
  /// In fr, this message translates to:
  /// **'Appeler un ami.'**
  String get general_task_4;

  /// No description provided for @general_task_5.
  ///
  /// In fr, this message translates to:
  /// **'Écrire ses pensées.'**
  String get general_task_5;

  /// No description provided for @general_task_6.
  ///
  /// In fr, this message translates to:
  /// **'Se coucher à une heure fixe.'**
  String get general_task_6;

  /// No description provided for @achievement_badge_label.
  ///
  /// In fr, this message translates to:
  /// **'Badge d\'accomplissement'**
  String get achievement_badge_label;

  /// No description provided for @content_management_title.
  ///
  /// In fr, this message translates to:
  /// **'Gestion du Contenu'**
  String get content_management_title;

  /// No description provided for @quran_library_title.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque Coranique'**
  String get quran_library_title;

  /// No description provided for @quran_library_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les versets et thèmes'**
  String get quran_library_subtitle;

  /// No description provided for @hadith_library_title.
  ///
  /// In fr, this message translates to:
  /// **'Hadiths & Hikam'**
  String get hadith_library_title;

  /// No description provided for @hadith_library_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les sagesses et sources'**
  String get hadith_library_subtitle;

  /// No description provided for @health_library_title.
  ///
  /// In fr, this message translates to:
  /// **'Santé & Nutrition'**
  String get health_library_title;

  /// No description provided for @health_library_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer la bibliothèque éducative'**
  String get health_library_subtitle;

  /// No description provided for @project_team_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les membres et contacts'**
  String get project_team_subtitle;

  /// No description provided for @assessment_logic_title.
  ///
  /// In fr, this message translates to:
  /// **'Questionnaire & Logique'**
  String get assessment_logic_title;

  /// No description provided for @assessment_logic_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier les questions et l\'algorithme'**
  String get assessment_logic_subtitle;

  /// No description provided for @communications_title.
  ///
  /// In fr, this message translates to:
  /// **'Communications'**
  String get communications_title;

  /// No description provided for @communications_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Chat avec Psychologues & Clients'**
  String get communications_subtitle;

  /// No description provided for @action_success.
  ///
  /// In fr, this message translates to:
  /// **'Action effectuée avec succès'**
  String get action_success;

  /// No description provided for @action_error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {error}'**
  String action_error(Object error);

  /// No description provided for @algorithm_config_title.
  ///
  /// In fr, this message translates to:
  /// **'Configuration de l\'Algorithme'**
  String get algorithm_config_title;

  /// No description provided for @algorithm_config_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérez les questions et les poids de l\'algorithme NeuroSync.'**
  String get algorithm_config_subtitle;

  /// No description provided for @add_question.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une question'**
  String get add_question;

  /// No description provided for @edit_question.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la question'**
  String get edit_question;

  /// No description provided for @reset_algorithm_confirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous réinitialiser l\'algorithme ? Cela effacera toutes les questions personnalisées.'**
  String get reset_algorithm_confirm;

  /// No description provided for @delete_question_confirm.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous supprimer cette question ?'**
  String get delete_question_confirm;

  /// No description provided for @general_task_7.
  ///
  /// In fr, this message translates to:
  /// **'Planifier un moment de joie demain.'**
  String get general_task_7;

  /// No description provided for @my_appointments.
  ///
  /// In fr, this message translates to:
  /// **'Mes brouillons de rendez-vous'**
  String get my_appointments;

  /// No description provided for @no_appointments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun brouillon de rendez-vous enregistré sur cet appareil.'**
  String get no_appointments;

  /// No description provided for @request_session.
  ///
  /// In fr, this message translates to:
  /// **'Demander une séance'**
  String get request_session;

  /// No description provided for @confirm_request.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la demande'**
  String get confirm_request;

  /// No description provided for @requested_date.
  ///
  /// In fr, this message translates to:
  /// **'Date souhaitée'**
  String get requested_date;

  /// No description provided for @optional_message.
  ///
  /// In fr, this message translates to:
  /// **'Message (facultatif)'**
  String get optional_message;

  /// No description provided for @session_in_person.
  ///
  /// In fr, this message translates to:
  /// **'Présentiel'**
  String get session_in_person;

  /// No description provided for @session_online.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get session_online;

  /// No description provided for @session_home.
  ///
  /// In fr, this message translates to:
  /// **'Domicile'**
  String get session_home;

  /// No description provided for @session_type.
  ///
  /// In fr, this message translates to:
  /// **'Type de séance'**
  String get session_type;

  /// No description provided for @consent_transmission_info.
  ///
  /// In fr, this message translates to:
  /// **'Cette version enregistre uniquement un brouillon local. Aucune information n\'est transmise au professionnel.'**
  String get consent_transmission_info;

  /// No description provided for @consent_transmission_accept.
  ///
  /// In fr, this message translates to:
  /// **'Je comprends que ce brouillon reste sur cet appareil.'**
  String get consent_transmission_accept;

  /// No description provided for @confirm_send.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le brouillon'**
  String get confirm_send;

  /// No description provided for @confirm_send_prompt.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous enregistrer ce brouillon sur cet appareil ?'**
  String get confirm_send_prompt;

  /// No description provided for @professional_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel : '**
  String get professional_prefix;

  /// No description provided for @date_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Date : '**
  String get date_prefix;

  /// No description provided for @type_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Type : '**
  String get type_prefix;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @user_not_connected.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non connecté'**
  String get user_not_connected;

  /// No description provided for @request_sent_success.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon enregistré sur cet appareil.'**
  String get request_sent_success;

  /// No description provided for @sort.
  ///
  /// In fr, this message translates to:
  /// **'Trier'**
  String get sort;

  /// No description provided for @sort_by.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get sort_by;

  /// No description provided for @sort_name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get sort_name;

  /// No description provided for @sort_specialty.
  ///
  /// In fr, this message translates to:
  /// **'Spécialité'**
  String get sort_specialty;

  /// No description provided for @add_to_message.
  ///
  /// In fr, this message translates to:
  /// **'Préparer un suivi local'**
  String get add_to_message;

  /// No description provided for @login_to_add_psy.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour ajouter un psychologue.'**
  String get login_to_add_psy;

  /// No description provided for @not_connected.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté'**
  String get not_connected;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @languages.
  ///
  /// In fr, this message translates to:
  /// **'Langues'**
  String get languages;

  /// No description provided for @not_specified.
  ///
  /// In fr, this message translates to:
  /// **'Non spécifié'**
  String get not_specified;

  /// No description provided for @biography.
  ///
  /// In fr, this message translates to:
  /// **'Biographie'**
  String get biography;

  /// No description provided for @no_biography_available.
  ///
  /// In fr, this message translates to:
  /// **'Aucune biographie disponible'**
  String get no_biography_available;

  /// No description provided for @map.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get map;

  /// No description provided for @prot_home_title.
  ///
  /// In fr, this message translates to:
  /// **'Protection et orientation'**
  String get prot_home_title;

  /// No description provided for @prot_danger_now.
  ///
  /// In fr, this message translates to:
  /// **'Je suis en danger maintenant'**
  String get prot_danger_now;

  /// No description provided for @prot_understand_violence.
  ///
  /// In fr, this message translates to:
  /// **'Je souhaite comprendre une situation de violence'**
  String get prot_understand_violence;

  /// No description provided for @prot_legal_orientation.
  ///
  /// In fr, this message translates to:
  /// **'Module d\'Orientation Juridique'**
  String get prot_legal_orientation;

  /// No description provided for @prot_report_situation.
  ///
  /// In fr, this message translates to:
  /// **'Signaler une situation'**
  String get prot_report_situation;

  /// No description provided for @prot_privacy.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get prot_privacy;

  /// No description provided for @prot_breathing_exercise.
  ///
  /// In fr, this message translates to:
  /// **'Exercice de respiration'**
  String get prot_breathing_exercise;

  /// No description provided for @prot_verified_resources.
  ///
  /// In fr, this message translates to:
  /// **'Ressources vérifiées'**
  String get prot_verified_resources;

  /// No description provided for @prot_local_reports.
  ///
  /// In fr, this message translates to:
  /// **'Mes signalements locaux'**
  String get prot_local_reports;

  /// No description provided for @prot_safety_plan.
  ///
  /// In fr, this message translates to:
  /// **'Plan de sécurité'**
  String get prot_safety_plan;

  /// No description provided for @prot_vocal_exercise.
  ///
  /// In fr, this message translates to:
  /// **'Exercice vocal optionnel'**
  String get prot_vocal_exercise;

  /// No description provided for @emg_immediate_help.
  ///
  /// In fr, this message translates to:
  /// **'Aide immédiate'**
  String get emg_immediate_help;

  /// No description provided for @emg_safety_first.
  ///
  /// In fr, this message translates to:
  /// **'Votre sécurité d’abord.'**
  String get emg_safety_first;

  /// No description provided for @emg_danger_desc.
  ///
  /// In fr, this message translates to:
  /// **'Si le danger est actuel, mettez-vous à l’abri et contactez le service d’urgence officiellement vérifié de votre pays. Cette application ne remplace pas les services d’urgence.'**
  String get emg_danger_desc;

  /// No description provided for @emg_no_number.
  ///
  /// In fr, this message translates to:
  /// **'Numéro d’urgence non configuré'**
  String get emg_no_number;

  /// No description provided for @emg_no_contact.
  ///
  /// In fr, this message translates to:
  /// **'Personne de confiance non configurée'**
  String get emg_no_contact;

  /// No description provided for @emg_quick_exit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter rapidement'**
  String get emg_quick_exit;

  /// No description provided for @local_reports_title.
  ///
  /// In fr, this message translates to:
  /// **'Mes signalements locaux'**
  String get local_reports_title;

  /// No description provided for @local_reports_empty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun signalement enregistré.'**
  String get local_reports_empty;

  /// No description provided for @local_report_item.
  ///
  /// In fr, this message translates to:
  /// **'Signalement enregistré localement'**
  String get local_report_item;

  /// No description provided for @safety_plan_title.
  ///
  /// In fr, this message translates to:
  /// **'Plan de sécurité local'**
  String get safety_plan_title;

  /// No description provided for @safety_plan_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Un plan court et prudent'**
  String get safety_plan_subtitle;

  /// No description provided for @safety_plan_warning.
  ///
  /// In fr, this message translates to:
  /// **'N’enregistrez aucune information qui pourrait vous mettre en danger si l’appareil est partagé.'**
  String get safety_plan_warning;

  /// No description provided for @safety_plan_reach_safe.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre un lieu sûr'**
  String get safety_plan_reach_safe;

  /// No description provided for @safety_plan_contact_trust.
  ///
  /// In fr, this message translates to:
  /// **'Contacter une personne de confiance'**
  String get safety_plan_contact_trust;

  /// No description provided for @safety_plan_delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le plan de l’appareil'**
  String get safety_plan_delete;

  /// No description provided for @voice_analysis_title.
  ///
  /// In fr, this message translates to:
  /// **'Analyse vocale intelligente'**
  String get voice_analysis_title;

  /// No description provided for @voice_analysis_confidential.
  ///
  /// In fr, this message translates to:
  /// **'Ce test est confidentiel et automatisé. Votre voix n’est enregistrée sur aucun serveur externe.'**
  String get voice_analysis_confidential;

  /// No description provided for @voice_analysis_language.
  ///
  /// In fr, this message translates to:
  /// **'Langue d\'expression :'**
  String get voice_analysis_language;

  /// No description provided for @voice_analysis_instruction.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur le micro et parlez pendant 5 à 10 secondes'**
  String get voice_analysis_instruction;

  /// No description provided for @voice_analysis_analyzing.
  ///
  /// In fr, this message translates to:
  /// **'Analyse des biomarqueurs vocaux...'**
  String get voice_analysis_analyzing;

  /// No description provided for @voice_analysis_completed.
  ///
  /// In fr, this message translates to:
  /// **'Analyse complétée !'**
  String get voice_analysis_completed;

  /// No description provided for @voice_analysis_ready.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à enregistrer'**
  String get voice_analysis_ready;

  /// No description provided for @voice_analysis_results_title.
  ///
  /// In fr, this message translates to:
  /// **'Résultats du pré-diagnostic vocal'**
  String get voice_analysis_results_title;

  /// No description provided for @voice_analysis_transcription.
  ///
  /// In fr, this message translates to:
  /// **'Transcription (Darja/STT) :'**
  String get voice_analysis_transcription;

  /// No description provided for @voice_analysis_stress_index.
  ///
  /// In fr, this message translates to:
  /// **'Indice de stress'**
  String get voice_analysis_stress_index;

  /// No description provided for @voice_analysis_emotional_state.
  ///
  /// In fr, this message translates to:
  /// **'État émotionnel'**
  String get voice_analysis_emotional_state;

  /// No description provided for @voice_analysis_vocal_stability.
  ///
  /// In fr, this message translates to:
  /// **'Stabilité vocale'**
  String get voice_analysis_vocal_stability;

  /// No description provided for @voice_analysis_recommendation.
  ///
  /// In fr, this message translates to:
  /// **'Recommandation : Votre voix indique un stress modéré. Nous vous conseillons de faire un exercice de respiration ou de consulter un psychologue partenaire.'**
  String get voice_analysis_recommendation;

  /// No description provided for @voice_analysis_prefer_write.
  ///
  /// In fr, this message translates to:
  /// **'Vous préférez écrire ?'**
  String get voice_analysis_prefer_write;

  /// No description provided for @voice_analysis_write_hint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez ce que vous ressentez ici...'**
  String get voice_analysis_write_hint;

  /// No description provided for @voice_analysis_save_note.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la note'**
  String get voice_analysis_save_note;

  /// No description provided for @voice_analysis_note_saved.
  ///
  /// In fr, this message translates to:
  /// **'Note enregistrée avec succès.'**
  String get voice_analysis_note_saved;

  /// No description provided for @report_nature.
  ///
  /// In fr, this message translates to:
  /// **'Quelle est la nature de la situation ?'**
  String get report_nature;

  /// No description provided for @report_in_danger.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous en danger maintenant ?'**
  String get report_in_danger;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @prefer_not_to_answer.
  ///
  /// In fr, this message translates to:
  /// **'Je préfère ne pas répondre'**
  String get prefer_not_to_answer;

  /// No description provided for @saving.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement...'**
  String get saving;

  /// No description provided for @save_encrypted.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer chiffré'**
  String get save_encrypted;

  /// No description provided for @orientation.
  ///
  /// In fr, this message translates to:
  /// **'Orientation'**
  String get orientation;

  /// No description provided for @continue_action.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continue_action;

  /// No description provided for @auto_franais.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get auto_franais;

  /// No description provided for @auto_auto_text_0.
  ///
  /// In fr, this message translates to:
  /// **'العربية'**
  String get auto_auto_text_0;

  /// No description provided for @auto_neurosync_orientation.
  ///
  /// In fr, this message translates to:
  /// **'NeuroSync — Orientation'**
  String get auto_neurosync_orientation;

  /// No description provided for @auto_veuillez_entrer_une_adresse.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez entrer une adresse email valide'**
  String get auto_veuillez_entrer_une_adresse;

  /// No description provided for @auto_mot_passe_doit_faire.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit faire au moins 6 caractères'**
  String get auto_mot_passe_doit_faire;

  /// No description provided for @auto_dtails_patient.
  ///
  /// In fr, this message translates to:
  /// **'Détails du Patient'**
  String get auto_dtails_patient;

  /// No description provided for @auto_patient_introuvable.
  ///
  /// In fr, this message translates to:
  /// **'Patient introuvable'**
  String get auto_patient_introuvable;

  /// No description provided for @auto_auto_text_676.
  ///
  /// In fr, this message translates to:
  /// **'الدّارجة الجزائرية'**
  String get auto_auto_text_676;

  /// No description provided for @auto_auto_text_676_1.
  ///
  /// In fr, this message translates to:
  /// **'العربية الفصحى'**
  String get auto_auto_text_676_1;

  /// No description provided for @auto_aucun_brouillon_signalement_cours.
  ///
  /// In fr, this message translates to:
  /// **'Aucun brouillon de signalement en cours.'**
  String get auto_aucun_brouillon_signalement_cours;

  /// No description provided for @auto_crer_une_orientation.
  ///
  /// In fr, this message translates to:
  /// **'Créer une orientation'**
  String get auto_crer_une_orientation;

  /// No description provided for @auto_prparation_signalement_report_builder.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du Signalement (Report Builder)'**
  String get auto_prparation_signalement_report_builder;

  /// No description provided for @auto_ajouter.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get auto_ajouter;

  /// No description provided for @auto_prcdent.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get auto_prcdent;

  /// No description provided for @auto_orientation_juridique.
  ///
  /// In fr, this message translates to:
  /// **'Orientation Juridique'**
  String get auto_orientation_juridique;

  /// No description provided for @auto_commencer_questionnaire.
  ///
  /// In fr, this message translates to:
  /// **'Commencer le questionnaire'**
  String get auto_commencer_questionnaire;

  /// No description provided for @auto_consent_center.
  ///
  /// In fr, this message translates to:
  /// **'Consent Center'**
  String get auto_consent_center;

  /// No description provided for @auto_consent_center_espace_consentement.
  ///
  /// In fr, this message translates to:
  /// **'Consent Center (Espace Consentement)'**
  String get auto_consent_center_espace_consentement;

  /// No description provided for @auto_retour.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get auto_retour;

  /// No description provided for @auto_modifier.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get auto_modifier;

  /// No description provided for @auto_confirmer.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get auto_confirmer;

  /// No description provided for @auto_gestion_base_juridique_admin.
  ///
  /// In fr, this message translates to:
  /// **'Gestion de la Base Juridique (Admin)'**
  String get auto_gestion_base_juridique_admin;

  /// No description provided for @auto_ajouter_texte_juridique_valid.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un texte juridique validé'**
  String get auto_ajouter_texte_juridique_valid;

  /// No description provided for @auto_annuler.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get auto_annuler;

  /// No description provided for @auto_enregistrer_avec_audit_log.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer avec Audit Log'**
  String get auto_enregistrer_avec_audit_log;

  /// No description provided for @auto_sauvegarder.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder'**
  String get auto_sauvegarder;

  /// No description provided for @auto_journal_confiance.
  ///
  /// In fr, this message translates to:
  /// **'Journal de Confiance'**
  String get auto_journal_confiance;

  /// No description provided for @auto_dimension_spirituelle.
  ///
  /// In fr, this message translates to:
  /// **'Dimension Spirituelle'**
  String get auto_dimension_spirituelle;

  /// No description provided for @auto_aucun_contenu_disponible_pour.
  ///
  /// In fr, this message translates to:
  /// **'Aucun contenu disponible pour le moment.'**
  String get auto_aucun_contenu_disponible_pour;

  /// No description provided for @auto_logs_nettoys_avec_succs.
  ///
  /// In fr, this message translates to:
  /// **'Logs nettoyés avec succès'**
  String get auto_logs_nettoys_avec_succs;

  /// No description provided for @auto_nettoyage_des_logs.
  ///
  /// In fr, this message translates to:
  /// **'Nettoyage des logs'**
  String get auto_nettoyage_des_logs;

  /// No description provided for @auto_enregistrer.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get auto_enregistrer;

  /// No description provided for @auto_supprimer.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get auto_supprimer;

  /// No description provided for @auto_rinitialiser.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get auto_rinitialiser;

  /// No description provided for @auto_partenaires_sensibilisation.
  ///
  /// In fr, this message translates to:
  /// **'Partenaires de Sensibilisation'**
  String get auto_partenaires_sensibilisation;

  /// No description provided for @auto_bibliothque_coranique.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque Coranique'**
  String get auto_bibliothque_coranique;

  /// No description provided for @auto_aucun_verset_trouv.
  ///
  /// In fr, this message translates to:
  /// **'Aucun verset trouvé'**
  String get auto_aucun_verset_trouv;

  /// No description provided for @auto_tesvous_vouloir_supprimer_verset.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer ce verset ?'**
  String get auto_tesvous_vouloir_supprimer_verset;

  /// No description provided for @auto_hadiths_hikam.
  ///
  /// In fr, this message translates to:
  /// **'Hadiths & Hikam'**
  String get auto_hadiths_hikam;

  /// No description provided for @auto_aucun_hadith_trouv.
  ///
  /// In fr, this message translates to:
  /// **'Aucun hadith trouvé'**
  String get auto_aucun_hadith_trouv;

  /// No description provided for @auto_tesvous_vouloir_supprimer_hadith.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer ce hadith ?'**
  String get auto_tesvous_vouloir_supprimer_hadith;

  /// No description provided for @auto_communications.
  ///
  /// In fr, this message translates to:
  /// **'Communications'**
  String get auto_communications;

  /// No description provided for @auto_statut_professionnel_mis_jour.
  ///
  /// In fr, this message translates to:
  /// **'Statut du professionnel mis à jour'**
  String get auto_statut_professionnel_mis_jour;

  /// No description provided for @auto_compagnon_neurosync.
  ///
  /// In fr, this message translates to:
  /// **'Compagnon NeuroSync'**
  String get auto_compagnon_neurosync;

  /// No description provided for @auto_fermer.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get auto_fermer;

  /// No description provided for @auto_termin.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get auto_termin;

  /// No description provided for @auto_voir_les_analyses_dtailles.
  ///
  /// In fr, this message translates to:
  /// **'Voir les analyses détaillées'**
  String get auto_voir_les_analyses_dtailles;

  /// No description provided for @auto_analyses_dtailles.
  ///
  /// In fr, this message translates to:
  /// **'Analyses Détaillées'**
  String get auto_analyses_dtailles;

  /// No description provided for @auto_effectuez_une_valuation_pour.
  ///
  /// In fr, this message translates to:
  /// **'Effectuez une évaluation pour voir vos analyses.'**
  String get auto_effectuez_une_valuation_pour;

  /// No description provided for @auto_gnration_rapport_pdf.
  ///
  /// In fr, this message translates to:
  /// **'Génération du rapport PDF...'**
  String get auto_gnration_rapport_pdf;

  /// No description provided for @auto_non_connect.
  ///
  /// In fr, this message translates to:
  /// **'Non connecté'**
  String get auto_non_connect;

  /// No description provided for @auto_mes_communications.
  ///
  /// In fr, this message translates to:
  /// **'Mes communications'**
  String get auto_mes_communications;

  /// No description provided for @auto_mes_rflexions.
  ///
  /// In fr, this message translates to:
  /// **'Mes Réflexions'**
  String get auto_mes_rflexions;

  /// No description provided for @auto_dossier_patient.
  ///
  /// In fr, this message translates to:
  /// **'Dossier Patient'**
  String get auto_dossier_patient;

  /// No description provided for @auto_analyse_indisponible.
  ///
  /// In fr, this message translates to:
  /// **'Analyse indisponible.'**
  String get auto_analyse_indisponible;

  /// No description provided for @auto_message.
  ///
  /// In fr, this message translates to:
  /// **'Message'**
  String get auto_message;

  /// No description provided for @auto_tlconsult.
  ///
  /// In fr, this message translates to:
  /// **'Téléconsult.'**
  String get auto_tlconsult;

  /// No description provided for @auto_voulezvous_vraiment_supprimer_tous.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer tous les logs de sécurité ?'**
  String get auto_voulezvous_vraiment_supprimer_tous;

  /// No description provided for @auto_pas_assez_donnes_pour.
  ///
  /// In fr, this message translates to:
  /// **'Pas assez de données pour afficher le graphique.'**
  String get auto_pas_assez_donnes_pour;

  /// No description provided for @auto_textes_juridiques_code_lois.
  ///
  /// In fr, this message translates to:
  /// **'Textes Juridiques et Code des Lois'**
  String get auto_textes_juridiques_code_lois;

  /// No description provided for @auto_aucune_demande_consentement_active.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande de consentement active.'**
  String get auto_aucune_demande_consentement_active;

  /// No description provided for @auto_module_dorientation_juridique.
  ///
  /// In fr, this message translates to:
  /// **'Module d\'Orientation Juridique'**
  String get auto_module_dorientation_juridique;

  /// No description provided for @auto_questionnaire_juridique_dorientation.
  ///
  /// In fr, this message translates to:
  /// **'Questionnaire Juridique d\'Orientation'**
  String get auto_questionnaire_juridique_dorientation;

  /// No description provided for @auto_messagerie_sera_disponible_aprs.
  ///
  /// In fr, this message translates to:
  /// **'Cette version ne transmet pas de messages. Les notes restent sur cet appareil.'**
  String get auto_messagerie_sera_disponible_aprs;

  /// No description provided for @auto_analyse_assiste_style_textstyle.
  ///
  /// In fr, this message translates to:
  /// **'Analyse assistée'**
  String get auto_analyse_assiste_style_textstyle;

  /// No description provided for @auto_rflexion_clinique_style_textstylefontweight.
  ///
  /// In fr, this message translates to:
  /// **'Réflexion clinique'**
  String get auto_rflexion_clinique_style_textstylefontweight;

  /// No description provided for @auto_impossible_douvrir_whatsapp.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir WhatsApp'**
  String get auto_impossible_douvrir_whatsapp;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @writeMessageHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez votre message…'**
  String get writeMessageHint;

  /// No description provided for @writeHereHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez ici…'**
  String get writeHereHint;

  /// No description provided for @searchWilayaHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une wilaya…'**
  String get searchWilayaHint;

  /// No description provided for @situationWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur NeuroSync'**
  String get situationWelcome;

  /// No description provided for @situationIntroduction.
  ///
  /// In fr, this message translates to:
  /// **'Plateforme de prévention, d\'orientation et d\'accompagnement.'**
  String get situationIntroduction;

  /// No description provided for @situationQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Comment souhaitez-vous être accompagné aujourd\'hui ?'**
  String get situationQuestion;

  /// No description provided for @wellbeingPathTitle.
  ///
  /// In fr, this message translates to:
  /// **'Parcours A : Bien-être et santé mentale'**
  String get wellbeingPathTitle;

  /// No description provided for @wellbeingPathDescription.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation des besoins, gestion du stress, soutien émotionnel et bien-être.'**
  String get wellbeingPathDescription;

  /// No description provided for @protectionPathTitle.
  ///
  /// In fr, this message translates to:
  /// **'Parcours B : Prévention et protection'**
  String get protectionPathTitle;

  /// No description provided for @protectionPathDescription.
  ///
  /// In fr, this message translates to:
  /// **'En cas de violence, accédez à une orientation, à des ressources et à un accompagnement adapté.'**
  String get protectionPathDescription;

  /// No description provided for @trustedContact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter une personne de confiance'**
  String get trustedContact;

  /// No description provided for @trustedContactMessage.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai besoin d\'aide. Peux-tu me contacter ?'**
  String get trustedContactMessage;

  /// No description provided for @confidenceNewJournal.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau journal de confiance'**
  String get confidenceNewJournal;

  /// No description provided for @confidenceStrengthLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ma force du jour'**
  String get confidenceStrengthLabel;

  /// No description provided for @confidenceStrengthHint.
  ///
  /// In fr, this message translates to:
  /// **'Qu\'est-ce que j\'apprécie chez moi aujourd\'hui ?'**
  String get confidenceStrengthHint;

  /// No description provided for @confidenceSuccessLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ma petite réussite'**
  String get confidenceSuccessLabel;

  /// No description provided for @confidenceSuccessHint.
  ///
  /// In fr, this message translates to:
  /// **'Une chose simple que j\'ai accomplie.'**
  String get confidenceSuccessHint;

  /// No description provided for @confidenceGoalLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mon intention du jour'**
  String get confidenceGoalLabel;

  /// No description provided for @confidenceGoalHint.
  ///
  /// In fr, this message translates to:
  /// **'Une petite étape pour avancer avec douceur.'**
  String get confidenceGoalHint;

  /// No description provided for @confidenceEveryStep.
  ///
  /// In fr, this message translates to:
  /// **'Chaque petit pas compte.'**
  String get confidenceEveryStep;

  /// No description provided for @confidenceEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune entrée pour le moment. Commencez à écrire en cliquant sur le bouton +.'**
  String get confidenceEmpty;

  /// No description provided for @healthSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un aliment ou une plante…'**
  String get healthSearchHint;

  /// No description provided for @categoriesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categoriesLabel;

  /// No description provided for @filteredBy.
  ///
  /// In fr, this message translates to:
  /// **'Filtré par : {category}'**
  String filteredBy(Object category);

  /// No description provided for @latestPublications.
  ///
  /// In fr, this message translates to:
  /// **'Dernières publications'**
  String get latestPublications;

  /// No description provided for @professionalPendingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Validation en cours'**
  String get professionalPendingTitle;

  /// No description provided for @professionalPendingMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte professionnel ({email}) est en attente de validation. Vous serez informé lorsque votre accès sera activé.'**
  String professionalPendingMessage(Object email);

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @upcomingAppointments.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous à venir'**
  String get upcomingAppointments;

  /// No description provided for @loadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de chargement : {error}'**
  String loadingError(Object error);

  /// No description provided for @noAppointmentRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande de rendez-vous pour le moment'**
  String get noAppointmentRequests;

  /// No description provided for @appointmentRequest.
  ///
  /// In fr, this message translates to:
  /// **'Demande n°{id}'**
  String appointmentRequest(Object id);

  /// No description provided for @statusValue.
  ///
  /// In fr, this message translates to:
  /// **'État : {status}'**
  String statusValue(Object status);

  /// No description provided for @sessionStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get sessionStatusPending;

  /// No description provided for @sessionStatusAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Acceptée'**
  String get sessionStatusAccepted;

  /// No description provided for @sessionStatusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get sessionStatusRejected;

  /// No description provided for @sessionStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get sessionStatusCancelled;

  /// No description provided for @sessionStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get sessionStatusCompleted;

  /// No description provided for @secureMessaging.
  ///
  /// In fr, this message translates to:
  /// **'Notes locales protégées'**
  String get secureMessaging;

  /// No description provided for @messagingUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Cette version ne transmet pas de messages. Les notes restent sur cet appareil.'**
  String get messagingUnavailable;

  /// No description provided for @noMessages.
  ///
  /// In fr, this message translates to:
  /// **'Aucune note locale pour le moment'**
  String get noMessages;

  /// No description provided for @startConversation.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez une note locale pour ce suivi.'**
  String get startConversation;

  /// No description provided for @progressOverview.
  ///
  /// In fr, this message translates to:
  /// **'Vue d\'ensemble'**
  String get progressOverview;

  /// No description provided for @progressDailyGoals.
  ///
  /// In fr, this message translates to:
  /// **'Complétez vos objectifs quotidiens pour gagner plus d\'XP !'**
  String get progressDailyGoals;

  /// No description provided for @progressCompanionGoal.
  ///
  /// In fr, this message translates to:
  /// **'Interagir avec le compagnon'**
  String get progressCompanionGoal;

  /// No description provided for @progressBadgesUnlocked.
  ///
  /// In fr, this message translates to:
  /// **'Badges débloqués'**
  String get progressBadgesUnlocked;

  /// No description provided for @progressLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level} — {label}'**
  String progressLevel(Object level, Object label);

  /// No description provided for @progressXpToNext.
  ///
  /// In fr, this message translates to:
  /// **'{xp} XP jusqu\'au prochain niveau'**
  String progressXpToNext(Object xp);

  /// No description provided for @badgeMoodCheckin.
  ///
  /// In fr, this message translates to:
  /// **'Check-in'**
  String get badgeMoodCheckin;

  /// No description provided for @badgeAssessment.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation'**
  String get badgeAssessment;

  /// No description provided for @badgeStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série'**
  String get badgeStreak;

  /// No description provided for @badgeCalm.
  ///
  /// In fr, this message translates to:
  /// **'Calme'**
  String get badgeCalm;

  /// No description provided for @roleAdministrator.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get roleAdministrator;

  /// No description provided for @rolePsychologist.
  ///
  /// In fr, this message translates to:
  /// **'Psychologue clinicien'**
  String get rolePsychologist;

  /// No description provided for @rolePatient.
  ///
  /// In fr, this message translates to:
  /// **'Patient'**
  String get rolePatient;

  /// No description provided for @roleGuest.
  ///
  /// In fr, this message translates to:
  /// **'Invité'**
  String get roleGuest;

  /// No description provided for @roleUser.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get roleUser;

  /// No description provided for @contentAvailableInFrench.
  ///
  /// In fr, this message translates to:
  /// **'Ce contenu est actuellement disponible en français.'**
  String get contentAvailableInFrench;

  /// No description provided for @localSecondFactorCode.
  ///
  /// In fr, this message translates to:
  /// **'Code de second facteur'**
  String get localSecondFactorCode;

  /// No description provided for @localSecondFactorHint.
  ///
  /// In fr, this message translates to:
  /// **'Requis uniquement si votre compte est soumis à la MFA.'**
  String get localSecondFactorHint;

  /// No description provided for @institutionalReadiness.
  ///
  /// In fr, this message translates to:
  /// **'Validation institutionnelle'**
  String get institutionalReadiness;

  /// No description provided for @institutionalReadinessSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Juridique, médicale et institutionnelle avant ouverture publique'**
  String get institutionalReadinessSubtitle;

  /// No description provided for @approvalLegal.
  ///
  /// In fr, this message translates to:
  /// **'Validation juridique'**
  String get approvalLegal;

  /// No description provided for @approvalMedical.
  ///
  /// In fr, this message translates to:
  /// **'Validation médicale'**
  String get approvalMedical;

  /// No description provided for @approvalInstitutional.
  ///
  /// In fr, this message translates to:
  /// **'Validation institutionnelle'**
  String get approvalInstitutional;

  /// No description provided for @approvalPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente de validation'**
  String get approvalPending;

  /// No description provided for @approvalGranted.
  ///
  /// In fr, this message translates to:
  /// **'Validée'**
  String get approvalGranted;

  /// No description provided for @approvalReference.
  ///
  /// In fr, this message translates to:
  /// **'Référence de validation'**
  String get approvalReference;

  /// No description provided for @approverName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du valideur'**
  String get approverName;

  /// No description provided for @approvalNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes de validation'**
  String get approvalNotes;

  /// No description provided for @grantApproval.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la validation'**
  String get grantApproval;

  /// No description provided for @revokeApproval.
  ///
  /// In fr, this message translates to:
  /// **'Retirer la validation'**
  String get revokeApproval;

  /// No description provided for @publicReleaseBlocked.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture publique bloquée : les trois validations sont requises.'**
  String get publicReleaseBlocked;

  /// No description provided for @publicReleaseReady.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les validations locales sont enregistrées. Une validation externe reste obligatoire avant diffusion.'**
  String get publicReleaseReady;

  /// No description provided for @accountSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité des comptes'**
  String get accountSecurity;

  /// No description provided for @resetTemporaryPassword.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le mot de passe'**
  String get resetTemporaryPassword;

  /// No description provided for @changePassword.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe (12 caractères minimum)'**
  String get newPassword;

  /// No description provided for @temporaryPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe temporaire (12 caractères minimum)'**
  String get temporaryPassword;

  /// No description provided for @requireLocalMfa.
  ///
  /// In fr, this message translates to:
  /// **'Exiger la MFA locale'**
  String get requireLocalMfa;

  /// No description provided for @disableLocalMfa.
  ///
  /// In fr, this message translates to:
  /// **'Désactiver la MFA locale'**
  String get disableLocalMfa;

  /// No description provided for @mfaEnrollmentCode.
  ///
  /// In fr, this message translates to:
  /// **'Code MFA local (6 à 10 chiffres)'**
  String get mfaEnrollmentCode;

  /// No description provided for @auditLogsImmutable.
  ///
  /// In fr, this message translates to:
  /// **'Les journaux d\'audit sont conservés et ne peuvent pas être supprimés depuis l\'application.'**
  String get auditLogsImmutable;

  /// No description provided for @analyticsWellbeingRadar.
  ///
  /// In fr, this message translates to:
  /// **'Radar de bien-être'**
  String get analyticsWellbeingRadar;

  /// No description provided for @analyticsAxisDetail.
  ///
  /// In fr, this message translates to:
  /// **'Détail par axe'**
  String get analyticsAxisDetail;

  /// No description provided for @analyticsAxisEmotions.
  ///
  /// In fr, this message translates to:
  /// **'Émotions'**
  String get analyticsAxisEmotions;

  /// No description provided for @analyticsAxisStress.
  ///
  /// In fr, this message translates to:
  /// **'Stress'**
  String get analyticsAxisStress;

  /// No description provided for @analyticsAxisSleep.
  ///
  /// In fr, this message translates to:
  /// **'Sommeil'**
  String get analyticsAxisSleep;

  /// No description provided for @analyticsAxisProductivity.
  ///
  /// In fr, this message translates to:
  /// **'Productivité'**
  String get analyticsAxisProductivity;

  /// No description provided for @analyticsAxisSocial.
  ///
  /// In fr, this message translates to:
  /// **'Social'**
  String get analyticsAxisSocial;

  /// No description provided for @specialistWithId.
  ///
  /// In fr, this message translates to:
  /// **'Spécialiste (ID : {id}…)'**
  String specialistWithId(Object id);

  /// No description provided for @consultationAccessGranted.
  ///
  /// In fr, this message translates to:
  /// **'Suivi local autorisé'**
  String get consultationAccessGranted;

  /// No description provided for @localAppointmentDraft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon de rendez-vous local'**
  String get localAppointmentDraft;

  /// No description provided for @saveLocalDraft.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le brouillon'**
  String get saveLocalDraft;

  /// No description provided for @localDraftNotShared.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon local — non transmis'**
  String get localDraftNotShared;

  /// No description provided for @localNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes locales'**
  String get localNotes;

  /// No description provided for @localNotesNotice.
  ///
  /// In fr, this message translates to:
  /// **'Ces notes sont enregistrées uniquement sur cet appareil et ne sont envoyées à personne.'**
  String get localNotesNotice;

  /// No description provided for @writeLocalNoteHint.
  ///
  /// In fr, this message translates to:
  /// **'Écrire une note locale…'**
  String get writeLocalNoteHint;

  /// No description provided for @localFollowUpPrepared.
  ///
  /// In fr, this message translates to:
  /// **'Suivi local préparé. Aucune information n’a été envoyée.'**
  String get localFollowUpPrepared;

  /// No description provided for @companionWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour ! Je suis votre compagnon NeuroSync. Je suis là pour vous écouter et vous orienter. Comment vous sentez-vous en ce moment ?'**
  String get companionWelcome;

  /// No description provided for @companionThinking.
  ///
  /// In fr, this message translates to:
  /// **'Le compagnon réfléchit…'**
  String get companionThinking;

  /// No description provided for @companionSuggestionStress.
  ///
  /// In fr, this message translates to:
  /// **'Je me sens stressé'**
  String get companionSuggestionStress;

  /// No description provided for @companionSuggestionHope.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai besoin d\'espoir'**
  String get companionSuggestionHope;

  /// No description provided for @companionSuggestionAdvice.
  ///
  /// In fr, this message translates to:
  /// **'Conseil du jour'**
  String get companionSuggestionAdvice;

  /// No description provided for @companionStressResponse.
  ///
  /// In fr, this message translates to:
  /// **'Je comprends votre ressenti. Pour vous apaiser, prenez un moment avec ce verset : {verse}'**
  String companionStressResponse(Object verse);

  /// No description provided for @companionSadnessResponse.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'êtes pas seul. Cette sagesse pourrait vous aider : {wisdom}'**
  String companionSadnessResponse(Object wisdom);

  /// No description provided for @companionLowEnergyResponse.
  ///
  /// In fr, this message translates to:
  /// **'Votre énergie semble basse récemment. Une courte pause de respiration pourrait vous aider à retrouver votre équilibre.'**
  String get companionLowEnergyResponse;

  /// No description provided for @companionFocusResponse.
  ///
  /// In fr, this message translates to:
  /// **'La concentration semble difficile aujourd\'hui. Essayez de répartir vos tâches en petits blocs de 15 minutes ; je suis là pour vous encourager.'**
  String get companionFocusResponse;

  /// No description provided for @companionDefaultResponse.
  ///
  /// In fr, this message translates to:
  /// **'C\'est noté. Pour vous accompagner dans votre réflexion, voici un hadith : {hadith}'**
  String companionDefaultResponse(Object hadith);

  /// No description provided for @offlineMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode hors ligne'**
  String get offlineMode;

  /// No description provided for @offlineModeDescription.
  ///
  /// In fr, this message translates to:
  /// **'Les données restent sur cet appareil et aucune donnée n\'est transmise.'**
  String get offlineModeDescription;

  /// No description provided for @offlineAdminSetup.
  ///
  /// In fr, this message translates to:
  /// **'Initialiser l’appareil professionnel'**
  String get offlineAdminSetup;

  /// No description provided for @offlineAdminSetupDescription.
  ///
  /// In fr, this message translates to:
  /// **'À effectuer une seule fois, par le responsable de l’appareil. Cette opération crée l’administrateur local et n’est plus possible après la création du premier compte.'**
  String get offlineAdminSetupDescription;

  /// No description provided for @createOfflineAdministrator.
  ///
  /// In fr, this message translates to:
  /// **'Créer l’administrateur local'**
  String get createOfflineAdministrator;

  /// No description provided for @awareness_network_title.
  ///
  /// In fr, this message translates to:
  /// **'Réseau local et sensibilisation'**
  String get awareness_network_title;

  /// No description provided for @add_partner.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un partenaire'**
  String get add_partner;

  /// No description provided for @no_partners_msg.
  ///
  /// In fr, this message translates to:
  /// **'Aucun partenaire local. Ajoutez un établissement, une université, une entreprise ou une association puis vérifiez sa fiche avant publication.'**
  String get no_partners_msg;

  /// No description provided for @verified_chip.
  ///
  /// In fr, this message translates to:
  /// **'Vérifié'**
  String get verified_chip;

  /// No description provided for @verify_btn.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier'**
  String get verify_btn;

  /// No description provided for @new_local_partner.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau partenaire local'**
  String get new_local_partner;

  /// No description provided for @name_field.
  ///
  /// In fr, this message translates to:
  /// **'Nom *'**
  String get name_field;

  /// No description provided for @domain_field.
  ///
  /// In fr, this message translates to:
  /// **'Domaine *'**
  String get domain_field;

  /// No description provided for @type_field.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get type_field;

  /// No description provided for @wilaya_code_field.
  ///
  /// In fr, this message translates to:
  /// **'Code wilaya (01–58) *'**
  String get wilaya_code_field;

  /// No description provided for @professional_contact_field.
  ///
  /// In fr, this message translates to:
  /// **'Contact professionnel'**
  String get professional_contact_field;

  /// No description provided for @pending_verification_note.
  ///
  /// In fr, this message translates to:
  /// **'La fiche sera en attente de vérification. N\'ajoutez aucune donnée individuelle.'**
  String get pending_verification_note;

  /// No description provided for @save_btn.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save_btn;

  /// No description provided for @specialty_psychologist.
  ///
  /// In fr, this message translates to:
  /// **'Psychologue'**
  String get specialty_psychologist;

  /// No description provided for @specialty_child_protection.
  ///
  /// In fr, this message translates to:
  /// **'Spécialiste de l’enfance'**
  String get specialty_child_protection;

  /// No description provided for @specialty_family_counselor.
  ///
  /// In fr, this message translates to:
  /// **'Conseiller familial / Psychologue'**
  String get specialty_family_counselor;

  /// No description provided for @specialty_digital_safety.
  ///
  /// In fr, this message translates to:
  /// **'Expert en sécurité numérique / Psychologue'**
  String get specialty_digital_safety;

  /// No description provided for @specialty_work_psychologist.
  ///
  /// In fr, this message translates to:
  /// **'Psychologue du travail'**
  String get specialty_work_psychologist;

  /// No description provided for @specialty_psychiatrist.
  ///
  /// In fr, this message translates to:
  /// **'Psychiatre'**
  String get specialty_psychiatrist;

  /// No description provided for @specialty_neurologist.
  ///
  /// In fr, this message translates to:
  /// **'Neurologue'**
  String get specialty_neurologist;

  /// No description provided for @specialty_health_professional.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel de santé'**
  String get specialty_health_professional;

  /// No description provided for @specialty_social_worker.
  ///
  /// In fr, this message translates to:
  /// **'Travail social'**
  String get specialty_social_worker;

  /// No description provided for @specialty_legal_support.
  ///
  /// In fr, this message translates to:
  /// **'Information juridique'**
  String get specialty_legal_support;

  /// No description provided for @specialty_association.
  ///
  /// In fr, this message translates to:
  /// **'Association d\'aide'**
  String get specialty_association;

  /// No description provided for @specialty_awareness.
  ///
  /// In fr, this message translates to:
  /// **'Sensibilisation'**
  String get specialty_awareness;

  /// No description provided for @type_middle_school.
  ///
  /// In fr, this message translates to:
  /// **'Collège'**
  String get type_middle_school;

  /// No description provided for @type_high_school.
  ///
  /// In fr, this message translates to:
  /// **'Lycée'**
  String get type_high_school;

  /// No description provided for @type_university.
  ///
  /// In fr, this message translates to:
  /// **'Université'**
  String get type_university;

  /// No description provided for @type_company.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get type_company;

  /// No description provided for @type_association.
  ///
  /// In fr, this message translates to:
  /// **'Association'**
  String get type_association;

  /// No description provided for @load_network_error.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le réseau local : {error}'**
  String load_network_error(Object error);

  /// No description provided for @availability_available.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get availability_available;

  /// No description provided for @availability_limited.
  ///
  /// In fr, this message translates to:
  /// **'Limité'**
  String get availability_limited;

  /// No description provided for @availability_unavailable.
  ///
  /// In fr, this message translates to:
  /// **'Indisponible'**
  String get availability_unavailable;

  /// No description provided for @cannot_open_phone.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir l\'application téléphone.'**
  String get cannot_open_phone;

  /// No description provided for @request_reserved_for_users.
  ///
  /// In fr, this message translates to:
  /// **'Cette demande est réservée aux comptes utilisateur.'**
  String get request_reserved_for_users;

  /// No description provided for @cannot_add_psychologist.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ajouter ce psychologue : {error}'**
  String cannot_add_psychologist(Object error);

  /// No description provided for @partner_account_title.
  ///
  /// In fr, this message translates to:
  /// **'Compte partenaire'**
  String get partner_account_title;

  /// No description provided for @connect_btn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get connect_btn;

  /// No description provided for @partner_account_info.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte est lié à une fiche partenaire locale. Aucune donnée personnelle ni demande d\'orientation n\'est affichée ici.'**
  String get partner_account_info;

  /// No description provided for @no_partner_linked.
  ///
  /// In fr, this message translates to:
  /// **'Aucune fiche partenaire n\'est reliée à ce compte.'**
  String get no_partner_linked;

  /// No description provided for @partner_network_management_title.
  ///
  /// In fr, this message translates to:
  /// **'Gestion du réseau partenaire'**
  String get partner_network_management_title;

  /// No description provided for @partner_network_info.
  ///
  /// In fr, this message translates to:
  /// **'Relations affichées : fiche partenaire ← compte responsable. Le compteur est local et agrégé ; aucune identité ni contenu de demande n\'est exposé.'**
  String get partner_network_info;

  /// No description provided for @no_linked_account.
  ///
  /// In fr, this message translates to:
  /// **'Aucun compte lié'**
  String get no_linked_account;

  /// No description provided for @responsible_account.
  ///
  /// In fr, this message translates to:
  /// **'Compte responsable'**
  String get responsible_account;

  /// No description provided for @local_referrals_count.
  ///
  /// In fr, this message translates to:
  /// **'{count} orientation(s) locale(s) non transmise(s)'**
  String local_referrals_count(Object count);

  /// No description provided for @selection_conflict_title.
  ///
  /// In fr, this message translates to:
  /// **'Conflit, colère ou comportement préoccupant'**
  String get selection_conflict_title;

  /// No description provided for @selection_conflict_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Faire le point en toute confidentialité et trouver un accompagnement adapté, sans jugement ni étiquette.'**
  String get selection_conflict_subtitle;

  /// No description provided for @selection_witness_title.
  ///
  /// In fr, this message translates to:
  /// **'Témoin ou besoin d’orientation'**
  String get selection_witness_title;

  /// No description provided for @selection_witness_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Consulter des ressources, des partenaires vérifiés et des options d’aide locales.'**
  String get selection_witness_subtitle;

  /// No description provided for @prot_flow_title.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre une situation de violence'**
  String get prot_flow_title;

  /// No description provided for @prot_privacy_tooltip.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get prot_privacy_tooltip;

  /// No description provided for @prot_offline_notice.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité garantie & Offline-First'**
  String get prot_offline_notice;

  /// No description provided for @prot_consent_info_title.
  ///
  /// In fr, this message translates to:
  /// **'Information & Consentement'**
  String get prot_consent_info_title;

  /// No description provided for @prot_consent_bullet_1.
  ///
  /// In fr, this message translates to:
  /// **'Ce questionnaire adaptatif vous aide à évaluer la situation et à identifier le type d’accompagnement adapté.'**
  String get prot_consent_bullet_1;

  /// No description provided for @prot_consent_bullet_2.
  ///
  /// In fr, this message translates to:
  /// **'Cette évaluation est indicative et d’orientation. Elle ne constitue pas un diagnostic définitif ni une accusation juridique.'**
  String get prot_consent_bullet_2;

  /// No description provided for @prot_consent_bullet_3.
  ///
  /// In fr, this message translates to:
  /// **'Vos réponses sont chiffrées et conservées localement sur votre appareil (Offline-First).'**
  String get prot_consent_bullet_3;

  /// No description provided for @prot_consent_bullet_4.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez réaliser ce parcours de manière totalement anonyme.'**
  String get prot_consent_bullet_4;

  /// No description provided for @prot_consent_accept.
  ///
  /// In fr, this message translates to:
  /// **'J’ai compris et je souhaite commencer'**
  String get prot_consent_accept;

  /// No description provided for @prot_nature_situation.
  ///
  /// In fr, this message translates to:
  /// **'Nature de la situation'**
  String get prot_nature_situation;

  /// No description provided for @prot_nature_desc.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez la ou les catégories correspondant à la situation :'**
  String get prot_nature_desc;

  /// No description provided for @prot_select_min_one.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner au moins une catégorie pour continuer.'**
  String get prot_select_min_one;

  /// No description provided for @prot_context_repetition.
  ///
  /// In fr, this message translates to:
  /// **'Contexte et répétition'**
  String get prot_context_repetition;

  /// No description provided for @prot_freq_label.
  ///
  /// In fr, this message translates to:
  /// **'1. Fréquence et répétition :'**
  String get prot_freq_label;

  /// No description provided for @prot_freq_hint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez la fréquence'**
  String get prot_freq_hint;

  /// No description provided for @prot_freq_isolated.
  ///
  /// In fr, this message translates to:
  /// **'Fait isolé (une seule fois)'**
  String get prot_freq_isolated;

  /// No description provided for @prot_freq_repeated.
  ///
  /// In fr, this message translates to:
  /// **'Répété de temps en temps'**
  String get prot_freq_repeated;

  /// No description provided for @prot_freq_escalating.
  ///
  /// In fr, this message translates to:
  /// **'Répété avec aggravation progressive'**
  String get prot_freq_escalating;

  /// No description provided for @prot_freq_continuous.
  ///
  /// In fr, this message translates to:
  /// **'Continu / Quotidien'**
  String get prot_freq_continuous;

  /// No description provided for @prot_cadre_label.
  ///
  /// In fr, this message translates to:
  /// **'2. Cadre / Contexte :'**
  String get prot_cadre_label;

  /// No description provided for @prot_cadre_hint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez le contexte'**
  String get prot_cadre_hint;

  /// No description provided for @prot_cadre_family.
  ///
  /// In fr, this message translates to:
  /// **'Famille / Foyer'**
  String get prot_cadre_family;

  /// No description provided for @prot_cadre_work.
  ///
  /// In fr, this message translates to:
  /// **'Milieu professionnel'**
  String get prot_cadre_work;

  /// No description provided for @prot_cadre_school.
  ///
  /// In fr, this message translates to:
  /// **'Milieu scolaire / universitaire'**
  String get prot_cadre_school;

  /// No description provided for @prot_cadre_online.
  ///
  /// In fr, this message translates to:
  /// **'En ligne / Numérique'**
  String get prot_cadre_online;

  /// No description provided for @prot_cadre_other.
  ///
  /// In fr, this message translates to:
  /// **'Autre contexte'**
  String get prot_cadre_other;

  /// No description provided for @prot_relation_label.
  ///
  /// In fr, this message translates to:
  /// **'3. Relation avec la personne concernée :'**
  String get prot_relation_label;

  /// No description provided for @prot_relation_hint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez la relation'**
  String get prot_relation_hint;

  /// No description provided for @prot_relation_partner.
  ///
  /// In fr, this message translates to:
  /// **'Conjoint / Partenaire'**
  String get prot_relation_partner;

  /// No description provided for @prot_relation_relative.
  ///
  /// In fr, this message translates to:
  /// **'Membre de la famille'**
  String get prot_relation_relative;

  /// No description provided for @prot_relation_colleague.
  ///
  /// In fr, this message translates to:
  /// **'Collègue / Supérieur'**
  String get prot_relation_colleague;

  /// No description provided for @prot_relation_acquaintance.
  ///
  /// In fr, this message translates to:
  /// **'Connaissance / Environnement'**
  String get prot_relation_acquaintance;

  /// No description provided for @prot_relation_unknown.
  ///
  /// In fr, this message translates to:
  /// **'Personne inconnue'**
  String get prot_relation_unknown;

  /// No description provided for @prot_goto_adaptive.
  ///
  /// In fr, this message translates to:
  /// **'Passer aux questions adaptatives'**
  String get prot_goto_adaptive;

  /// No description provided for @prot_analyzing.
  ///
  /// In fr, this message translates to:
  /// **'Analyse des indicateurs et calcul du niveau...'**
  String get prot_analyzing;

  /// No description provided for @prot_red_flags_title.
  ///
  /// In fr, this message translates to:
  /// **'Indicateurs prioritaires (Red Flags) :'**
  String get prot_red_flags_title;

  /// No description provided for @prot_guidance_title.
  ///
  /// In fr, this message translates to:
  /// **'Conduite initiale conseillée :'**
  String get prot_guidance_title;

  /// No description provided for @prot_orientation_pro.
  ///
  /// In fr, this message translates to:
  /// **'Orientation professionnelle'**
  String get prot_orientation_pro;

  /// No description provided for @prot_orientation_reco.
  ///
  /// In fr, this message translates to:
  /// **'Selon les informations fournies, la spécialité recommandée est : {specialty}'**
  String prot_orientation_reco(Object specialty);

  /// No description provided for @prot_search_national.
  ///
  /// In fr, this message translates to:
  /// **'Consulter l’annuaire des professionnels'**
  String get prot_search_national;

  /// No description provided for @prot_goto_emergency.
  ///
  /// In fr, this message translates to:
  /// **'Accéder à l’aide immédiate'**
  String get prot_goto_emergency;

  /// No description provided for @prot_back_home.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l’accueil Protection'**
  String get prot_back_home;

  /// No description provided for @emg_immediate_action_notice.
  ///
  /// In fr, this message translates to:
  /// **'Si le danger est immédiat, rejoignez un endroit plus sûr si possible et appelez les secours ou une personne de confiance. Cette application ne remplace pas une intervention d’urgence.'**
  String get emg_immediate_action_notice;

  /// No description provided for @emg_protection_civile.
  ///
  /// In fr, this message translates to:
  /// **'Protection civile — 14'**
  String get emg_protection_civile;

  /// No description provided for @emg_gendarmerie.
  ///
  /// In fr, this message translates to:
  /// **'Gendarmerie nationale — 1055'**
  String get emg_gendarmerie;

  /// No description provided for @emg_open_safety_plan.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le plan de sécurité rapide'**
  String get emg_open_safety_plan;

  /// No description provided for @emg_call_error.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lancer l’appel. Composez le {number} depuis votre téléphone.'**
  String emg_call_error(Object number);

  /// No description provided for @breath_title.
  ///
  /// In fr, this message translates to:
  /// **'Exercice de respiration'**
  String get breath_title;

  /// No description provided for @breath_sound_tooltip.
  ///
  /// In fr, this message translates to:
  /// **'Son ambiant'**
  String get breath_sound_tooltip;

  /// No description provided for @breath_in_sub.
  ///
  /// In fr, this message translates to:
  /// **'Inspirer...'**
  String get breath_in_sub;

  /// No description provided for @breath_hold_sub.
  ///
  /// In fr, this message translates to:
  /// **'Bloquer...'**
  String get breath_hold_sub;

  /// No description provided for @breath_out_sub.
  ///
  /// In fr, this message translates to:
  /// **'Expirer...'**
  String get breath_out_sub;

  /// No description provided for @breath_sec.
  ///
  /// In fr, this message translates to:
  /// **'sec'**
  String get breath_sec;

  /// No description provided for @res_video_personalized.
  ///
  /// In fr, this message translates to:
  /// **'Vidéos adaptées à votre situation'**
  String get res_video_personalized;

  /// No description provided for @res_search_trusted_network.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher dans le réseau local vérifié'**
  String get res_search_trusted_network;

  /// No description provided for @settings_about_desc.
  ///
  /// In fr, this message translates to:
  /// **'NeuroSync est une application locale conçue pour offrir un accompagnement émotionnel, des outils de respiration et un suivi de progression sans dépendre d\'un service externe.'**
  String get settings_about_desc;

  /// No description provided for @faq_q1.
  ///
  /// In fr, this message translates to:
  /// **'Comment puis-je commencer un bilan ?'**
  String get faq_q1;

  /// No description provided for @faq_a1.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrez l\'écran d\'évaluation pour démarrer le parcours guidé.'**
  String get faq_a1;

  /// No description provided for @faq_q2.
  ///
  /// In fr, this message translates to:
  /// **'Que faire si je me sens stressé ?'**
  String get faq_q2;

  /// No description provided for @faq_a2.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez la respiration ou le plan quotidien pour retrouver un calme rapide.'**
  String get faq_a2;

  /// No description provided for @faq_q3.
  ///
  /// In fr, this message translates to:
  /// **'Comment suivre ma progression ?'**
  String get faq_q3;

  /// No description provided for @faq_a3.
  ///
  /// In fr, this message translates to:
  /// **'Le tableau de progression se met à jour automatiquement selon vos actions.'**
  String get faq_a3;

  /// No description provided for @faq_q4.
  ///
  /// In fr, this message translates to:
  /// **'Comment trouver un professionnel ?'**
  String get faq_q4;

  /// No description provided for @faq_a4.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez la recherche de professionnels par wilaya pour trouver une aide adaptée.'**
  String get faq_a4;

  /// No description provided for @prot_home_notice.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le parcours qui correspond à votre situation. Les évaluations et orientations aident à décider ; elles ne transmettent jamais vos données automatiquement.'**
  String get prot_home_notice;

  /// No description provided for @prot_local_partners.
  ///
  /// In fr, this message translates to:
  /// **'Partenaires et ressources locales'**
  String get prot_local_partners;

  /// No description provided for @prot_local_partners_desc.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher sans partage automatique de données'**
  String get prot_local_partners_desc;

  /// No description provided for @prot_training_scenarios.
  ///
  /// In fr, this message translates to:
  /// **'Scénarios de mise en situation'**
  String get prot_training_scenarios;

  /// No description provided for @prot_training_scenarios_desc.
  ///
  /// In fr, this message translates to:
  /// **'S’entraîner sans décrire de situation personnelle'**
  String get prot_training_scenarios_desc;

  /// No description provided for @legal_anonymous_mode.
  ///
  /// In fr, this message translates to:
  /// **'Mode Anonyme Activé (Guest)'**
  String get legal_anonymous_mode;

  /// No description provided for @legal_user_protected.
  ///
  /// In fr, this message translates to:
  /// **'Espace Utilisateur Protégé'**
  String get legal_user_protected;

  /// No description provided for @legal_guest_desc.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez consulter les textes juridiques, faire une orientation et préparer un brouillon sans fournir votre identité.'**
  String get legal_guest_desc;

  /// No description provided for @legal_user_desc.
  ///
  /// In fr, this message translates to:
  /// **'Vos consultations et brouillons sont sauvegardés en toute sécurité sous votre profil local.'**
  String get legal_user_desc;

  /// No description provided for @legal_start_questionnaire.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer l\'Orientation Juridique'**
  String get legal_start_questionnaire;

  /// No description provided for @legal_questionnaire_desc.
  ///
  /// In fr, this message translates to:
  /// **'Évaluez vos faits déclarés et identifiez les articles de loi validés applicables.'**
  String get legal_questionnaire_desc;

  /// No description provided for @legal_ref_indicative.
  ///
  /// In fr, this message translates to:
  /// **'Références juridiques indicatives'**
  String get legal_ref_indicative;

  /// No description provided for @legal_ref_notice.
  ///
  /// In fr, this message translates to:
  /// **'Les références proviennent du Journal officiel ; leur usage institutionnel exige une revue juridique humaine et une mise à jour régulière.'**
  String get legal_ref_notice;

  /// No description provided for @legal_categories_label.
  ///
  /// In fr, this message translates to:
  /// **'Catégories Juridiques :'**
  String get legal_categories_label;

  /// No description provided for @legal_articles_label.
  ///
  /// In fr, this message translates to:
  /// **'Textes de Loi Validés :'**
  String get legal_articles_label;

  /// No description provided for @legal_procedures_label.
  ///
  /// In fr, this message translates to:
  /// **'Procédures Officiellement Disponibles :'**
  String get legal_procedures_label;

  /// No description provided for @legal_explanation_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Explication : '**
  String get legal_explanation_prefix;

  /// No description provided for @legal_status_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Statut : '**
  String get legal_status_prefix;

  /// No description provided for @legal_version_prefix.
  ///
  /// In fr, this message translates to:
  /// **'Version : '**
  String get legal_version_prefix;

  /// No description provided for @legal_assessment_title.
  ///
  /// In fr, this message translates to:
  /// **'Évaluation Juridique'**
  String get legal_assessment_title;

  /// No description provided for @legal_result_none.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée d\'orientation disponible.'**
  String get legal_result_none;

  /// No description provided for @legal_result_save_tooltip.
  ///
  /// In fr, this message translates to:
  /// **'Imprimer / Sauvegarder'**
  String get legal_result_save_tooltip;

  /// No description provided for @legal_result_save_success.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon d\'orientation sauvegardé localement en sécurité.'**
  String get legal_result_save_success;

  /// No description provided for @legal_result_disclaimer_title.
  ///
  /// In fr, this message translates to:
  /// **'MENTION D\'ORIENTATION NUMÉRIQUE'**
  String get legal_result_disclaimer_title;

  /// No description provided for @legal_result_facts_official_label.
  ///
  /// In fr, this message translates to:
  /// **'Texte officiel :'**
  String get legal_result_facts_official_label;

  /// No description provided for @legal_result_facts_explanation_label.
  ///
  /// In fr, this message translates to:
  /// **'Explication simplifiée :'**
  String get legal_result_facts_explanation_label;

  /// No description provided for @legal_result_steps_label.
  ///
  /// In fr, this message translates to:
  /// **'Étapes à suivre :'**
  String get legal_result_steps_label;

  /// No description provided for @legal_result_helplines_label.
  ///
  /// In fr, this message translates to:
  /// **'Numéros utiles :'**
  String get legal_result_helplines_label;

  /// No description provided for @legal_result_organizations_label.
  ///
  /// In fr, this message translates to:
  /// **'Organismes compétents :'**
  String get legal_result_organizations_label;

  /// No description provided for @legal_result_legal_help_btn.
  ///
  /// In fr, this message translates to:
  /// **'Demander une Assistance Juridique Professionnelle'**
  String get legal_result_legal_help_btn;

  /// No description provided for @legal_result_legal_help_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Prendre contact avec un avocat, la maison du droit ou une association agréée d\'aide aux victimes.'**
  String get legal_result_legal_help_subtitle;

  /// No description provided for @legal_result_prepare_report_btn.
  ///
  /// In fr, this message translates to:
  /// **'Préparer un signalement (Consent Center)'**
  String get legal_result_prepare_report_btn;

  /// No description provided for @consent_center_title.
  ///
  /// In fr, this message translates to:
  /// **'Consentement Éclairé & Transparent'**
  String get consent_center_title;

  /// No description provided for @consent_center_notice.
  ///
  /// In fr, this message translates to:
  /// **'Aucune information personnelle ou fait déclaré ne sera transmis sans votre confirmation explicite.'**
  String get consent_center_notice;

  /// No description provided for @consent_center_data_usage_q.
  ///
  /// In fr, this message translates to:
  /// **'1. Quelles données seront utilisées ?'**
  String get consent_center_data_usage_q;

  /// No description provided for @consent_center_purpose_q.
  ///
  /// In fr, this message translates to:
  /// **'2. Pourquoi ? (Objectif)'**
  String get consent_center_purpose_q;

  /// No description provided for @consent_center_recipient_q.
  ///
  /// In fr, this message translates to:
  /// **'3. Avec quelle institution / destinataire ?'**
  String get consent_center_recipient_q;

  /// No description provided for @consent_center_transmission_q.
  ///
  /// In fr, this message translates to:
  /// **'4. Quelles informations seront transmises ?'**
  String get consent_center_transmission_q;

  /// No description provided for @consent_center_duration_q.
  ///
  /// In fr, this message translates to:
  /// **'5. Pendant combien de temps ?'**
  String get consent_center_duration_q;

  /// No description provided for @consent_center_action_q.
  ///
  /// In fr, this message translates to:
  /// **'6. Quelle action sera réalisée ?'**
  String get consent_center_action_q;

  /// No description provided for @consent_center_trace_label.
  ///
  /// In fr, this message translates to:
  /// **'Trace sécurisée localement : {checksum} | Version : {version}'**
  String consent_center_trace_label(Object checksum, Object version);

  /// No description provided for @consent_center_success_msg.
  ///
  /// In fr, this message translates to:
  /// **'Consentement enregistré avec succès dans la trace sécurisée.'**
  String get consent_center_success_msg;

  /// No description provided for @scenarios_title.
  ///
  /// In fr, this message translates to:
  /// **'Scénarios interactifs'**
  String get scenarios_title;

  /// No description provided for @scenarios_selection_notice.
  ///
  /// In fr, this message translates to:
  /// **'Ce choix sert uniquement à adapter l’orientation.'**
  String get scenarios_selection_notice;

  /// No description provided for @report_mode_anonymous.
  ///
  /// In fr, this message translates to:
  /// **'Anonyme'**
  String get report_mode_anonymous;

  /// No description provided for @report_mode_identified.
  ///
  /// In fr, this message translates to:
  /// **'Identifié'**
  String get report_mode_identified;

  /// No description provided for @report_mode_deferred.
  ///
  /// In fr, this message translates to:
  /// **'Partager plus tard'**
  String get report_mode_deferred;

  /// No description provided for @report_context_label.
  ///
  /// In fr, this message translates to:
  /// **'Contexte approximatif'**
  String get report_context_label;

  /// No description provided for @report_context_helper.
  ///
  /// In fr, this message translates to:
  /// **'N’indiquez ni adresse précise ni information identifiante.'**
  String get report_context_helper;

  /// No description provided for @report_desc_label.
  ///
  /// In fr, this message translates to:
  /// **'Description facultative'**
  String get report_desc_label;

  /// No description provided for @report_desc_hint.
  ///
  /// In fr, this message translates to:
  /// **'Notez ce que vous souhaitez conserver, sans nom ni adresse.'**
  String get report_desc_hint;

  /// No description provided for @report_local_consent_title.
  ///
  /// In fr, this message translates to:
  /// **'J’accepte l’enregistrement local et chiffré de ce brouillon sur cet appareil.'**
  String get report_local_consent_title;

  /// No description provided for @report_local_consent_subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Il ne sera transmis à aucune institution depuis cette version locale.'**
  String get report_local_consent_subtitle;

  /// No description provided for @report_save_draft_notice.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrez un brouillon personnel sur cet appareil. Il n’est transmis par l’application à aucun organisme.'**
  String get report_save_draft_notice;

  /// No description provided for @report_builder_preparation.
  ///
  /// In fr, this message translates to:
  /// **'Préparation du Rapport / Signalement'**
  String get report_builder_preparation;

  /// No description provided for @report_builder_step_collect.
  ///
  /// In fr, this message translates to:
  /// **'1. Collecte'**
  String get report_builder_step_collect;

  /// No description provided for @report_builder_step_preview.
  ///
  /// In fr, this message translates to:
  /// **'2. Aperçu'**
  String get report_builder_step_preview;

  /// No description provided for @report_builder_step_edit.
  ///
  /// In fr, this message translates to:
  /// **'3. Modification'**
  String get report_builder_step_edit;

  /// No description provided for @report_builder_step_confirm.
  ///
  /// In fr, this message translates to:
  /// **'4. Confirmation'**
  String get report_builder_step_confirm;

  /// No description provided for @report_builder_preview_title.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu du Rapport de Signalement'**
  String get report_builder_preview_title;

  /// No description provided for @report_builder_local_id.
  ///
  /// In fr, this message translates to:
  /// **'Identifiant local : {id}'**
  String report_builder_local_id(Object id);

  /// No description provided for @report_builder_consent_validated.
  ///
  /// In fr, this message translates to:
  /// **'Validé ({checksum})'**
  String report_builder_consent_validated(Object checksum);

  /// No description provided for @report_builder_consent_pending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get report_builder_consent_pending;

  /// No description provided for @report_builder_facts_title.
  ///
  /// In fr, this message translates to:
  /// **'Faits Déclarés & Résumé (Modifiable)'**
  String get report_builder_facts_title;

  /// No description provided for @report_builder_facts_hint.
  ///
  /// In fr, this message translates to:
  /// **'Modifiez ou complétez le résumé des faits...'**
  String get report_builder_facts_hint;

  /// No description provided for @report_builder_recipient_title.
  ///
  /// In fr, this message translates to:
  /// **'Destinataire Institutionnel du Signalement'**
  String get report_builder_recipient_title;

  /// No description provided for @report_builder_recipient_name_label.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'institution ou autorité'**
  String get report_builder_recipient_name_label;

  /// No description provided for @report_builder_recipient_contact_label.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées / Tribunal / Brigade'**
  String get report_builder_recipient_contact_label;

  /// No description provided for @report_builder_attachments_title.
  ///
  /// In fr, this message translates to:
  /// **'Pièces jointes / Éléments d\'appui'**
  String get report_builder_attachments_title;

  /// No description provided for @report_builder_attachments_empty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune pièce jointe ajoutée.'**
  String get report_builder_attachments_empty;

  /// No description provided for @report_builder_attachments_added_at.
  ///
  /// In fr, this message translates to:
  /// **'Ajouté le : {date}'**
  String report_builder_attachments_added_at(Object date);

  /// No description provided for @report_builder_confirm_btn.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer & Enregistrer le Dossier'**
  String get report_builder_confirm_btn;

  /// No description provided for @report_builder_dialog_title.
  ///
  /// In fr, this message translates to:
  /// **'Signalement Confirmé & Sécurisé'**
  String get report_builder_dialog_title;

  /// No description provided for @report_builder_dialog_content.
  ///
  /// In fr, this message translates to:
  /// **'Votre dossier de signalement a été validé et enregistré localement en toute sécurité.\n\nAucune transmission externe automatique n\'a été effectuée.'**
  String get report_builder_dialog_content;
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
