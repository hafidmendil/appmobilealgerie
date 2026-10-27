import '../adaptive_assessment/domain/models/assessment_axis.dart';

enum VideoCategory { support, educational, tutorial, meditation }

class SupportVideo {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final String url;
  final String thumbnailUrl;
  final VideoCategory category;
  final AssessmentAxis axis;

  const SupportVideo({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.url,
    required this.thumbnailUrl,
    required this.category,
    required this.axis,
  });
}

final List<SupportVideo> supportVideos = [
  SupportVideo(
    id: 'vid_001',
    title: 'Comprendre l\'Anxiété',
    titleAr: 'فهم القلق',
    description:
        'Une explication simple sur les mécanismes du stress et de l\'anxiété.',
    descriptionAr: 'شرح مبسط لآليات التوتر والقلق.',
    url: 'https://www.youtube.com/watch?v=17C_7a8I3-0',
    thumbnailUrl: 'https://img.youtube.com/vi/17C_7a8I3-0/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.stressAnxiety,
  ),
  SupportVideo(
    id: 'vid_002',
    title: 'Technique de Respiration 4-7-8',
    titleAr: 'تقنية التنفس 4-7-8',
    description:
        'Tutoriel guidé pour calmer le système nerveux en quelques minutes.',
    descriptionAr: 'تدريب إرشادي لتهدئة الجهاز العصبي خلال دقائق.',
    url: 'https://www.youtube.com/watch?v=17C_7a8I3-0',
    thumbnailUrl: 'https://img.youtube.com/vi/17C_7a8I3-0/0.jpg',
    category: VideoCategory.tutorial,
    axis: AssessmentAxis.stressAnxiety,
  ),
  SupportVideo(
    id: 'vid_003',
    title: 'Gérer ses émotions fortes',
    titleAr: 'إدارة المشاعر القوية',
    description:
        'Conseils pratiques pour ne pas se laisser submerger par ses sentiments.',
    descriptionAr: 'نصائح عملية لتجنب الانجراف وراء المشاعر.',
    url: 'https://www.youtube.com/watch?v=l7TONauJGfc',
    thumbnailUrl: 'https://img.youtube.com/vi/l7TONauJGfc/0.jpg',
    category: VideoCategory.support,
    axis: AssessmentAxis.emotions,
  ),
  SupportVideo(
    id: 'vid_004',
    title: 'L\'importance du sommeil',
    titleAr: 'أهمية النوم',
    description:
        'Pourquoi le repos est votre meilleur allié pour la santé mentale.',
    descriptionAr: 'لماذا يعد النوم حليفاً أساسياً للصحة النفسية.',
    url: 'https://www.youtube.com/watch?v=l7TONauJGfc',
    thumbnailUrl: 'https://img.youtube.com/vi/l7TONauJGfc/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.sleepEnergy,
  ),
  SupportVideo(
    id: 'vid_005',
    title: 'Améliorer sa Concentration',
    titleAr: 'تحسين التركيز والإنتاجية',
    description: 'Techniques pour rester focalisé sur ses objectifs sans s\'épuiser.',
    descriptionAr: 'تقنيات للبقاء مركزاً على أهدافك دون إرهاق.',
    url: 'https://www.youtube.com/watch?v=zG_BnbFkQ1I',
    thumbnailUrl: 'https://img.youtube.com/vi/zG_BnbFkQ1I/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.productivity,
  ),
  SupportVideo(
    id: 'vid_006',
    title: 'Briser l\'isolement social',
    titleAr: 'كسر العزلة الاجتماعية',
    description: 'Comment renouer des liens et trouver du soutien dans son entourage.',
    descriptionAr: 'كيفية إعادة بناء العلاقات وإيجاد الدعم من المحيطين بك.',
    url: 'https://www.youtube.com/watch?v=9_1Rt1R4xbM',
    thumbnailUrl: 'https://img.youtube.com/vi/9_1Rt1R4xbM/0.jpg',
    category: VideoCategory.support,
    axis: AssessmentAxis.socialSupport,
  ),
  SupportVideo(
    id: 'vid_007',
    title: 'Apaiser la Colère',
    titleAr: 'تهدئة الغضب',
    description: 'Comprendre sa colère et apprendre à la canaliser sainement.',
    descriptionAr: 'فهم غضبك وتعلم كيفية توجيهه بطريقة صحية.',
    url: 'https://www.youtube.com/watch?v=BsVq5R_F6RA',
    thumbnailUrl: 'https://img.youtube.com/vi/BsVq5R_F6RA/0.jpg',
    category: VideoCategory.meditation,
    axis: AssessmentAxis.angerRegulation,
  ),
  SupportVideo(
    id: 'vid_008',
    title: 'Renforcer l\'Estime de Soi',
    titleAr: 'تعزيز الثقة بالنفس',
    description: 'Exercices pratiques pour développer la bienveillance envers soi-même.',
    descriptionAr: 'تمارين عملية لتطوير التسامح واللطف مع الذات.',
    url: 'https://www.youtube.com/watch?v=l_NYrWqUR40',
    thumbnailUrl: 'https://img.youtube.com/vi/l_NYrWqUR40/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.selfConfidence,
  ),
  SupportVideo(
    id: 'vid_009',
    title: 'Faire face aux pressions',
    titleAr: 'مواجهة الضغوط اليومية',
    description: 'Stratégies pour alléger sa charge mentale au quotidien.',
    descriptionAr: 'استراتيجيات لتخفيف العبء الذهني في الحياة اليومية.',
    url: 'https://www.youtube.com/watch?v=s93ywqFa6CM',
    thumbnailUrl: 'https://img.youtube.com/vi/s93ywqFa6CM/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.dailyPressures,
  ),
  SupportVideo(
    id: 'vid_010',
    title: 'Trouver un Équilibre de Vie',
    titleAr: 'إيجاد توازن في الحياة',
    description: 'Redéfinir ses priorités pour une hygiène de vie saine.',
    descriptionAr: 'إعادة تحديد الأولويات لأسلوب حياة صحي ومتوازن.',
    url: 'https://www.youtube.com/watch?v=1sQfC-v5WJw',
    thumbnailUrl: 'https://img.youtube.com/vi/1sQfC-v5WJw/0.jpg',
    category: VideoCategory.tutorial,
    axis: AssessmentAxis.lifestyle,
  ),
  SupportVideo(
    id: 'vid_011',
    title: 'Se Protéger et Demander de l\'Aide',
    titleAr: 'حماية النفس وطلب المساعدة',
    description: 'Ressources et conseils quand on se sent en danger ou vulnérable.',
    descriptionAr: 'موارد ونصائح عندما تشعر بالخطر أو الضعف.',
    url: 'https://www.youtube.com/watch?v=8mQzWzXy2dY',
    thumbnailUrl: 'https://img.youtube.com/vi/8mQzWzXy2dY/0.jpg',
    category: VideoCategory.support,
    axis: AssessmentAxis.safety,
  ),
  SupportVideo(
    id: 'vid_012',
    title: 'La pensée positive en psychologie',
    titleAr: 'التفكير الإيجابي في علم النفس',
    description: 'Comment transformer ses schémas de pensée pour un meilleur état psychologique.',
    descriptionAr: 'كيفية تحويل أنماط التفكير للوصول إلى حالة نفسية أفضل.',
    url: 'https://www.youtube.com/watch?v=yW63vWbQdD8',
    thumbnailUrl: 'https://img.youtube.com/vi/yW63vWbQdD8/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.selfConfidence,
  ),
  SupportVideo(
    id: 'vid_013',
    title: 'Développer la résilience',
    titleAr: 'تطوير المرونة النفسية',
    description: 'Apprendre à rebondir après les épreuves de la vie.',
    descriptionAr: 'تعلم كيفية النهوض مجدداً بعد صعوبات الحياة.',
    url: 'https://www.youtube.com/watch?v=NXj6c039PUI',
    thumbnailUrl: 'https://img.youtube.com/vi/NXj6c039PUI/0.jpg',
    category: VideoCategory.support,
    axis: AssessmentAxis.stressAnxiety,
  ),
];
