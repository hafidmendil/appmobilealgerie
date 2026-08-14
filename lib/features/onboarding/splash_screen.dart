import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_typography.dart';
import '../../core/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(2.5.seconds);
    if (mounted) {
      context.go('/'); // Welcome/Onboarding
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Organic Shape / Logo
            const AppLogo(size: 120)
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(delay: 200.ms)
                .then()
                .shimmer(duration: 2.seconds),
            
            const SizedBox(height: 24),
            
            // App Name
            Text(
              "NeuroSync",
              style: AppTypography.getTextTheme(context, Theme.of(context).brightness).displayLarge?.copyWith(
                color: AppColors.oliveGreen,
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
            
            const SizedBox(height: 8),
            
            // Arabic Sub-name
            Text(
              "سند",
              style: AppTypography.arabicStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.deepOlive,
              ),
            ).animate().fadeIn(delay: 1000.ms).scale(),
            
            const SizedBox(height: 48),
            
            // Breathing indicator (subtle)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.softOlive.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(duration: 2.seconds, begin: const Offset(1, 1), end: const Offset(2, 2))
             .fadeIn(duration: 2.seconds),
          ],
        ),
      ),
    );
  }
}
