// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'NeuroSync 4.0';

  @override
  String get welcomeMessage => 'كيف تشعر في هذه اللحظة؟';

  @override
  String get startAssessment => 'ابدأ التقييم';

  @override
  String get languageSelection => 'اختيار اللغة';

  @override
  String get consentTitle => 'خصوصيتك هي أولويتنا';

  @override
  String get consentBody =>
      'هذا النظام تطوعي ومجهول الهوية. يتم معالجة بياناتك محلياً على جهازك ولا يتم إرسالها إلى أي سلطات. هذا ليس أداة تشخيص طبي أو جنائي.';

  @override
  String get acceptConsent => 'فهمت وأوافق';

  @override
  String get level1Title => 'توجيه ذاتي للهدوء';

  @override
  String get level2Title => 'يُنصح باستشارة';

  @override
  String get level3Title => 'يُنصح بالتواصل السريع';

  @override
  String get level4Title => 'مساعدة فورية';

  @override
  String get redFlagWarning => 'مطلوب إجراء فوري';

  @override
  String get explanation => 'لماذا هذا التوجيه؟';

  @override
  String get q_safety_immediate_harm =>
      'هل تشعر بحاجة ملحة للمساعدة لتجنب إيذاء نفسك أو الآخرين؟';

  @override
  String get q_phq_anxiety =>
      'خلال الأسبوعين الماضيين، هل وجدت صعوبة في الاسترخاء أو البقاء هادئاً؟';

  @override
  String get q_tension_relational =>
      'هل تشعر بتوترات قوية أو صراعات في علاقاتك حالياً؟';

  @override
  String get opt_never => 'أبداً';

  @override
  String get opt_sometimes => 'أحياناً';

  @override
  String get opt_often => 'غالباً';

  @override
  String get opt_always => 'دائماً';
}
