import '../adaptive_assessment/domain/models/assessment_axis.dart';

enum VideoCategory { support, educational, tutorial, meditation }

class SupportVideo {
  final String id;
  final String title;
  final String description;
  final String url;
  final String thumbnailUrl;
  final VideoCategory category;
  final AssessmentAxis axis;

  const SupportVideo({
    required this.id,
    required this.title,
    required this.description,
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
    description: 'Une explication simple sur les mécanismes du stress et de l\'anxiété.',
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', // Placeholder
    thumbnailUrl: 'https://img.youtube.com/vi/dQw4w9WgXcQ/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.stressAnxiety,
  ),
  SupportVideo(
    id: 'vid_002',
    title: 'Technique de Respiration 4-7-8',
    description: 'Tutoriel guidé pour calmer le système nerveux en quelques minutes.',
    url: 'https://www.youtube.com/watch?v=17C_7a8I3-0',
    thumbnailUrl: 'https://img.youtube.com/vi/17C_7a8I3-0/0.jpg',
    category: VideoCategory.tutorial,
    axis: AssessmentAxis.stressAnxiety,
  ),
  SupportVideo(
    id: 'vid_003',
    title: 'Gérer ses émotions fortes',
    description: 'Conseils pratiques pour ne pas se laisser submerger par ses sentiments.',
    url: 'https://www.youtube.com/watch?v=l7TONauJGfc',
    thumbnailUrl: 'https://img.youtube.com/vi/l7TONauJGfc/0.jpg',
    category: VideoCategory.support,
    axis: AssessmentAxis.emotions,
  ),
  SupportVideo(
    id: 'vid_004',
    title: 'L\'importance du sommeil',
    description: 'Pourquoi le repos est votre meilleur allié pour la santé mentale.',
    url: 'https://www.youtube.com/watch?v=xxx',
    thumbnailUrl: 'https://img.youtube.com/vi/xxx/0.jpg',
    category: VideoCategory.educational,
    axis: AssessmentAxis.sleepEnergy,
  ),
];
