import '../adaptive_assessment/domain/models/assessment_axis.dart';
import '../adaptive_assessment/domain/models/micro_action.dart';

final List<MicroAction> microActions = [
  MicroAction(
    id: 'act_glass_water',
    titleKey: 'act_glass_water_title',
    descriptionKey: 'act_glass_water_desc',
    axis: AssessmentAxis.lifestyle,
    estimatedMinutes: 1,
    type: 'action',
  ),
  MicroAction(
    id: 'act_deep_breath_3',
    titleKey: 'act_deep_breath_title',
    descriptionKey: 'act_deep_breath_desc',
    axis: AssessmentAxis.stressAnxiety,
    estimatedMinutes: 2,
    type: 'action',
  ),
  MicroAction(
    id: 'act_write_emotion',
    titleKey: 'act_write_emotion_title',
    descriptionKey: 'act_write_emotion_desc',
    axis: AssessmentAxis.emotions,
    estimatedMinutes: 5,
    type: 'action',
  ),
  MicroAction(
    id: 'act_call_friend',
    titleKey: 'act_call_friend_title',
    descriptionKey: 'act_call_friend_desc',
    axis: AssessmentAxis.relationship,
    estimatedMinutes: 10,
    type: 'action',
  ),
  MicroAction(
    id: 'act_gratitude_list',
    titleKey: 'act_gratitude_list_title',
    descriptionKey: 'act_gratitude_list_desc',
    axis: AssessmentAxis.selfEsteem,
    estimatedMinutes: 5,
    type: 'action',
  ),
  MicroAction(
    id: 'act_sunlight',
    titleKey: 'act_sunlight_title',
    descriptionKey: 'act_sunlight_desc',
    axis: AssessmentAxis.lifestyle,
    estimatedMinutes: 10,
    type: 'action',
  ),
  MicroAction(
    id: 'act_tidy',
    titleKey: 'act_tidy_title',
    descriptionKey: 'act_tidy_desc',
    axis: AssessmentAxis.behavioral,
    estimatedMinutes: 5,
    type: 'action',
  ),
  MicroAction(
    id: 'act_stretch',
    titleKey: 'act_stretch_title',
    descriptionKey: 'act_stretch_desc',
    axis: AssessmentAxis.stressAnxiety,
    estimatedMinutes: 1,
    type: 'action',
  ),
  MicroAction(
    id: 'act_cognitive_reframing',
    titleKey: 'custom',
    descriptionKey: 'custom',
    titleFr: 'Réencadrement Cognitif',
    titleAr: 'إعادة التأطير المعرفي',
    descFr:
        'Identifiez une pensée négative et essayez de la voir sous un angle plus réaliste ou positif.',
    descAr: 'حدد فكرة سلبية وحاول رؤيتها من زاوية أكثر واقعية أو إيجابية.',
    axis: AssessmentAxis.cognitive,
    estimatedMinutes: 5,
  ),
  MicroAction(
    id: 'act_power_hour',
    titleKey: 'custom',
    descriptionKey: 'custom',
    titleFr: 'L\'heure de concentration',
    titleAr: 'ساعة التركيز',
    descFr:
        'Travaillez 50 min sans aucune distraction (téléphone loin) puis 10 min de pause totale.',
    descAr:
        'اعمل لمدة 50 دقيقة دون أي تشتيت (أبعد الهاتف) ثم خذ 10 دقائق استراحة تامة.',
    axis: AssessmentAxis.productivity,
    estimatedMinutes: 60,
  ),
  MicroAction(
    id: 'act_parent_pause',
    titleKey: 'custom',
    descriptionKey: 'custom',
    titleFr: 'Pause Parentale Consciente',
    titleAr: 'استراحة الوالدية الواعية',
    descFr:
        'Fermez les yeux 2 minutes quand les enfants dorment ou sont occupés pour observer votre souffle.',
    descAr:
        'أغمض عينيك لمدة دقيقتين عندما ينام الأطفال أو ينشغلون لمراقبة تنفسك.',
    axis: AssessmentAxis.lifestyle,
    estimatedMinutes: 2,
  ),
];
