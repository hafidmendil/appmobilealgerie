class HealthQuizQuestion {
  final String textFr;
  final String textAr;
  final List<String> optionsFr;
  final List<String> optionsAr;
  final int correctIndex;

  const HealthQuizQuestion({
    required this.textFr,
    required this.textAr,
    required this.optionsFr,
    required this.optionsAr,
    required this.correctIndex,
  });
}

/// Question sets are selected from the article category encoded in the route.
/// Keeping their identifier independent from the UI prevents every health
/// article from opening the former nutrition-only questionnaire.
class HealthQuizCatalog {
  static List<HealthQuizQuestion> questionsFor(String quizId) {
    final id = quizId.toLowerCase();
    if (id.contains('sleep')) return _sleep;
    if (id.contains('psychological') || id.contains('lifestyle')) {
      return _wellbeing;
    }
    if (id.contains('traditional') ||
        id.contains('prophetic') ||
        id.contains('islamic')) {
      return _sources;
    }
    return _nutrition;
  }

  static String titleFor(String quizId, bool isArabic) {
    final id = quizId.toLowerCase();
    if (id.contains('sleep')) return isArabic ? 'اختبار النوم' : 'Quiz sommeil';
    if (id.contains('psychological') || id.contains('lifestyle')) {
      return isArabic ? 'اختبار العافية' : 'Quiz bien-être';
    }
    if (id.contains('traditional') ||
        id.contains('prophetic') ||
        id.contains('islamic')) {
      return isArabic ? 'اختبار المصادر الصحية' : 'Quiz des sources de santé';
    }
    return isArabic ? 'اختبار التغذية' : 'Quiz nutrition';
  }

  static const _nutrition = <HealthQuizQuestion>[
    HealthQuizQuestion(
      textFr: 'Que signifie une alimentation équilibrée ?',
      textAr: 'ماذا يعني الغذاء المتوازن؟',
      optionsFr: [
        'Manger beaucoup de viande',
        'Diversifier les apports nutritionnels',
        'Ne manger que des légumes',
      ],
      optionsAr: [
        'تناول الكثير من اللحوم',
        'تنويع العناصر الغذائية',
        'تناول الخضروات فقط',
      ],
      correctIndex: 1,
    ),
    HealthQuizQuestion(
      textFr: 'Pourquoi la diversité alimentaire est-elle importante ?',
      textAr: 'لماذا يُعد تنويع الغذاء مهماً؟',
      optionsFr: [
        'Uniquement pour le goût',
        'Pour couvrir les besoins en micronutriments',
        'Elle n’est pas importante',
      ],
      optionsAr: [
        'لأجل المذاق فقط',
        'لتغطية الاحتياجات من المغذيات الدقيقة',
        'ليست مهمة',
      ],
      correctIndex: 1,
    ),
    HealthQuizQuestion(
      textFr: 'Quelle source aide à vérifier un conseil nutritionnel ?',
      textAr: 'أي مصدر يساعد على التحقق من نصيحة غذائية؟',
      optionsFr: [
        'Une publication scientifique ou un professionnel qualifié',
        'Une rumeur non sourcée',
        'Un titre sensationnel',
      ],
      optionsAr: ['بحث علمي أو مختص مؤهل', 'إشاعة بلا مصدر', 'عنوان مثير فقط'],
      correctIndex: 0,
    ),
  ];

  static const _sleep = <HealthQuizQuestion>[
    HealthQuizQuestion(
      textFr: 'Quelle habitude favorise un sommeil régulier ?',
      textAr: 'أي عادة تساعد على انتظام النوم؟',
      optionsFr: [
        'Garder des horaires de coucher proches chaque jour',
        'Changer d’heure de coucher chaque nuit',
        'Consommer des stimulants avant le coucher',
      ],
      optionsAr: [
        'الحفاظ على مواعيد نوم متقاربة يومياً',
        'تغيير وقت النوم كل ليلة',
        'تناول المنبهات قبل النوم',
      ],
      correctIndex: 0,
    ),
    HealthQuizQuestion(
      textFr: 'Que peut-on faire si les difficultés de sommeil durent ?',
      textAr: 'ماذا يمكن فعله إذا استمرت صعوبات النوم؟',
      optionsFr: [
        'En parler à un professionnel de santé',
        'Ignorer tout symptôme durable',
        'Augmenter les écrans le soir',
      ],
      optionsAr: [
        'التحدث مع مختص صحي',
        'تجاهل الأعراض المستمرة',
        'زيادة استخدام الشاشات مساءً',
      ],
      correctIndex: 0,
    ),
  ];

  static const _wellbeing = <HealthQuizQuestion>[
    HealthQuizQuestion(
      textFr: 'Quelle action peut aider à réduire une tension passagère ?',
      textAr: 'ما الإجراء الذي قد يساعد على خفض التوتر العابر؟',
      optionsFr: [
        'Respirer lentement et faire une courte pause',
        'S’isoler sans demander d’aide',
        'Supprimer systématiquement ses repas',
      ],
      optionsAr: [
        'التنفس ببطء وأخذ استراحة قصيرة',
        'الانعزال دون طلب المساعدة',
        'حذف الوجبات دائماً',
      ],
      correctIndex: 0,
    ),
    HealthQuizQuestion(
      textFr: 'Quand faut-il chercher un soutien qualifié ?',
      textAr: 'متى ينبغي طلب دعم مختص؟',
      optionsFr: [
        'Quand la souffrance persiste ou affecte le quotidien',
        'Jamais',
        'Uniquement après une urgence',
      ],
      optionsAr: [
        'عندما تستمر المعاناة أو تؤثر في الحياة اليومية',
        'أبداً',
        'فقط بعد حالة طارئة',
      ],
      correctIndex: 0,
    ),
  ];

  static const _sources = <HealthQuizQuestion>[
    HealthQuizQuestion(
      textFr: 'Comment présenter une information traditionnelle de santé ?',
      textAr: 'كيف ينبغي عرض معلومة صحية تراثية؟',
      optionsFr: [
        'Avec son contexte et ses limites',
        'Comme un traitement garanti',
        'Sans préciser sa source',
      ],
      optionsAr: ['مع سياقها وحدودها', 'كعلاج مضمون', 'من دون ذكر مصدرها'],
      correctIndex: 0,
    ),
    HealthQuizQuestion(
      textFr: 'Une pratique culturelle remplace-t-elle un avis médical ?',
      textAr: 'هل تحل الممارسة الثقافية محل الاستشارة الطبية؟',
      optionsFr: [
        'Oui, toujours',
        'Non, elle ne le remplace pas',
        'Seulement en ligne',
      ],
      optionsAr: ['نعم، دائماً', 'لا، لا تحل محله', 'فقط عبر الإنترنت'],
      correctIndex: 1,
    ),
  ];
}
