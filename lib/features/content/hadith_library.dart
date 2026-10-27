import '../adaptive_assessment/domain/models/assessment_axis.dart';
import '../adaptive_assessment/domain/models/hadith.dart';

final List<Hadith> hadithLibrary = _cleanHadiths([
  // --- THÈME : INTENTION & SENS ---
  Hadith(
    id: 'h_bukhari_1',
    collection: 'Sahih al-Bukhari',
    number: '1',
    textAr: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    textFr: 'Les actions ne valent que par les intentions.',
    theme: 'intention',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.general,
      AssessmentAxis.cognitive,
      AssessmentAxis.productivity,
    ],
  ),

  // --- THÈME : FORCE & RÉSILIENCE ---
  Hadith(
    id: 'h_muslim_2664',
    collection: 'Sahih Muslim',
    number: '2664',
    textAr:
        'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ وَفِي كُلٍّ خَيْرٌ',
    textFr:
        'Le croyant fort est meilleur et plus aimé d\'Allah que le croyant faible, bien qu\'il y ait du bien en chacun.',
    theme: 'force',
    source: 'Muslim',
    associatedAxes: [
      AssessmentAxis.selfConfidence,
      AssessmentAxis.productivity,
      AssessmentAxis.lifestyle,
    ],
  ),
  Hadith(
    id: 'h_muslim_2999',
    collection: 'Sahih Muslim',
    number: '2999',
    textAr: 'عَجَبًا لأَمْرِ الْمُؤْمِنِ إِنَّ أَمْرَهُ كُلَّهُ خَيْرٌ',
    textFr:
        'Étonnante est la situation du croyant : tout ce qui lui arrive est un bien.',
    theme: 'gratitude',
    source: 'Muslim',
    associatedAxes: [
      AssessmentAxis.emotions,
      AssessmentAxis.stressAnxiety,
      AssessmentAxis.cognitive,
    ],
  ),
  Hadith(
    id: 'h_bukhari_6470',
    collection: 'Sahih al-Bukhari',
    number: '6470',
    textAr:
        'مَا يُصِيبُ الْمُسْلِمَ مِنْ نَصَبٍ وَلاَ وَصَبٍ وَلاَ هَمٍّ وَلاَ حُزْنٍ وَلاَ أَذًى وَلاَ غَمٍّ حَتَّى الشَّوْكَةِ يُشَاكُهَا إِلاَّ كَفَّرَ اللَّهُ بِهَا مِنْ خَطَايَاهُ',
    textFr:
        'Aucun malheur n\'atteint le musulman, qu\'il s\'agisse de fatigue, de maladie, de souci, de tristesse, de préjudice ou d\'angoisse, même d\'une épine qui le pique, sans qu\'Allah n\'en fasse une expiation de ses péchés.',
    theme: 'espoir',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.emotions,
      AssessmentAxis.stressAnxiety,
      AssessmentAxis.health,
    ],
  ),

  // --- THÈME : MAÎTRISE DE SOI ---
  Hadith(
    id: 'h_bukhari_6114',
    collection: 'Sahih al-Bukhari',
    number: '6114',
    textAr:
        'لَيْسَ الشَّدِيدُ بِالصُّرَعَةِ، إِنَّمَا الشَّدِيدُ الَّذِي يَمْلِكُ نَفْسَهُ عِنْدَ الْغَضَبِ',
    textFr:
        'L\'homme fort n\'est pas celui qui terrasse les autres ; l\'homme fort est celui qui se maîtrise lorsqu\'il est en colère.',
    theme: 'maitrise_de_soi',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.angerRegulation,
      AssessmentAxis.angerRegulation,
      AssessmentAxis.emotions,
    ],
  ),
  Hadith(
    id: 'h_bukhari_6116',
    collection: 'Sahih al-Bukhari',
    number: '6116',
    textAr: 'لاَ تَغْضَبْ',
    textFr: 'Ne te mets pas en colère.',
    theme: 'colère',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.angerRegulation,
      AssessmentAxis.angerRegulation,
      AssessmentAxis.relationship,
    ],
  ),

  // --- THÈME : DOUCEUR & RELATIONS ---
  Hadith(
    id: 'h_bukhari_13',
    collection: 'Sahih al-Bukhari',
    number: '13',
    textAr:
        'لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
    textFr:
        'Nul d\'entre vous n\'est véritablement croyant tant qu\'il n\'aime pas pour son frère ce qu\'il aime pour lui-même.',
    theme: 'empathie',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.socialSupport,
      AssessmentAxis.socialSupport,
      AssessmentAxis.environmental,
    ],
  ),

  // --- THÈME : CONFIANCE & OPTIMISME ---
  Hadith(
    id: 'h_tirmidhi_2516',
    collection: 'Jami` at-Tirmidhi',
    number: '2516',
    textAr:
        'يَا غُلاَمُ إِنِّي أُعَلِّمُكَ كَلِمَاتٍ احْفَظِ اللَّهَ يَحْفَظْكَ',
    textFr:
        'Ô jeune homme ! Je vais t\'enseigner quelques paroles : Préserve les commandements d\'Allah et Il te préservera.',
    theme: 'confiance',
    source: 'Tirmidhi',
    associatedAxes: [
      AssessmentAxis.spiritual,
      AssessmentAxis.general,
      AssessmentAxis.safety,
    ],
  ),
  Hadith(
    id: 'h_tirmidhi_2344',
    collection: 'Jami` at-Tirmidhi',
    number: '2344',
    textAr:
        'لَوْ أَنَّكُمْ تَتَوَكَّلُونَ عَلَى اللَّهِ حَقَّ تَوَكُّلِهِ لَرَزَقَكُمْ كَمَا يَرْزُقُ الطَّيْرَ',
    textFr:
        'Si vous placiez votre confiance en Allah comme il se doit, Il vous donnerait votre subsistance comme Il la donne aux oiseaux.',
    theme: 'tawakkul',
    source: 'Tirmidhi',
    associatedAxes: [
      AssessmentAxis.stressAnxiety,
      AssessmentAxis.economic,
      AssessmentAxis.cognitive,
    ],
  ),

  // --- THÈME : ACTION & RESPONSABILITÉ ---
  Hadith(
    id: 'h_muslim_2623',
    collection: 'Sahih Muslim',
    number: '2623',
    textAr: 'احْرِصْ عَلَى مَا يَنْفَعُكَ وَاسْتَعِنْ بِاللَّهِ وَلاَ تَعْجِزْ',
    textFr:
        'Recherche avec ardeur ce qui te profite, demande l\'aide d\'Allah et ne faiblis pas.',
    theme: 'action',
    source: 'Muslim',
    associatedAxes: [
      AssessmentAxis.productivity,
      AssessmentAxis.behavioral,
      AssessmentAxis.functioning,
    ],
  ),
  Hadith(
    id: 'h_bukhari_2409',
    collection: 'Sahih al-Bukhari',
    number: '2409',
    textAr: 'كُلُّكُمْ رَاعٍ وَكُلُّكُمْ مَسْؤُولٌ عَنْ رَعِيَّتِهِ',
    textFr:
        'Chacun de vous est un responsable et chacun de vous est responsable de ceux qui sont sous sa responsabilité.',
    theme: 'responsabilité',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.socialSupport,
      AssessmentAxis.socialSupport,
      AssessmentAxis.general,
    ],
  ),

  // --- THÈME : PAIX INTÉRIEURE ---

  // --- THÈME : DÉPASSEMENT DE SOI & EFFORT ---
  Hadith(
    id: 'h_muslim_2732',
    collection: 'Sahih Muslim',
    number: '2732',
    textAr: 'أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ',
    textFr:
        'Les œuvres les plus aimées d\'Allah sont les plus régulières, même si elles sont peu nombreuses.',
    theme: 'régularité',
    source: 'Muslim',
    associatedAxes: [
      AssessmentAxis.behavioral,
      AssessmentAxis.productivity,
      AssessmentAxis.lifestyle,
    ],
  ),
  Hadith(
    id: 'h_bukhari_6412',
    collection: 'Sahih al-Bukhari',
    number: '6412',
    textAr: 'كُنْ فِي الدُّنْيَا كَأَنَّكَ غَرِيبٌ أَوْ عَابِرُ سَبِيلٍ',
    textFr:
        'Sois dans ce bas-monde comme un étranger ou un voyageur de passage.',
    theme: 'détachement',
    source: 'Bukhari',
    associatedAxes: [
      AssessmentAxis.emotions,
      AssessmentAxis.cognitive,
      AssessmentAxis.spiritual,
    ],
  ),
  Hadith(
    id: 'h_bukhari_6133',
    collection: 'Sahih al-Bukhari',
    number: '6133',
    textAr: 'إِنَّ اللَّهَ رَفِيقٌ يُحِبُّ الرِّفْقَ فِي الأَمْرِ كُلِّهِ',
    textFr: 'Allah est Doux et Il aime la douceur en toute chose.',
    theme: 'douceur',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.social],
  ),
  Hadith(
    id: 'h_tirmidhi_2517',
    collection: 'Jami` at-Tirmidhi',
    number: '2517',
    textAr:
        'وَاعْلَمْ أَنَّ النَّصْرَ مَعَ الصَّبْرِ وَأَنَّ الْفَرَجَ مَعَ الْكَرْبِ وَأَنَّ مَعَ الْعُسْرِ يُسْرًا',
    textFr:
        'Sache que la victoire vient avec la patience, que la délivrance vient avec la détresse et qu\'avec la difficulté vient la facilité.',
    theme: 'espoir',
    source: 'Tirmidhi',
    associatedAxes: [AssessmentAxis.stressAnxiety, AssessmentAxis.phq4],
  ),
  Hadith(
    id: 'h_bukhari_33',
    collection: 'Sahih al-Bukhari',
    number: '33',
    textAr:
        'آيَةُ الْمُنَافِقِ ثَلاَثٌ إِذَا حَدَّثَ كَذَبَ وَإِذَا وَعَدَ أَخْلَفَ وَإِذَا اؤْتُمِنَ خَانَ',
    textFr:
        'Les signes de l\'hypocrite sont trois : quand il parle, il ment ; quand il promet, il manque à sa parole ; et quand on lui fait confiance, il trahit.',
    theme: 'intégrité',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.behavioral],
  ),
  Hadith(
    id: 'h_muslim_2586',
    collection: 'Sahih Muslim',
    number: '2586',
    textAr:
        'لاَ تَحَاسَدُوا وَلاَ تَنَاجَشُوا وَلاَ تَبَاغَضُوا وَلاَ تَدَابَرُوا',
    textFr:
        'Ne soyez pas envieux les uns des autres, n\'enchérissez pas les uns sur les autres, ne vous détestez pas et ne vous tournez pas le dos.',
    theme: 'fraternité',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.relationship],
  ),
  Hadith(
    id: 'h_bukhari_6065',
    collection: 'Sahih al-Bukhari',
    number: '6065',
    textAr:
        'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
    textFr:
        'Celui qui croit en Allah et au Jour dernier, qu\'il dise du bien ou qu\'il se taise.',
    theme: 'parole',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.behavioral],
  ),
  Hadith(
    id: 'h_muslim_2699',
    collection: 'Sahih Muslim',
    number: '2699',
    textAr:
        'مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ',
    textFr:
        'Celui qui soulage un croyant d\'une peine de ce bas-monde, Allah le soulagera d\'une peine au Jour de la Résurrection.',
    theme: 'entraide',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.spiritual],
  ),
  Hadith(
    id: 'h_bukhari_6490',
    collection: 'Sahih al-Bukhari',
    number: '6490',
    textAr:
        'نِعْمَتَانِ مَغْبُونٌ فِيهِمَا كَثِيرٌ مِنَ النَّاسِ الصِّحَّةُ وَالْفَرَاغُ',
    textFr:
        'Deux bienfaits sont souvent négligés par les gens : la santé et le temps libre.',
    theme: 'gratitude',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.health, AssessmentAxis.lifestyle],
  ),
  Hadith(
    id: 'h_muslim_2956',
    collection: 'Sahih Muslim',
    number: '2956',
    textAr: 'الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ',
    textFr:
        'Le bas-monde est une prison pour le croyant et un paradis pour le mécréant.',
    theme: 'patience',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.cognitive, AssessmentAxis.spiritual],
  ),
  Hadith(
    id: 'h_bukhari_6011',
    collection: 'Sahih al-Bukhari',
    number: '6011',
    textAr:
        'مَثَلُ الْمُؤْمِنِينَ فِي تَوَادِّهِمْ وَتَرَاحُمِهِمْ وَتَعَاطُفِهِمْ مَثَلُ الْجَسَدِ',
    textFr:
        'L\'image des croyants dans leur amour, leur miséricorde et leur compassion mutuelle est celle d\'un seul corps.',
    theme: 'compassion',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.relationship],
  ),
  Hadith(
    id: 'h_muslim_2674',
    collection: 'Sahih Muslim',
    number: '2674',
    textAr:
        'مَنْ دَعَا إِلَى هُدًى كَانَ لَهُ مِنَ الأَجْرِ مِثْلُ أُجُورِ مَنْ تَبِعَهُ',
    textFr:
        'Celui qui appelle à une guidance aura une récompense égale à celle de ceux qui le suivent.',
    theme: 'inspiration',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.behavioral, AssessmentAxis.productivity],
  ),
  Hadith(
    id: 'h_bukhari_6018',
    collection: 'Sahih al-Bukhari',
    number: '6018',
    textAr:
        'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيُكْرِمْ جَارَهُ',
    textFr:
        'Celui qui croit en Allah et au Jour dernier, qu\'il honore son voisin.',
    theme: 'voisinage',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.relationship],
  ),
  Hadith(
    id: 'h_muslim_54a',
    collection: 'Sahih Muslim',
    number: '54a',
    textAr:
        'لاَ تَدْخُلُونَ الْجَنَّةَ حَتَّى تُؤْمِنُوا وَلاَ تُؤْمِنُوا حَتَّى تَحَابُّوا',
    textFr:
        'Vous n\'entrerez pas au Paradis tant que vous ne croirez pas, et vous ne croirez pas véritablement tant que vous ne vous aimerez pas les uns les autres.',
    theme: 'amour',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.relationship],
  ),
  Hadith(
    id: 'h_tirmidhi_1924',
    collection: 'Jami` at-Tirmidhi',
    number: '1924',
    textAr: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
    textFr: 'Ton sourire à l\'égard de ton frère est une aumône.',
    theme: 'positivité',
    source: 'Tirmidhi',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.emotions],
  ),
  Hadith(
    id: 'h_muslim_1009',
    collection: 'Sahih Muslim',
    number: '1009',
    textAr: 'الْكَلِمَةُ الطَّيِّبَةُ صَدَقَةٌ',
    textFr: 'La bonne parole est une aumône.',
    theme: 'positivité',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.emotions],
  ),
  Hadith(
    id: 'h_muslim_2563',
    collection: 'Sahih Muslim',
    number: '2563',
    textAr:
        'الْمُسْلِمُ أَخُو الْمُسْلِمِ لاَ يَظْلِمُهُ وَلاَ يَخْذُلُهُ وَلاَ يَحْقِرُهُ',
    textFr:
        'Le musulman est le frère du musulman : il ne l\'opprime pas, ne l\'abandonne pas et ne le méprise pas.',
    theme: 'fraternité',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.relationship],
  ),
  Hadith(
    id: 'h_muslim_2578',
    collection: 'Sahih Muslim',
    number: '2578',
    textAr:
        'اتَّقُوا الظُّلْمَ فَإِنَّ الظُّلْمَ ظُلُمَاتٌ يَوْمَ الْقِيَامَةِ',
    textFr:
        'Craignez l\'injustice, car l\'injustice sera des ténèbres au Jour de la Résurrection.',
    theme: 'justice',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.cognitive],
  ),
  Hadith(
    id: 'h_tirmidhi_2004',
    collection: 'Jami` at-Tirmidhi',
    number: '2004',
    textAr:
        'مَا مِنْ شَيْءٍ أَثْقَلُ فِي مِيزَانِ الْمُؤْمِنِ يَوْمَ الْقِيَامَةِ مِنْ حُسْنِ الْخُلُقِ',
    textFr:
        'Rien n\'est plus lourd dans la balance du croyant au Jour de la Résurrection que le bon caractère.',
    theme: 'caractère',
    source: 'Tirmidhi',
    associatedAxes: [AssessmentAxis.selfConfidence, AssessmentAxis.behavioral],
  ),
  Hadith(
    id: 'h_muslim_2622',
    collection: 'Sahih Muslim',
    number: '2622',
    textAr: 'يَسِّرُوا وَلاَ تُعَسِّرُوا وَبَشِّرُوا وَلاَ تُنَفِّرُوا',
    textFr:
        'Facilitez les choses et ne les rendez pas difficiles, annoncez de bonnes nouvelles et ne rebutez pas les gens.',
    theme: 'optimisme',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.emotions, AssessmentAxis.social],
  ),
  Hadith(
    id: 'h_tirmidhi_2317',
    collection: 'Jami` at-Tirmidhi',
    number: '2317',
    textAr:
        'ازْهَدْ فِي الدُّنْيَا يُحِبَّكَ اللَّهُ وَازْهَدْ فِيمَا عِنْدَ النَّاسِ يُحِبَّكَ النَّاسُ',
    textFr:
        'Détache-toi de ce bas-monde, Allah t\'aimera ; et détache-toi de ce que possèdent les gens, les gens t\'aimeront.',
    theme: 'détachement',
    source: 'Tirmidhi',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.selfEsteem],
  ),
  Hadith(
    id: 'h_muslim_55a',
    collection: 'Sahih Muslim',
    number: '55a',
    textAr: 'الدِّينُ النَّصِيحَةُ',
    textFr: 'La religion, c\'est le conseil sincère.',
    theme: 'conseil',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.relationship],
  ),
  Hadith(
    id: 'h_tirmidhi_2499',
    collection: 'Jami` at-Tirmidhi',
    number: '2499',
    textAr: 'مِنْ حُسْنِ إِسْلَامِ الْمَرْءِ تَرْكُهُ مَا لَا يَعْنِيهِ',
    textFr:
        'Fait partie de l\'excellence de l\'Islam d\'une personne le fait de délaisser ce qui ne la regarde pas.',
    theme: 'discrétion',
    source: 'Tirmidhi',
    associatedAxes: [AssessmentAxis.behavioral, AssessmentAxis.cognitive],
  ),
  Hadith(
    id: 'h_bukhari_1',
    collection: 'Sahih al-Bukhari',
    number: '1',
    textAr: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    textFr: 'Les actions ne valent que par les intentions.',
    theme: 'intention',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.behavioral, AssessmentAxis.spiritual],
  ),
  Hadith(
    id: 'h_muslim_2664',
    collection: 'Sahih Muslim',
    number: '2664',
    textAr:
        'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ',
    textFr:
        'Le croyant fort est meilleur et plus aimé d\'Allah que le croyant faible.',
    theme: 'force',
    source: 'Muslim',
    associatedAxes: [
      AssessmentAxis.selfConfidence,
      AssessmentAxis.productivity,
    ],
  ),
  Hadith(
    id: 'h_tirmidhi_2516',
    collection: 'Jami` at-Tirmidhi',
    number: '2516',
    textAr:
        'يَا غُلاَمُ إِنِّي أُعَلِّمُكَ كَلِمَاتٍ احْفَظِ اللَّهَ يَحْفَظْكَ',
    textFr:
        'Ô jeune homme ! Je vais t\'enseigner quelques paroles : Préserve Allah et Il te préservera.',
    theme: 'confiance',
    source: 'Tirmidhi',
    associatedAxes: [AssessmentAxis.spiritual, AssessmentAxis.safety],
  ),
  Hadith(
    id: 'h_muslim_2564a',
    collection: 'Sahih Muslim',
    number: '2564a',
    textAr:
        'كُلُّ الْمُسْلِمِ عَلَى الْمُسْلِمِ حَرَامٌ دَمُهُ وَمَالُهُ وَعِرْضُهُ',
    textFr:
        'Tout ce qui appartient au musulman est sacré pour le musulman : son sang, ses biens et son honneur.',
    theme: 'respect',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.socialSupport, AssessmentAxis.safety],
  ),
  Hadith(
    id: 'h_muslim_2564b',
    collection: 'Sahih Muslim',
    number: '2564b',
    textAr:
        'إِنَّ اللَّهَ لَا يَنْظُرُ إِلَى أَجْسَادِكُمْ وَلَا إِلَى صُوَرِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ',
    textFr:
        'Allah ne regarde pas vos apparences ni vos richesses, mais Il regarde vos cœurs et vos œuvres.',
    theme: 'authenticité',
    source: 'Muslim',
    associatedAxes: [AssessmentAxis.selfConfidence, AssessmentAxis.spiritual],
  ),
  Hadith(
    id: 'h_bukhari_6120',
    collection: 'Sahih al-Bukhari',
    number: '6120',
    textAr: 'إِنَّ مِنْ خِيَارِكُمْ أَحْسَنَكُمْ أَخْلَاقًا',
    textFr:
        'Certes, les meilleurs d\'entre vous sont ceux qui ont le meilleur caractère.',
    theme: 'caractère',
    source: 'Bukhari',
    associatedAxes: [AssessmentAxis.selfConfidence, AssessmentAxis.behavioral],
  ),
]);

List<Hadith> _cleanHadiths(List<Hadith> source) {
  final seenIds = <String>{};
  const excludedIds = {
    'h_tirmidhi_2016',
    'h_tirmidhi_2520',
    'h_tirmidhi_2465',
    'h_tirmidhi_2488',
    'h_bukhari_6019',
    'h_bukhari_6130',
    'h_bukhari_6407',
    'h_muslim_2999_2',
    'h_muslim_2581',
    'h_tirmidhi_2310',
    'h_bukhari_6015',
    'h_tirmidhi_2515',
    'h_tirmidhi_1987',
    'h_bukhari_6010',
    'h_tirmidhi_2344_2',
    'h_bukhari_6122',
    'h_muslim_2591',
    'h_muslim_2553',
    'h_muslim_2588',
    'h_muslim_2628',
    'h_muslim_2564',
    'h_muslim_2558',
    'h_muslim_2625',
    'h_tirmidhi_2501',
  };
  return source
      .where((hadith) => !excludedIds.contains(hadith.id))
      .where((hadith) => seenIds.add(hadith.id))
      .toList();
}
