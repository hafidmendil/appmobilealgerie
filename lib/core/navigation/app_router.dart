import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/onboarding/welcome_screen.dart';
import 'package:projetmascara/features/onboarding/splash_screen.dart';
import 'package:projetmascara/features/onboarding/guest_introduction_screen.dart';
import 'package:projetmascara/features/onboarding/situation_selection_page.dart';
import 'package:projetmascara/features/auth/screens/login_screen.dart';
import 'package:projetmascara/features/auth/screens/register_screen.dart';
import 'package:projetmascara/features/auth/screens/offline_admin_setup_screen.dart';
import 'package:projetmascara/features/dashboard/user_dashboard.dart';
import 'package:projetmascara/features/dashboard/profile_page.dart';
import 'package:projetmascara/features/dashboard/settings_page.dart';
import 'package:projetmascara/features/dashboard/psychologist_dashboard.dart';
import 'package:projetmascara/features/admin/screens/admin_dashboard_screen.dart';
import 'package:projetmascara/features/admin/screens/professional_management_screen.dart';
import 'package:projetmascara/features/admin/screens/user_management_screen.dart';
import 'package:projetmascara/features/admin/screens/security_logs_screen.dart';
import 'package:projetmascara/features/admin/screens/admin_settings_screen.dart';
import 'package:projetmascara/features/admin/screens/institutional_readiness_screen.dart';
import 'package:projetmascara/features/dashboard/guest_home_screen.dart';
import 'package:projetmascara/features/dashboard/wilaya_selection_screen.dart';
import 'package:projetmascara/features/dashboard/privacy_screen.dart';
import 'package:projetmascara/features/resources/screens/resources_screen.dart';
import 'package:projetmascara/features/adaptive_assessment/presentation/pages/assessment_page.dart';
import 'package:projetmascara/features/adaptive_assessment/presentation/pages/results_page.dart';
import 'package:projetmascara/features/wellness/breathing_screen.dart';
import 'package:projetmascara/features/wellness/spiritual_screen.dart';
import 'package:projetmascara/features/wellness/plan_7_days_screen.dart';
import 'package:projetmascara/features/wellness/confidence_screen.dart';
import 'package:projetmascara/features/wellness/safety_screen.dart';
import 'package:projetmascara/features/professional/screens/access_requests_screen.dart';
import 'package:projetmascara/features/professional/screens/patients_screen.dart';
import 'package:projetmascara/features/professional/screens/patient_detail_screen.dart';
import 'package:projetmascara/features/reflection/reflection_screen.dart';
import 'package:projetmascara/features/progress/progress_screen.dart';
import 'package:projetmascara/features/progress/analytics_screen.dart';
import 'package:projetmascara/features/health/screens/health_knowledge_page.dart';
import 'package:projetmascara/features/health/screens/health_article_page.dart';
import 'package:projetmascara/features/health/screens/health_quiz_page.dart';
import 'package:projetmascara/features/admin/screens/health_admin_screen.dart';
import 'package:projetmascara/features/admin/screens/team_admin_screen.dart';
import 'package:projetmascara/features/admin/screens/quran_admin_screen.dart';
import 'package:projetmascara/features/admin/screens/hadith_admin_screen.dart';
import 'package:projetmascara/features/admin/screens/assessment_admin_screen.dart';
import 'package:projetmascara/features/admin/screens/awareness_admin_screen.dart';
import 'package:projetmascara/features/admin/screens/contact_list_screen.dart';
import 'package:projetmascara/features/team/screens/project_team_page.dart';
import 'package:projetmascara/features/professional/screens/professional_search_page.dart';
import 'package:projetmascara/features/professional/screens/professional_profile_page.dart';
import 'package:projetmascara/features/professional/screens/session_request_page.dart';
import 'package:projetmascara/features/professional/screens/my_appointments_page.dart';
import 'package:projetmascara/features/messaging/my_communications_page.dart';
import 'package:projetmascara/features/professional/models/professional_model.dart';
import 'package:projetmascara/features/dashboard/widgets/psychologist_pending_screen.dart';
import 'package:projetmascara/features/dashboard/history_page.dart';
import 'package:projetmascara/core/services/logger_service.dart';
import 'package:projetmascara/features/protection/presentation/pages/protection_home_page.dart';
import 'package:projetmascara/features/protection/presentation/pages/emergency_page.dart';
import 'package:projetmascara/features/protection/presentation/pages/privacy_page.dart';
import 'package:projetmascara/features/protection/presentation/pages/report_page.dart';
import 'package:projetmascara/features/protection/presentation/pages/scenarios_page.dart';
import 'package:projetmascara/features/protection/presentation/pages/violence_understanding_flow_page.dart';
import 'package:projetmascara/features/protection/presentation/pages/local_tools_pages.dart';
import 'package:projetmascara/features/protection/presentation/pages/voice_reflection_page.dart';
import 'package:projetmascara/features/protection/domain/models/protection_models.dart';
import 'package:projetmascara/features/legal/presentation/pages/legal_hub_page.dart';
import 'package:projetmascara/features/legal/presentation/pages/legal_questionnaire_page.dart';
import 'package:projetmascara/features/legal/presentation/pages/legal_result_page.dart';
import 'package:projetmascara/features/legal/presentation/pages/consent_center_page.dart';
import 'package:projetmascara/features/legal/presentation/pages/report_builder_page.dart';
import 'package:projetmascara/features/legal/presentation/pages/legal_details_page.dart';
import 'package:projetmascara/features/dashboard/about_page.dart';
import 'package:projetmascara/features/legal/presentation/pages/admin/legal_admin_screen.dart';
import 'package:projetmascara/features/orientation/local_orientation_page.dart';
import 'package:projetmascara/features/orientation/partner_network_pages.dart';
import 'package:projetmascara/features/orientation/local_referrals_page.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (previous, next) {
      if (previous?.value != next.value) {
        logger.i('RouterNotifier: Auth state changed, notifying listeners');
        notifyListeners();
      }
    });
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final user = authState.value;
      final location = state.matchedLocation;

      logger.d(
        'GoRouter redirect: location=$location, user=${user?.email}, role=${user?.role}, status=${user?.status}',
      );

      final publicRoutes = [
        '/splash',
        '/',
        '/login',
        '/register',
        '/setup-admin',
        '/guest',
        '/guest/intro',
        '/orientation',
        '/orientation/network',
        '/orientation/my-requests',
        '/partner/account',
        '/assessment',
        '/privacy',
        '/resources',
        '/results',
        '/progress',
        '/analytics',
        '/reflection',
        '/health',
        '/health/article',
        '/health/quiz',
        '/team',
        '/professional-search',
        '/professional-profile',
        '/protection',
        '/protection/flow',
        '/protection/emergency',
        '/protection/report',
        '/protection/result',
        '/protection/privacy',
        '/protection/resources',
        '/protection/breathing',
        '/protection/scenarios',
        '/protection/reports',
        '/protection/safety-plan',
        '/protection/voice',
        '/legal',
        '/legal/questionnaire',
        '/legal/result',
        '/legal/consent',
        '/legal/report-builder',
        '/history',
        '/account-disabled',
      ];
      final isPublicRoute =
          publicRoutes.contains(location) ||
          location.startsWith('/health/article/') ||
          location.startsWith('/health/quiz/');

      // 1. Not logged in
      if (user == null) {
        if (isPublicRoute) return null;
        logger.i('GoRouter redirect: User not logged in, redirecting to /');
        return '/'; // Redirect to Welcome
      }

      // A persisted session must never bypass a suspension or a pending state.
      // The dedicated page lets the person sign out without exposing features.
      if (!_hasActiveAccount(user)) {
        return location == '/account-disabled' ? null : '/account-disabled';
      }
      if (location == '/account-disabled') return _homeForUser(user);

      // A temporary password issued by an administrator grants access only to
      // the password-change screen until the account holder chooses a new one.
      if (user.mustChangePassword && location != '/profile') {
        return '/profile';
      }

      // Shared wellbeing, assessment, directory and profile routes are
      // available to every authenticated role. Management areas remain
      // restricted to their owning role.
      if (location.startsWith('/admin') && user.role != UserRole.admin) {
        logger.w('GoRouter redirect: Non-admin attempted to access $location');
        return _homeForUser(user);
      }
      if (location.startsWith('/psychologist') &&
          user.role != UserRole.psychologist) {
        logger.w(
          'GoRouter redirect: Non-psychologist attempted to access $location',
        );
        return _homeForUser(user);
      }
      if (location == '/user' && user.role != UserRole.user) {
        return _homeForUser(user);
      }
      if (location == '/session-request' && user.role != UserRole.user) {
        return _homeForUser(user);
      }

      // 2. Logged in
      final authRoutes = [
        '/',
        '/login',
        '/register',
        '/setup-admin',
        '/guest',
        '/guest/intro',
      ];
      if (authRoutes.contains(location)) {
        logger.i(
          'GoRouter redirect: Logged in user on auth route, redirecting to dashboard',
        );
        switch (user.role) {
          case UserRole.admin:
            return '/admin';
          case UserRole.psychologist:
            return (user.status == 'approved' || user.status == 'active')
                ? '/psychologist'
                : '/psychologist/pending';
          case UserRole.user:
            return '/user';
          default:
            return '/user';
        }
      }

      // 3. Status checks
      if (user.role == UserRole.psychologist &&
          user.status != 'approved' &&
          user.status != 'active' &&
          location != '/psychologist/pending') {
        logger.i(
          'GoRouter redirect: Psychologist not approved, redirecting to pending',
        );
        return '/psychologist/pending';
      }

      return null;
    },
    errorBuilder: (context, state) => _RouteErrorPage(error: state.error),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
      GoRoute(
        path: '/guest',
        builder: (context, state) => const GuestHomeScreen(),
      ),
      GoRoute(
        path: '/guest/intro',
        builder: (context, state) => const GuestIntroductionScreen(),
      ),
      GoRoute(
        path: '/orientation',
        builder: (context, state) => const SituationSelectionPage(),
      ),
      GoRoute(
        path: '/orientation/network',
        builder: (context, state) => const LocalOrientationPage(),
      ),
      GoRoute(
        path: '/orientation/my-requests',
        builder: (context, state) => const LocalReferralsPage(),
      ),
      GoRoute(
        path: '/partner/account',
        builder: (context, state) => const PartnerAccountPage(),
      ),
      GoRoute(
        path: '/assessment',
        builder: (context, state) => AssessmentPage(
          initialConcern: state.uri.queryParameters['concern'] == 'anger'
              ? 3
              : null,
        ),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsPage(),
      ),
      GoRoute(
        path: '/breathing',
        builder: (context, state) => const BreathingScreen(),
      ),
      GoRoute(
        path: '/protection',
        builder: (context, state) => const ProtectionHomePage(),
      ),
      GoRoute(
        path: '/protection/flow',
        builder: (context, state) => const ViolenceUnderstandingFlowPage(),
      ),
      GoRoute(
        path: '/protection/emergency',
        builder: (context, state) => const EmergencyPage(),
      ),
      GoRoute(
        path: '/protection/privacy',
        builder: (context, state) => const ProtectionPrivacyPage(),
      ),
      GoRoute(
        path: '/protection/report',
        builder: (context, state) => const ProtectionReportPage(),
      ),
      GoRoute(
        path: '/protection/result',
        builder: (context, state) {
          final assessment = state.extra;
          if (assessment is RiskAssessment) {
            return ProtectionResultPage(assessment: assessment);
          }
          return const _MissingRouteDataPage();
        },
      ),
      GoRoute(
        path: '/protection/resources',
        builder: (context, state) => const ResourcesScreen(),
      ),
      GoRoute(
        path: '/protection/breathing',
        builder: (context, state) => const BreathingScreen(),
      ),
      GoRoute(
        path: '/protection/scenarios',
        builder: (context, state) => const ProtectionScenariosPage(),
      ),
      GoRoute(
        path: '/protection/reports',
        builder: (context, state) => const LocalReportsPage(),
      ),
      GoRoute(
        path: '/protection/safety-plan',
        builder: (context, state) => const SafetyPlanPage(),
      ),
      GoRoute(
        path: '/protection/voice',
        builder: (context, state) => const VoiceAssessmentPage(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryPage(),
      ),
      GoRoute(
        path: '/spiritual',
        builder: (context, state) => const SpiritualScreen(),
      ),
      GoRoute(
        path: '/plan7days',
        builder: (context, state) => const Plan7DaysScreen(),
      ),
      GoRoute(
        path: '/confidence',
        builder: (context, state) => const ConfidenceScreen(),
      ),
      GoRoute(
        path: '/safety',
        builder: (context, state) => const SafetyScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/resources',
        builder: (context, state) => const ResourcesScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/reflection',
        builder: (context, state) => const ReflectionScreen(),
      ),
      GoRoute(
        path: '/health',
        builder: (context, state) => const HealthKnowledgePage(),
        routes: [
          GoRoute(
            path: 'article/:id',
            builder: (context, state) =>
                HealthArticlePage(articleId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'quiz/:id',
            builder: (context, state) =>
                HealthQuizPage(quizId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/team',
        builder: (context, state) => const ProjectTeamPage(),
      ),
      GoRoute(
        path: '/professional-search',
        builder: (context, state) => const ProfessionalSearchPage(),
      ),
      GoRoute(
        path: '/communications',
        builder: (context, state) => const MyCommunicationsPage(),
      ),
      GoRoute(
        path: '/my-appointments',
        builder: (context, state) => const MyAppointmentsPage(),
      ),
      GoRoute(
        path: '/professional-profile',
        builder: (context, state) {
          final professional = state.extra;
          if (professional is ProfessionalModel) {
            return ProfessionalProfilePage(professional: professional);
          }
          return const _MissingRouteDataPage();
        },
      ),
      GoRoute(
        path: '/session-request',
        builder: (context, state) {
          final professional = state.extra;
          if (professional is ProfessionalModel) {
            return SessionRequestPage(professional: professional);
          }
          return const _MissingRouteDataPage();
        },
      ),
      GoRoute(
        path: '/account-disabled',
        builder: (context, state) => const _AccountDisabledPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/setup-admin',
        builder: (context, state) => const OfflineAdminSetupScreen(),
      ),
      GoRoute(
        path: '/user',
        builder: (context, state) => const UserDashboard(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/wilaya',
        builder: (context, state) => const WilayaSelectionScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/psychologist',
        builder: (context, state) => const PsychologistDashboard(),
        routes: [
          GoRoute(
            path: 'pending',
            builder: (context, state) => const PsychologistPendingScreen(),
          ),
          GoRoute(
            path: 'requests',
            builder: (context, state) => const AccessRequestsScreen(),
          ),
          GoRoute(
            path: 'patients',
            builder: (context, state) => const PatientsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    PatientDetailScreen(patientId: state.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/legal',
        builder: (context, state) => const LegalHubPage(),
      ),
      GoRoute(
        path: '/legal/details',
        builder: (context, state) => const LegalDetailsPage(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: '/legal/questionnaire',
        builder: (context, state) => const LegalQuestionnairePage(),
      ),
      GoRoute(
        path: '/legal/result',
        builder: (context, state) => const LegalResultPage(),
      ),
      GoRoute(
        path: '/legal/consent',
        builder: (context, state) => const ConsentCenterPage(),
      ),
      GoRoute(
        path: '/legal/report-builder',
        builder: (context, state) => const ReportBuilderPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'professionals',
            builder: (context, state) => const ProfessionalManagementScreen(),
          ),
          GoRoute(
            path: 'users',
            builder: (context, state) => const UserManagementScreen(),
          ),
          GoRoute(
            path: 'security-logs',
            builder: (context, state) => const SecurityLogsScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const AdminSettingsScreen(),
          ),
          GoRoute(
            path: 'institutional-readiness',
            builder: (context, state) => const InstitutionalReadinessScreen(),
          ),
          GoRoute(
            path: 'health',
            builder: (context, state) => const HealthAdminScreen(),
          ),
          GoRoute(
            path: 'team',
            builder: (context, state) => const TeamAdminScreen(),
          ),
          GoRoute(
            path: 'quran',
            builder: (context, state) => const QuranAdminScreen(),
          ),
          GoRoute(
            path: 'hadith',
            builder: (context, state) => const HadithAdminScreen(),
          ),
          GoRoute(
            path: 'assessment',
            builder: (context, state) => const AssessmentAdminScreen(),
          ),
          GoRoute(
            path: 'awareness',
            builder: (context, state) => const AwarenessAdminScreen(),
          ),
          GoRoute(
            path: 'partners',
            builder: (context, state) => const PartnerNetworkManagementPage(),
          ),
          GoRoute(
            path: 'chat',
            builder: (context, state) => const ContactListScreen(),
          ),
          GoRoute(
            path: 'legal',
            builder: (context, state) => const LegalAdminScreen(),
          ),
        ],
      ),
    ],
  );
});

String _homeForUser(UserModel user) {
  switch (user.role) {
    case UserRole.admin:
      return '/admin';
    case UserRole.psychologist:
      return (user.status == 'approved' || user.status == 'active')
          ? '/psychologist'
          : '/psychologist/pending';
    case UserRole.user:
    case UserRole.guest:
      return '/user';
  }
}

bool _hasActiveAccount(UserModel user) {
  switch (user.role) {
    case UserRole.user:
    case UserRole.admin:
      return user.status == 'active';
    case UserRole.psychologist:
      return user.status == 'active' ||
          user.status == 'approved' ||
          user.status == 'pending';
    case UserRole.guest:
      return false;
  }
}

class _MissingRouteDataPage extends StatelessWidget {
  const _MissingRouteDataPage();

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'التنقل غير متاح' : 'Navigation indisponible'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.link_off_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'لا يحتوي هذا الرابط على المعلومات اللازمة. ابدأ المسار من البحث.'
                    : 'Ce lien ne contient pas les informations nécessaires. Reprenez le parcours depuis la recherche.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/professional-search'),
                child: Text(
                  isArabic ? 'عرض المختصين' : 'Voir les professionnels',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteErrorPage extends StatelessWidget {
  final Object? error;

  const _RouteErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الصفحة غير موجودة' : 'Page introuvable'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off_outlined, size: 48),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'هذه الصفحة غير موجودة أو لم تعد متاحة.'
                    : 'Cette page n’existe pas ou n’est plus disponible.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: Text(
                  isArabic ? 'العودة إلى البداية' : 'Retour à l’accueil',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountDisabledPage extends ConsumerWidget {
  const _AccountDisabledPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الحساب غير متاح' : 'Compte indisponible'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 16),
              Text(
                isArabic
                    ? 'حسابك غير نشط. تواصل مع الإدارة إذا كنت تعتقد أن ذلك خطأ.'
                    : 'Votre compte n’est pas actif. Contactez l’administration si vous pensez qu’il s’agit d’une erreur.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) context.go('/');
                },
                child: Text(isArabic ? 'تسجيل الخروج' : 'Se déconnecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
