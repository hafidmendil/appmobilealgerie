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
  /// **'Comment vous sentez-vous en ce moment ?'**
  String get welcomeMessage;

  /// No description provided for @startAssessment.
  ///
  /// In fr, this message translates to:
  /// **'Commencer le repérage'**
  String get startAssessment;

  /// No description provided for @languageSelection.
  ///
  /// In fr, this message translates to:
  /// **'Sélection de la langue'**
  String get languageSelection;

  /// No description provided for @consentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre confidentialité est notre priorité'**
  String get consentTitle;

  /// No description provided for @consentBody.
  ///
  /// In fr, this message translates to:
  /// **'Ce dispositif est volontaire et anonyme. Vos données sont traitées localement sur votre appareil et ne sont pas transmises aux autorités. Ce n\'est pas un outil de diagnostic médical ou criminel.'**
  String get consentBody;

  /// No description provided for @acceptConsent.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai compris et j\'accepte'**
  String get acceptConsent;

  /// No description provided for @level1Title.
  ///
  /// In fr, this message translates to:
  /// **'Auto-apaisement guidé'**
  String get level1Title;

  /// No description provided for @level2Title.
  ///
  /// In fr, this message translates to:
  /// **'Consultation conseillée'**
  String get level2Title;

  /// No description provided for @level3Title.
  ///
  /// In fr, this message translates to:
  /// **'Contact rapide recommandé'**
  String get level3Title;

  /// No description provided for @level4Title.
  ///
  /// In fr, this message translates to:
  /// **'Aide immédiate'**
  String get level4Title;

  /// No description provided for @redFlagWarning.
  ///
  /// In fr, this message translates to:
  /// **'Action prioritaire requise'**
  String get redFlagWarning;

  /// No description provided for @explanation.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi cette orientation ?'**
  String get explanation;

  /// No description provided for @q_safety_immediate_harm.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous un besoin urgent d\'aide pour ne pas vous faire du mal ou en faire à autrui ?'**
  String get q_safety_immediate_harm;

  /// No description provided for @q_phq_anxiety.
  ///
  /// In fr, this message translates to:
  /// **'Au cours des 2 dernières semaines, avez-vous eu du mal à vous détendre ou à rester calme ?'**
  String get q_phq_anxiety;

  /// No description provided for @q_tension_relational.
  ///
  /// In fr, this message translates to:
  /// **'Ressentez-vous des tensions fortes ou des conflits dans vos relations en ce moment ?'**
  String get q_tension_relational;

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
  /// **'Souvent'**
  String get opt_often;

  /// No description provided for @opt_always.
  ///
  /// In fr, this message translates to:
  /// **'Toujours'**
  String get opt_always;
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
