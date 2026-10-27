import '../adaptive_assessment/domain/models/assessment_axis.dart';
import '../adaptive_assessment/domain/models/psychological_resource.dart';

final List<PsychologicalResource> psychologicalResources = [
  PsychologicalResource(
    id: 'res_breathing_1',
    titleKey: 'res_breathing_title',
    descriptionKey: 'res_breathing_desc',
    contentKey: 'res_breathing_content',
    duration: '5 min',
    axis: AssessmentAxis.stressAnxiety,
    type: ResourceCategory.practical,
  ),
  PsychologicalResource(
    id: 'res_reframing_1',
    titleKey: 'res_reframing_title',
    descriptionKey: 'res_reframing_desc',
    contentKey: 'res_reframing_content',
    duration: '10 min',
    axis: AssessmentAxis.emotions,
    type: ResourceCategory.psychological,
  ),
  PsychologicalResource(
    id: 'res_sleep_hygiene_1',
    titleKey: 'res_sleep_hygiene_title',
    descriptionKey: 'res_sleep_hygiene_desc',
    contentKey: 'res_sleep_hygiene_content',
    duration: '15 min',
    axis: AssessmentAxis.sleepEnergy,
    type: ResourceCategory.educational,
  ),
  PsychologicalResource(
    id: 'res_emotional_exp_1',
    titleKey: 'res_emotional_exp_title',
    descriptionKey: 'res_emotional_exp_desc',
    contentKey: 'res_emotional_exp_content',
    duration: '8 min',
    axis: AssessmentAxis.emotions,
    type: ResourceCategory.psychological,
  ),
  PsychologicalResource(
    id: 'res_social_support_1',
    titleKey: 'res_social_support_title',
    descriptionKey: 'res_social_support_desc',
    contentKey: 'res_social_support_content',
    duration: '10 min',
    axis: AssessmentAxis.socialSupport,
    type: ResourceCategory.practical,
  ),
  PsychologicalResource(
    id: 'res_anxiety_guide',
    titleKey: 'Comprendre l\'anxiété',
    descriptionKey:
        'Un document complet pour identifier les mécanismes de l\'anxiété.',
    contentKey:
        'L\'anxiété est une réaction naturelle au stress. Elle devient problématique quand elle est disproportionnée par rapport à la situation...',
    duration: '20 min',
    axis: AssessmentAxis.stressAnxiety,
    type: ResourceCategory.educational,
  ),
  PsychologicalResource(
    id: 'res_depression_basics',
    titleKey: 'Sortir de la déprime',
    descriptionKey:
        'Guide pratique sur les petits pas pour retrouver de l\'énergie.',
    contentKey:
        'La déprime se caractérise par une perte d\'élan. L\'activation comportementale est une méthode efficace...',
    duration: '15 min',
    axis: AssessmentAxis.emotions,
    type: ResourceCategory.psychological,
  ),
];
