import '../domain/models/assessment_axis.dart';
import '../domain/models/assessment_question.dart';

class QuestionBank {
  static const List<AssessmentQuestion> questions = [
    // --- FOUNDATIONAL CONTEXT (Q000) ---
    AssessmentQuestion(
      id: "Q000_Activity",
      textFr: "Quelle est votre activité principale actuellement ?",
      textAr: "ما هو نشاطك الرئيسي حالياً؟",
      axis: AssessmentAxis.general,
      subTheme: "Contexte de vie",
      answerType: AnswerType.choice,
      options: [
        AssessmentOption(textFr: "Étudiant", textAr: "طالب", value: 0),
        AssessmentOption(
          textFr: "Salarié / Indépendant",
          textAr: "موظف / عمل حر",
          value: 0,
        ),
        AssessmentOption(
          textFr: "En recherche d'emploi",
          textAr: "باحث عن عمل",
          value: 0,
        ),
        AssessmentOption(textFr: "Autre", textAr: "آخر", value: 0),
      ],
      basePriority: 1000,
      scoreDirection: ScoreDirection.nonScored,
    ),
    AssessmentQuestion(
      id: "Q000_Living",
      textFr: "Dans quel environnement vivez-vous ?",
      textAr: "في أي بيئة تعيش؟",
      axis: AssessmentAxis.general,
      subTheme: "Environnement",
      answerType: AnswerType.choice,
      options: [
        AssessmentOption(textFr: "Seul", textAr: "بمفردي", value: 0),
        AssessmentOption(textFr: "En famille", textAr: "مع العائلة", value: 0),
        AssessmentOption(
          textFr: "En colocation",
          textAr: "سكن مشترك",
          value: 0,
        ),
      ],
      basePriority: 999,
      scoreDirection: ScoreDirection.nonScored,
    ),
    AssessmentQuestion(
      id: "Q000_Concern",
      textFr: "Quelle est votre préoccupation majeure aujourd'hui ?",
      textAr: "ما هو مصدر قلقك الرئيسي اليوم؟",
      axis: AssessmentAxis.general,
      subTheme: "Motif",
      answerType: AnswerType.choice,
      options: [
        AssessmentOption(
          textFr: "Stress / Anxiété",
          textAr: "توتر / قلق",
          value: 0,
        ),
        AssessmentOption(
          textFr: "Tristesse / Fatigue",
          textAr: "حزن / تعب",
          value: 1,
        ),
        AssessmentOption(
          textFr: "Problèmes relationnels",
          textAr: "مشاكل علاقات",
          value: 2,
        ),
        AssessmentOption(
          textFr: "Colère / conflit difficile à gérer",
          textAr: "غضب أو نزاع يصعب التعامل معه",
          value: 3,
        ),
        AssessmentOption(textFr: "Autre", textAr: "آخر", value: 4),
      ],
      nextRules: [
        NextQuestionRule(
          triggerValues: [0],
          targetQuestionId: 'Q051',
          priorityBoost: 300,
        ),
        NextQuestionRule(
          triggerValues: [1],
          targetQuestionId: 'Q001',
          priorityBoost: 300,
        ),
        NextQuestionRule(
          triggerValues: [1],
          targetQuestionId: 'Q101',
          priorityBoost: 220,
        ),
        NextQuestionRule(
          triggerValues: [2],
          targetQuestionId: 'Q201',
          priorityBoost: 300,
        ),
        NextQuestionRule(
          triggerValues: [3],
          targetQuestionId: 'Q251',
          priorityBoost: 300,
        ),
      ],
      basePriority: 998,
      scoreDirection: ScoreDirection.nonScored,
    ),

    // --- AXE 1: Humeur et émotions (Q001-Q050) ---
    AssessmentQuestion(
      id: "Q001",
      textFr:
          "Présentez-vous une labilité affective (changements d'humeur soudains) ou une dysrégulation émotionnelle ?",
      textAr: "هل تعاني من تقلبات وجدانية مفاجئة أو اضطراب في الضبط الانفعالي؟",
      axis: AssessmentAxis.emotions,
      subTheme: "Labilité affective",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 100,
    ),
    AssessmentQuestion(
      id: "Q002",
      textFr:
          "Ressentez-vous un émoussement affectif (difficulté à ressentir des émotions) ou un désengagement ?",
      textAr: "هل تعاني من خمود وجداني (صعوبة في استشعار الانفعالات) أو انفصال عاطفي؟",
      axis: AssessmentAxis.emotions,
      subTheme: "Émoussement affectif",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 95,
      scoreDirection: ScoreDirection.higherMeansLowerNeed,
      weights: {AssessmentAxis.stressAnxiety: 0.3},
    ),
    AssessmentQuestion(
      id: "Q003",
      textFr:
          "Manifestez-vous des symptômes d'anhédonie (incapacité à ressentir du plaisir) dans vos activités autrefois gratifiantes ?",
      textAr: "هل تعاني من أعراض انعدام التلذذ (Anhedonia) في أنشطتك التي كانت ممتعة سابقاً؟",
      axis: AssessmentAxis.emotions,
      subTheme: "Anhédonie clinique",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 90,
      weights: {AssessmentAxis.sleepEnergy: 0.2},
    ),
    AssessmentQuestion(
      id: "Q004",
      textFr:
          "As-tu remarqué une hyper-réactivité émotionnelle ou une irritabilité accrue ?",
      textAr:
          "هل لاحظت وجود فرط في الاستجابة الانفعالية أو زيادة في سرعة الانفعال؟",
      axis: AssessmentAxis.emotions,
      subTheme: "Irritabilité",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 85,
    ),
    AssessmentQuestion(
      id: "Q005",
      textFr:
          "Éprouves-tu une sensation de vide psychique ou de désengagement affectif ?",
      textAr: "هل تشعر بنوع من الفراغ النفسي أو الانفصال الوجداني؟",
      axis: AssessmentAxis.emotions,
      subTheme: "Vide émotionnel",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
      scoreDirection: ScoreDirection.higherMeansLowerNeed,
    ),

    // --- AXE 2: Stress et anxiété (Q051-Q100) ---
    AssessmentQuestion(
      id: "Q051",
      textFr: "Percevez-vous une augmentation de votre charge allostatique (pression cumulée des facteurs de stress) ?",
      textAr: "هل تلمس زيادة في حمولتك الضاغطة المتراكمة (العبء التكيفي العام)؟",
      axis: AssessmentAxis.stressAnxiety,
      subTheme: "Charge allostatique",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 90,
    ),
    AssessmentQuestion(
      id: "Q052",
      textFr:
          "Êtes-vous sujet à des ruminations dysfonctionnelles ou des pensées parasites envahissantes ?",
      textAr: "هل تعاني من اجترار ذهني غير وظيفي أو أفكار طفيلية مقتحمة؟",
      axis: AssessmentAxis.stressAnxiety,
      subTheme: "Cognitions intrusives",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 85,
    ),
    AssessmentQuestion(
      id: "Q053",
      textFr:
          "Manifestez-vous des somatisations neuro-végétatives (palpitations, tensions diaphragmatiques, céphalées de tension) ?",
      textAr:
          "هل تظهر عليك أعراض جسدية عصبية (خفقان، ضيق في الحجاب الحاجز، صداع توتري)؟",
      axis: AssessmentAxis.stressAnxiety,
      subTheme: "Signes neuro-végétatifs",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),
    AssessmentQuestion(
      id: "Q054",
      textFr:
          "Éprouves-tu une anxiété anticipatoire ou une appréhension irrationnelle face au futur ?",
      textAr: "هل تعاني من قلق استباقي أو توجس غير عقلاني تجاه المستقبل؟",
      axis: AssessmentAxis.stressAnxiety,
      subTheme: "Anxiété anticipatoire",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),

    // --- NEW: Burnout & Professional Exhaustion (Q600-Q620) ---
    AssessmentQuestion(
      id: "Q600",
      textFr:
          "Ressens-tu un épuisement physique et émotionnel persistant lié à ton travail ?",
      textAr: "هل تشعر بإرهاق جسدي وانفعالي مستمر ناتج عن عملك؟",
      axis: AssessmentAxis.productivity,
      subTheme: "Épuisement professionnel",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 90,
    ),
    AssessmentQuestion(
      id: "Q601",
      textFr:
          "As-tu l'impression que tes efforts au travail n'ont plus de sens ou de valeur ?",
      textAr: "هل لديك انطباع بأن جهودك في العمل لم يعد لها معنى أو قيمة؟",
      axis: AssessmentAxis.productivity,
      subTheme: "Perte de sens",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 85,
    ),
    AssessmentQuestion(
      id: "Q602",
      textFr:
          "Te sens-tu de plus en plus cynique ou détaché vis-à-vis de tes collègues ou clients ?",
      textAr: "هل تشعر بزيادة في السلبية أو الانفصال تجاه زملائك أو عملائك؟",
      axis: AssessmentAxis.productivity,
      subTheme: "Dépersonnalisation",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),

    // --- NEW: Parental Stress (Q630-Q645) ---
    AssessmentQuestion(
      id: "Q630",
      textFr:
          "Éprouves-tu une fatigue intense liée à tes responsabilités parentales ?",
      textAr: "هل تعاني من تعب شديد ناتج عن مسؤولياتك الوالدية؟",
      axis: AssessmentAxis.lifestyle,
      subTheme: "Fatigue parentale",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 85,
    ),
    AssessmentQuestion(
      id: "Q631",
      textFr:
          "As-tu le sentiment d'être submergé par les demandes quotidiennes de tes enfants ?",
      textAr: "هل تشعر بأنك غارق في المطالب اليومية لأطفالك؟",
      axis: AssessmentAxis.lifestyle,
      subTheme: "Surcharge parentale",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),

    // --- NEW: Digital & Social Media Impact (Q650-Q665) ---
    AssessmentQuestion(
      id: "Q650",
      textFr:
          "Te sens-tu anxieux ou frustré lorsque tu ne peux pas consulter tes réseaux sociaux ?",
      textAr:
          "هل تشعر بالقلق أو الإحباط عندما لا تستطيع تصفح وسائل التواصل الاجتماعي الخاصة بك؟",
      axis: AssessmentAxis.environmental,
      subTheme: "Anxiété numérique",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 70,
    ),
    AssessmentQuestion(
      id: "Q651",
      textFr:
          "As-tu tendance à comparer ta vie de manière négative à celle des autres sur Internet ?",
      textAr:
          "هل تميل إلى مقارنة حياتك بشكل سلبي مع حياة الآخرين على الإنترنت؟",
      axis: AssessmentAxis.selfConfidence,
      subTheme: "Comparaison sociale",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),

    // --- NEW: Resilience & Coping (Q670-Q690) ---
    AssessmentQuestion(
      id: "Q670",
      textFr:
          "As-tu confiance en ta capacité à surmonter les épreuves difficiles ?",
      textAr: "هل لديك ثقة في قدرتك على تجاوز الصعوبات الشديدة؟",
      axis: AssessmentAxis.selfConfidence,
      subTheme: "Confiance en soi",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 95,
    ),
    AssessmentQuestion(
      id: "Q671",
      textFr:
          "Réussis-tu à trouver des solutions créatives quand tu fais face à un problème ?",
      textAr: "هل تنجح في إيجاد حلول إبداعية عندما تواجه مشكلة ما؟",
      axis: AssessmentAxis.productivity,
      subTheme: "Résolution de problèmes",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),
    AssessmentQuestion(
      id: "Q672",
      textFr: "Arrives-tu à garder ton calme sous la pression ?",
      textAr: "هل تستطيع الحفاظ على هدوئك تحت الضغط؟",
      axis: AssessmentAxis.stressAnxiety,
      subTheme: "Gestion du stress",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 90,
    ),

    // --- AXE 3: Sommeil et énergie (Q101-Q150) ---
    AssessmentQuestion(
      id: "Q101",
      textFr:
          "As-tu observé une altération de tes cycles circadiens ou de la qualité de ton sommeil ?",
      textAr: "هل لاحظت اضطراباً في دوراتك اليوماوية أو في جودة نومك؟",
      axis: AssessmentAxis.sleepEnergy,
      subTheme: "Qualité du sommeil",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 85,
    ),
    AssessmentQuestion(
      id: "Q102",
      textFr:
          "Ressens-tu une asthénie matinale ou un manque d'énergie dès l'éveil ?",
      textAr: "هل تشعر بوهن صباحي أو افتقار للطاقة فور الاستيقاظ؟",
      axis: AssessmentAxis.sleepEnergy,
      subTheme: "Énergie matinale",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),
    AssessmentQuestion(
      id: "Q103",
      textFr:
          "Rencontres-tu des difficultés d'endormissement liées à une hyper-vigilance mentale ?",
      textAr:
          "هل تواجه صعوبات في الاستغراق في النوم مرتبطة بفرط التيقظ الذهني؟",
      axis: AssessmentAxis.sleepEnergy,
      subTheme: "Endormissement",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),

    // --- AXE 4: Concentration et travail (Q151-Q200) ---
    AssessmentQuestion(
      id: "Q151",
      textFr:
          "Éprouves-tu des difficultés à maintenir une attention soutenue sur tes tâches ?",
      textAr: "هل تجد صعوبة في الحفاظ على انتباه مستمر تجاه مهامك؟",
      axis: AssessmentAxis.productivity,
      subTheme: "Concentration",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),
    AssessmentQuestion(
      id: "Q152",
      textFr:
          "Perçois-tu une baisse de ton efficience cognitive ou un ralentissement psychomoteur ?",
      textAr:
          "هل تلمس تراجعاً في كفاءتك المعرفية أو بطئاً في النشاط النفسي الحركي؟",
      axis: AssessmentAxis.productivity,
      subTheme: "Efficacité",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),

    // --- AXE 5: Relations sociales (Q201-Q250) ---
    AssessmentQuestion(
      id: "Q201",
      textFr: "As-tu une personne avec laquelle tu peux parler librement ?",
      textAr: "هل تمتلك شبكة دعم اجتماعي تتيح لك التعبير بحرية؟",
      axis: AssessmentAxis.socialSupport,
      subTheme: "Soutien social",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),
    AssessmentQuestion(
      id: "Q202",
      textFr: "T'isoles-tu volontairement des autres ces derniers temps ?",
      textAr: "هل تميل للانسحاب الاجتماعي الطوعي في الآونة الأخيرة؟",
      axis: AssessmentAxis.socialSupport,
      subTheme: "Retrait social",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),

    // --- AXE 6: Colère et régulation (Q251-Q300) ---
    AssessmentQuestion(
      id: "Q251",
      textFr:
          "Est-ce que tu as parfois du mal à gérer tes émotions quand tu es sous pression ?",
      textAr: "هل تجد صعوبة في الضبط الانفعالي عند التعرض لضغوط مكثفة؟",
      axis: AssessmentAxis.angerRegulation,
      subTheme: "Régulation émotionnelle",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 80,
    ),
    AssessmentQuestion(
      id: "Q252",
      textFr:
          "T'arrive-t-il d'avoir des réactions explosives pour des détails ?",
      textAr: "هل تعاني من اندفاعات انفعالية حادة لأسباب بسيطة؟",
      axis: AssessmentAxis.angerRegulation,
      subTheme: "Réactivité",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),

    // --- AXE 7: Confiance en soi (Q301-Q350) ---
    AssessmentQuestion(
      id: "Q301",
      textFr: "Est-ce que tu te sens parfois trop dur envers toi-même ?",
      textAr: "هل تبالغ في النقد الذاتي أو القسوة على نفسك أحياناً؟",
      axis: AssessmentAxis.selfConfidence,
      subTheme: "Auto-critique",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 75,
    ),
    AssessmentQuestion(
      id: "Q302",
      textFr:
          "Doutes-tu de tes capacités à surmonter tes difficultés actuelles ?",
      textAr: "هل تساورك شكوك حول كفاءتك في تجاوز الأزمات الراهنة؟",
      axis: AssessmentAxis.selfConfidence,
      subTheme: "Sentiment d'auto-efficacité",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 70,
    ),

    // --- AXE 8: Pressions quotidiennes (Q351-Q400) ---
    AssessmentQuestion(
      id: "Q351",
      textFr:
          "Est-ce que tes responsabilités actuelles te semblent difficiles à gérer ?",
      textAr: "هل تبدو التزاماتك الحالية صعبة الإدارة أو مستنزفة؟",
      axis: AssessmentAxis.dailyPressures,
      subTheme: "Surcharge",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 70,
    ),
    AssessmentQuestion(
      id: "Q352",
      textFr: "As-tu l'impression de manquer de temps pour toi ?",
      textAr: "هل تدرك عجزاً في تخصيص وقت كافٍ لاستعادتك الذاتية؟",
      axis: AssessmentAxis.dailyPressures,
      subTheme: "Temps personnel",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 65,
    ),

    // --- AXE 9: Habitudes de vie (Q401-Q450) ---
    AssessmentQuestion(
      id: "Q401",
      textFr: "Arrives-tu à maintenir un équilibre entre travail et repos ?",
      textAr: "هل تنجح في الحفاظ على توازن وظيفي بين النشاط والاسترخاء؟",
      axis: AssessmentAxis.lifestyle,
      subTheme: "Équilibre",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 60,
      scoreDirection: ScoreDirection.higherMeansLowerNeed,
    ),
    AssessmentQuestion(
      id: "Q402",
      textFr: "Passes-tu beaucoup de temps sur les écrans tard le soir ?",
      textAr: "هل تفرط في استخدام الوسائط الرقمية في ساعات متأخرة؟",
      axis: AssessmentAxis.lifestyle,
      subTheme: "Hygiène numérique",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 55,
    ),

    // --- AXE 11: Traumatismes (Q501-Q520) ---
    AssessmentQuestion(
      id: "Q501",
      textFr: "Avez-vous des souvenirs ou des images de l'événement qui reviennent sans cesse alors que vous ne le voulez pas ?",
      textAr: "هل تراودك ذكريات أو صور للحدث تتكرر باستمرار رغم عدم رغبتك في ذلك؟",
      axis: AssessmentAxis.emotions,
      subTheme: "Flashbacks",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 90,
      tags: ["trauma", "intrusion"],
    ),
    AssessmentQuestion(
      id: "Q502",
      textFr: "Évitez-vous de penser à l'événement ou d'en parler, ou évitez-vous les personnes ou les lieux qui vous le rappellent ?",
      textAr: "هل تتجنب التفكير في الحدث أو التحدث عنه، أو تتجنب الأشخاص أو الأماكن التي تذكرك به؟",
      axis: AssessmentAxis.socialSupport,
      subTheme: "Évitement",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 85,
      tags: ["trauma", "avoidance"],
    ),

    // --- AXE 12: Addictions & Comportements (Q550-Q570) ---
    AssessmentQuestion(
      id: "Q550",
      textFr: "Avez-vous l'impression de consommer plus de café, tabac ou autres substances pour faire face au stress ?",
      textAr: "هل تشعر أنك تستهلك المزيد من القهوة، التبغ أو مواد أخرى لمواجهة التوتر؟",
      axis: AssessmentAxis.lifestyle,
      subTheme: "Coping négatif",
      answerType: AnswerType.frequency,
      options: _defaultOptions,
      basePriority: 70,
    ),

    AssessmentQuestion(
      id: "Q452",
      textFr:
          "Au cours du dernier mois, avez-vous eu des pensées de vous faire du mal ou le sentiment de ne plus vouloir vivre ?",
      textAr:
          "خلال الشهر الماضي، هل راودتك أفكار بإيذاء نفسك أو شعور بعدم الرغبة في الاستمرار في الحياة؟",
      axis: AssessmentAxis.safety,
      subTheme: "Idées noires",
      answerType: AnswerType.frequency,
      options: [
        AssessmentOption(textFr: "Jamais", textAr: "أبداً", value: 0),
        AssessmentOption(textFr: "Rarement", textAr: "نادراً", value: 1),
        AssessmentOption(textFr: "Parfois", textAr: "أحياناً", value: 2),
        AssessmentOption(
          textFr: "Souvent",
          textAr: "غالباً",
          value: 3,
          isSafetyTrigger: true,
        ),
        AssessmentOption(
          textFr: "Toujours",
          textAr: "دائماً",
          value: 4,
          isSafetyTrigger: true,
        ),
      ],
      safetyLevel: SafetyLevel.urgent,
      nextRules: [
        NextQuestionRule(
          triggerValues: [1, 2, 3, 4],
          targetQuestionId: 'Q453',
          priorityBoost: 900,
        ),
      ],
      basePriority: 30,
      source: 'WHO mhGAP: self-harm/suicide assessment adaptation',
      validationStatus: 'local_review_required',
      version: '2.0',
    ),
    AssessmentQuestion(
      id: 'Q453',
      textFr:
          "À cet instant, avez-vous une intention, un plan ou un moyen de vous faire du mal ?",
      textAr: "هل لديك الآن نية أو خطة أو وسيلة لإيذاء نفسك؟",
      axis: AssessmentAxis.safety,
      subTheme: 'Risque immédiat',
      answerType: AnswerType.choice,
      options: [
        AssessmentOption(textFr: 'Non', textAr: 'لا', value: 0),
        AssessmentOption(
          textFr: 'Je ne sais pas / je préfère ne pas répondre',
          textAr: 'لا أعلم / أفضل عدم الإجابة',
          value: null,
        ),
        AssessmentOption(
          textFr: 'Oui',
          textAr: 'نعم',
          value: 4,
          isSafetyTrigger: true,
        ),
      ],
      safetyLevel: SafetyLevel.urgent,
      basePriority: 20,
      source: 'WHO mhGAP: imminent self-harm/suicide risk adaptation',
      validationStatus: 'local_review_required',
      version: '2.0',
    ),
  ];

  static const List<AssessmentOption> _defaultOptions = [
    AssessmentOption(textFr: "Jamais", textAr: "أبداً", value: 0),
    AssessmentOption(textFr: "Rarement", textAr: "نادراً", value: 1),
    AssessmentOption(textFr: "Parfois", textAr: "أحياناً", value: 2),
    AssessmentOption(textFr: "Souvent", textAr: "غالباً", value: 3),
    AssessmentOption(textFr: "Toujours", textAr: "دائماً", value: 4),
    AssessmentOption(
      textFr: "Je préfère ne pas répondre",
      textAr: "أفضل عدم الإجابة",
      value: null,
    ),
  ];
}
