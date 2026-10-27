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
            // Main Brand Logo
            const AppLogo(size: 160)
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(delay: 200.ms)
                .then()
                .shimmer(duration: 2.seconds),

            const SizedBox(height: 48),

            // Breathing indicator (subtle)
            Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.softOlive.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  duration: 2.seconds,
                  begin: const Offset(1, 1),
                  end: const Offset(2, 2),
                )
                .fadeIn(duration: 2.seconds),
          ],
        ),
      ),
    );
  }
}
