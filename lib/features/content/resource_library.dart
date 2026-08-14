import '../assessment/assessment_models.dart';

final List<PsychologicalResource> psychologicalResources = [
  PsychologicalResource(
    id: 'res_breathing_1',
    titleKey: 'res_breathing_title',
    descriptionKey: 'res_breathing_desc',
    contentKey: 'res_breathing_content',
    duration: '5 min',
    domain: QuestionModule.stress,
    type: ContentLibraryType.practical,
  ),
  PsychologicalResource(
    id: 'res_reframing_1',
    titleKey: 'res_reframing_title',
    descriptionKey: 'res_reframing_desc',
    contentKey: 'res_reframing_content',
    duration: '10 min',
    domain: QuestionModule.cognitive,
    type: ContentLibraryType.psychological,
  ),
  PsychologicalResource(
    id: 'res_sleep_hygiene_1',
    titleKey: 'res_sleep_hygiene_title',
    descriptionKey: 'res_sleep_hygiene_desc',
    contentKey: 'res_sleep_hygiene_content',
    duration: '15 min',
    domain: QuestionModule.sleep,
    type: ContentLibraryType.educational,
  ),
  PsychologicalResource(
    id: 'res_emotional_exp_1',
    titleKey: 'res_emotional_exp_title',
    descriptionKey: 'res_emotional_exp_desc',
    contentKey: 'res_emotional_exp_content',
    duration: '8 min',
    domain: QuestionModule.emotions,
    type: ContentLibraryType.psychological,
  ),
  PsychologicalResource(
    id: 'res_social_support_1',
    titleKey: 'res_social_support_title',
    descriptionKey: 'res_social_support_desc',
    contentKey: 'res_social_support_content',
    duration: '10 min',
    domain: QuestionModule.social,
    type: ContentLibraryType.practical,
  ),
];
