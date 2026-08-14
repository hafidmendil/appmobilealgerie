import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/features/onboarding/welcome_screen.dart';
import 'package:projetmascara/features/onboarding/splash_screen.dart';
import 'package:projetmascara/features/onboarding/guest_introduction_screen.dart';
import 'package:projetmascara/features/auth/screens/login_screen.dart';
import 'package:projetmascara/features/auth/screens/register_screen.dart';
import 'package:projetmascara/features/dashboard/user_dashboard.dart';
import 'package:projetmascara/features/dashboard/profile_page.dart';
import 'package:projetmascara/features/dashboard/settings_page.dart';
import 'package:projetmascara/features/dashboard/psychologist_dashboard.dart';
import 'package:projetmascara/features/admin/screens/admin_dashboard_screen.dart';
import 'package:projetmascara/features/admin/screens/professional_management_screen.dart';
import 'package:projetmascara/features/admin/screens/user_management_screen.dart';
import 'package:projetmascara/features/admin/screens/security_logs_screen.dart';
import 'package:projetmascara/features/admin/screens/admin_settings_screen.dart';
import 'package:projetmascara/features/dashboard/guest_home_screen.dart';
import 'package:projetmascara/features/dashboard/wilaya_selection_screen.dart';
import 'package:projetmascara/features/dashboard/privacy_screen.dart';
import 'package:projetmascara/features/resources/screens/resources_screen.dart';
import 'package:projetmascara/features/assessment/assessment_screen.dart';
import 'package:projetmascara/features/wellness/breathing_screen.dart';
import 'package:projetmascara/features/wellness/spiritual_screen.dart';
import 'package:projetmascara/features/wellness/plan_7_days_screen.dart';
import 'package:projetmascara/features/wellness/confidence_screen.dart';
import 'package:projetmascara/features/wellness/safety_screen.dart';

import 'package:projetmascara/features/results/results_screen.dart';
import 'package:projetmascara/features/results/history_screen.dart';
import 'package:projetmascara/features/results/clinical_report_screen.dart';
import 'package:projetmascara/features/professional/screens/access_requests_screen.dart';
import 'package:projetmascara/features/professional/screens/patients_screen.dart';
import 'package:projetmascara/features/professional/screens/patient_detail_screen.dart';
import 'package:projetmascara/features/reflection/reflection_screen.dart';
import 'package:projetmascara/features/progress/progress_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final user = authState.value;
      final publicRoutes = [
        '/splash',
        '/',
        '/login',
        '/register',
        '/guest',
        '/assessment',
        '/privacy',
        '/resources',
        '/results',
        '/report',
        '/progress',
        '/reflection'
      ];
      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      if (user == null) {
        if (isPublicRoute) return null;
        if (state.matchedLocation == '/splash') return null;
        return '/';
      }

      if (isPublicRoute && state.matchedLocation != '/guest' && state.matchedLocation != '/results' && state.matchedLocation != '/report' && state.matchedLocation != '/splash') {
        switch (user.role) {
          case UserRole.admin:
            return '/admin';
          case UserRole.psychologist:
            return '/psychologist';
          default:
            return '/user';
        }
      }

      // Role based guards
      if (state.matchedLocation.startsWith('/admin') && user.role != UserRole.admin) {
        return '/user';
      }
      if (state.matchedLocation.startsWith('/psychologist')) {
        if (user.role != UserRole.psychologist) return '/user';
        if (user.status != 'approved') return '/psychologist/pending';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/guest',
        builder: (context, state) => const GuestHomeScreen(),
      ),
      GoRoute(
        path: '/guest/intro',
        builder: (context, state) => const GuestIntroductionScreen(),
      ),
      GoRoute(
        path: '/assessment',
        builder: (context, state) => const AssessmentScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/breathing',
        builder: (context, state) => const BreathingScreen(),
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
        path: '/report',
        builder: (context, state) => const ClinicalReportScreen(),
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
        path: '/reflection',
        builder: (context, state) => const ReflectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
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
            builder: (context, state) => const Scaffold(
              body: Center(child: Text("Votre compte est en attente de validation par un administrateur.")),
            ),
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
                builder: (context, state) => PatientDetailScreen(
                  patientId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
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
        ],
      ),
    ],
  );
});
