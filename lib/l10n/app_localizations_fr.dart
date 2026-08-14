// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'NeuroSync 4.0';

  @override
  String get welcomeMessage => 'Comment vous sentez-vous en ce moment ?';

  @override
  String get startAssessment => 'Commencer le repérage';

  @override
  String get languageSelection => 'Sélection de la langue';

  @override
  String get consentTitle => 'Votre confidentialité est notre priorité';

  @override
  String get consentBody =>
      'Ce dispositif est volontaire et anonyme. Vos données sont traitées localement sur votre appareil et ne sont pas transmises aux autorités. Ce n\'est pas un outil de diagnostic médical ou criminel.';

  @override
  String get acceptConsent => 'J\'ai compris et j\'accepte';

  @override
  String get level1Title => 'Auto-apaisement guidé';

  @override
  String get level2Title => 'Consultation conseillée';

  @override
  String get level3Title => 'Contact rapide recommandé';

  @override
  String get level4Title => 'Aide immédiate';

  @override
  String get redFlagWarning => 'Action prioritaire requise';

  @override
  String get explanation => 'Pourquoi cette orientation ?';

  @override
  String get q_safety_immediate_harm =>
      'Ressentez-vous un besoin urgent d\'aide pour ne pas vous faire du mal ou en faire à autrui ?';

  @override
  String get q_phq_anxiety =>
      'Au cours des 2 dernières semaines, avez-vous eu du mal à vous détendre ou à rester calme ?';

  @override
  String get q_tension_relational =>
      'Ressentez-vous des tensions fortes ou des conflits dans vos relations en ce moment ?';

  @override
  String get opt_never => 'Jamais';

  @override
  String get opt_sometimes => 'Parfois';

  @override
  String get opt_often => 'Souvent';

  @override
  String get opt_always => 'Toujours';
}
