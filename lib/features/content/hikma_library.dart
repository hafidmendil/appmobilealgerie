import '../adaptive_assessment/domain/models/hikma.dart';
import '../adaptive_assessment/domain/models/assessment_axis.dart';
import '../adaptive_assessment/domain/models/domain_state.dart';

final List<Hikma> hikmaLibrary = [
  Hikma(
    id: 'hik_1',
    textAr: "مَا لاَ يُدْرَكُ كُلُّهُ لاَ يُتْرَكُ جُلُّهُ",
    textFr:
        "Ce qui ne peut être réalisé entièrement ne doit pas conduire à abandonner ce qui peut encore l’être.",
    authorAr: "Sagesse traditionnelle",
    authorFr: "Sagesse traditionnelle",
    associatedAxes: [AssessmentAxis.functioning, AssessmentAxis.behavioral],
    associatedStates: [DeclaredState.overload, DeclaredState.lackOfMotivation],
  ),
  Hikma(
    id: 'hik_2',
    textAr: "الصَّبْرُ مِفْتَاحُ الْفَرَجِ",
    textFr: "La patience est la clé du soulagement.",
    authorAr: "Proverbe traditionnel",
    authorFr: "Proverbe traditionnel",
    associatedAxes: [AssessmentAxis.stress],
    associatedStates: [DeclaredState.stress, DeclaredState.academicDifficulty],
  ),
  Hikma(
    id: 'hik_3',
    textAr: "الْوَقْتُ كَالسَّيْفِ إِنْ لَمْ تَقْطَعْهُ قَطَعَكَ",
    textFr:
        "Le temps est comme un sabre : si tu ne l’utilises pas à temps, il se retournera contre toi.",
    authorAr: "Proverbe populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.behavioral],
    associatedStates: [
      DeclaredState.academicDifficulty,
      DeclaredState.overload,
    ],
  ),
  Hikma(
    id: 'hik_4',
    textAr: "مَن جَدَّ وَجَدَ وَمَن زَرَعَ حَصَدَ",
    textFr: "Qui s’efforce finit par trouver, et qui sème finit par récolter.",
    authorAr: "Proverbe arabe",
    authorFr: "Proverbe arabe",
    associatedAxes: [AssessmentAxis.productivity, AssessmentAxis.behavioral],
    associatedStates: [DeclaredState.lackOfMotivation],
  ),
  Hikma(
    id: 'hik_5',
    textAr: "الْعِلْمُ فِي الصِّغَرِ كَالنَّقْشِ عَلَى الْحَجَرِ",
    textFr:
        "L’apprentissage dans la jeunesse est comme une gravure dans la pierre.",
    authorAr: "Sagesse traditionnelle",
    authorFr: "Sagesse traditionnelle",
    associatedAxes: [AssessmentAxis.cognitive, AssessmentAxis.productivity],
    associatedStates: [DeclaredState.academicDifficulty],
  ),
  Hikma(
    id: 'hik_6',
    textAr:
        "لِسَانُكَ حِصَانُكَ، إِنْ صُنْتَهُ صَانَكَ وَإِنْ خُنْتَهُ خَانَكَ",
    textFr:
        "Ta langue est comme ton cheval : si tu la maîtrises, elle te protège ; si tu la laisses te dominer, elle peut te nuire.",
    authorAr: "Proverbe populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.social, AssessmentAxis.relationship],
    associatedStates: [DeclaredState.relationalConflict],
  ),
  Hikma(
    id: 'hik_7',
    textAr: "لَا تُؤَجِّلْ عَمَلَ الْيَوْمِ إِلَى الْغَدِ",
    textFr: "Ne remets pas à demain ce que tu peux faire aujourd’hui.",
    authorAr: "Proverbe",
    authorFr: "Proverbe",
    associatedAxes: [AssessmentAxis.behavioral, AssessmentAxis.productivity],
    associatedStates: [DeclaredState.overload],
  ),
  Hikma(
    id: 'hik_8',
    textAr: "الْقَنَاعَةُ كَنْزٌ لَا يَفْنَى",
    textFr: "Le contentement est un trésor qui ne s’épuise pas.",
    authorAr: "Proverbe populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.emotions, AssessmentAxis.selfEsteem],
    associatedStates: [DeclaredState.lackOfMotivation],
  ),
  Hikma(
    id: 'hik_9',
    textAr: "فِي التَّأَنِّي السَّلَامَةُ وَفِي الْعَجَلَةِ النَّدَامَةُ",
    textFr:
        "Dans la réflexion et la modération réside la sécurité ; dans la précipitation, le regret.",
    authorAr: "Proverbe traditionnel",
    authorFr: "Proverbe traditionnel",
    associatedAxes: [AssessmentAxis.stressAnxiety, AssessmentAxis.cognitive],
    associatedStates: [DeclaredState.stress],
  ),
  Hikma(
    id: 'hik_10',
    textAr: "خَيْرُ الْكَلَامِ مَا قَلَّ وَدَلَّ",
    textFr:
        "La meilleure parole est celle qui est concise et porteuse de sens.",
    authorAr: "Sagesse populaire",
    authorFr: "Sagesse populaire",
    associatedAxes: [AssessmentAxis.social, AssessmentAxis.behavioral],
    associatedStates: [DeclaredState.relationalConflict],
  ),
  Hikma(
    id: 'hik_11',
    textAr: "الصَّدِيقُ وَقْتَ الضِّيقِ",
    textFr: "C’est dans l’épreuve que l’on reconnaît ses vrais amis.",
    authorAr: "Proverbe",
    authorFr: "Proverbe",
    associatedAxes: [AssessmentAxis.relationship, AssessmentAxis.social],
    associatedStates: [DeclaredState.isolation],
  ),
  Hikma(
    id: 'hik_12',
    textAr: "مَنْ حَفَرَ حُفْرَةً لِأَخِيهِ وَقَعَ فِيهَا",
    textFr:
        "Celui qui creuse une fosse pour son prochain risque d’y tomber lui-même.",
    authorAr: "Proverbe populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.social, AssessmentAxis.relationship],
    associatedStates: [DeclaredState.relationalConflict],
  ),
  Hikma(
    id: 'hik_13',
    textAr: "الْعَقْلُ السَّلِيمُ فِي الْجِسْمِ السَّلِيمِ",
    textFr: "Un esprit sain dans un corps sain.",
    authorAr: "Formule issue de la tradition latine",
    authorFr: "Formule issue de la tradition latine",
    associatedAxes: [AssessmentAxis.lifestyle, AssessmentAxis.health],
    associatedStates: [DeclaredState.stress],
  ),
  Hikma(
    id: 'hik_14',
    textAr: "بَشِّرُوا وَلَا تُنَفِّرُوا، وَيَسِّرُوا وَلَا تُعَسِّرُوا",
    textFr:
        "Annoncez de bonnes nouvelles et ne rebutez pas les gens ; facilitez les choses et ne les rendez pas difficiles.",
    authorAr: "Prophète Muhammad ﷺ",
    authorFr: "Prophète Muhammad ﷺ",
    associatedAxes: [AssessmentAxis.emotions, AssessmentAxis.social],
    associatedStates: [DeclaredState.stress],
  ),
  Hikma(
    id: 'hik_15',
    textAr: "إِذَا كَانَ الْكَلَامُ مِنْ فِضَّةٍ فَالسُّكُوتُ مِنْ ذَهَبٍ",
    textFr: "Si la parole est d’argent, le silence est d’or.",
    authorAr: "Proverbe populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.behavioral, AssessmentAxis.social],
    associatedStates: [DeclaredState.relationalConflict],
  ),
  Hikma(
    id: 'hik_16',
    textAr: "تَفَاءَلُوا بِالْخَيْرِ تَجِدُوهُ",
    textFr:
        "Gardez espoir dans le bien et cherchez les possibilités positives.",
    authorAr: "Sagesse populaire",
    authorFr: "Sagesse populaire",
    associatedAxes: [AssessmentAxis.spiritual, AssessmentAxis.emotions],
    associatedStates: [DeclaredState.sad, DeclaredState.lackOfMotivation],
  ),
  Hikma(
    id: 'hik_17',
    textAr: "الْعَجَلَةُ مِنَ الشَّيْطَانِ وَالتَّأَنِّي مِنَ الرَّحْمَنِ",
    textFr:
        "La précipitation vient du diable, tandis que la retenue vient du Tout-Miséricordieux.",
    authorAr: "Prophète Muhammad ﷺ",
    authorFr: "Prophète Muhammad ﷺ",
    associatedAxes: [AssessmentAxis.stressAnxiety, AssessmentAxis.cognitive],
    associatedStates: [DeclaredState.stress, DeclaredState.overload],
  ),
  Hikma(
    id: 'hik_18',
    textAr: "مَنْ صَبَرَ ظَفِرَ",
    textFr: "Celui qui persévère finit par réussir.",
    authorAr: "Proverbe",
    authorFr: "Proverbe",
    associatedAxes: [AssessmentAxis.stressAnxiety, AssessmentAxis.productivity],
    associatedStates: [
      DeclaredState.academicDifficulty,
      DeclaredState.professionalDifficulty,
    ],
  ),
  Hikma(
    id: 'hik_19',
    textAr: "مَا ضَاقَتْ إِلَّا فُرِّجَتْ",
    textFr:
        "Même lorsque la situation se resserre, un soulagement peut finir par apparaître.",
    authorAr: "Expression traditionnelle",
    authorFr: "Expression traditionnelle",
    associatedAxes: [AssessmentAxis.stressAnxiety, AssessmentAxis.emotions],
    associatedStates: [DeclaredState.stress, DeclaredState.sad],
  ),
  Hikma(
    id: 'hik_20',
    textAr:
        "اعْمَلْ لِدُنْيَاكَ كَأَنَّكَ تَعِيشُ أَبَدًا، وَاعْمَلْ لِآخِرَتِكَ كَأَنَّكَ تَمُوتُ غَدًا",
    textFr:
        "Agis pour ta vie ici-bas comme si tu devais vivre longtemps, et œuvre pour ton au-delà comme si tu devais mourir demain.",
    authorAr: "Sagesse populaire",
    authorFr: "Sagesse populaire",
    associatedAxes: [AssessmentAxis.lifestyle, AssessmentAxis.spiritual],
    associatedStates: [DeclaredState.seekingMeaning, DeclaredState.overload],
  ),
  Hikma(
    id: 'hik_21',
    textAr: "الْحِلْمُ عِنْدَ الْغَضَبِ",
    textFr: "La véritable maîtrise de soi se manifeste dans la colère.",
    authorAr: "Formule proverbiale",
    authorFr: "Formule proverbiale",
    associatedAxes: [
      AssessmentAxis.angerRegulation,
      AssessmentAxis.emotionalManagement,
    ],
    associatedStates: [
      DeclaredState.relationalConflict,
      DeclaredState.familyConflict,
    ],
  ),
  Hikma(
    id: 'hik_22',
    textAr: "دَوَامُ الْحَالِ مِنَ الْمُحَالِ",
    textFr: "Aucun état ne demeure éternellement inchangé.",
    authorAr: "Proverbe arabe",
    authorFr: "Proverbe arabe",
    associatedAxes: [AssessmentAxis.emotions, AssessmentAxis.cognitive],
    associatedStates: [DeclaredState.sad, DeclaredState.stress],
  ),
  Hikma(
    id: 'hik_23',
    textAr: "مَنْ سَارَ عَلَى الدَّرْبِ وَصَلَ",
    textFr:
        "Celui qui avance avec constance sur son chemin finit par atteindre son but.",
    authorAr: "Proverbe populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.behavioral, AssessmentAxis.productivity],
    associatedStates: [
      DeclaredState.lackOfMotivation,
      DeclaredState.academicDifficulty,
    ],
  ),
  Hikma(
    id: 'hik_24',
    textAr: "الصِّحَّةُ تَاجٌ عَلَى رُؤُوسِ الْأَصِحَّاءِ",
    textFr:
        "La santé est un trésor précieux dont on mesure souvent la valeur lorsqu’elle est préservée.",
    authorAr: "Expression populaire",
    authorFr: "Expression populaire",
    associatedAxes: [AssessmentAxis.health, AssessmentAxis.lifestyle],
    associatedStates: [DeclaredState.medicalCondition, DeclaredState.stress],
  ),
  Hikma(
    id: 'hik_25',
    textAr: "الْبَابُ اللِّي يِجِي مِنْهُ الرِّيحُ سُدَّهُ وَاسْتَرِيحْ",
    textFr:
        "Ferme la porte par laquelle entre le vent, et tu trouveras du repos.",
    authorAr: "Proverbe dialectal populaire",
    authorFr: "Proverbe populaire",
    associatedAxes: [AssessmentAxis.environmental, AssessmentAxis.social],
    associatedStates: [
      DeclaredState.relationalProblem,
      DeclaredState.relationalConflict,
    ],
  ),
];
