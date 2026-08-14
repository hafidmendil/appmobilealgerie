import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/widgets/sind_components.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 12.seconds, // 4-4-4 cycle
    );

    _controller.repeat();
  }

  String _getPhaseText(AppLocalizations l10n) {
    if (_controller.value < 0.33) return l10n.breathe_in;
    if (_controller.value < 0.66) return l10n.breathe_hold;
    return l10n.breathe_out;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.softBlue,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.action_calm),
      ),
      body: Stack(
        children: [
          // Background subtle animation
          Positioned.fill(
            child: CustomPaint(
              painter: _OrganicBackgroundPainter(animationValue: _controller.value),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Breathing Circle
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double scale;
                    if (_controller.value < 0.33) {
                      scale = 1.0 + (_controller.value / 0.33) * 0.5;
                    } else if (_controller.value < 0.66) {
                      scale = 1.5;
                    } else {
                      scale = 1.5 - ((_controller.value - 0.66) / 0.34) * 0.5;
                    }

                    return Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.oliveGreen.withOpacity(0.2),
                        border: Border.all(color: AppColors.oliveGreen.withOpacity(0.4), width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 160 * scale,
                          height: 160 * scale,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.oliveGreen,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final phaseText = _getPhaseText(l10n);
                    return Text(
                      phaseText,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.deepOlive,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(key: ValueKey(phaseText)).fadeIn().scale();
                  },
                ),
                
                const SizedBox(height: AppSpacing.xxl),
                
                Text(
                  l10n.breathing_instruction,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ).animate().fadeIn(delay: 1.seconds),
              ],
            ),
          ),
          
          Positioned(
            bottom: AppSpacing.xxl,
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            child: SindPrimaryButton(
              label: l10n.finish,
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrganicBackgroundPainter extends CustomPainter {
  final double animationValue;

  _OrganicBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.softOlive.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    double offset = animationValue * 2 * 3.14159;
    
    path.moveTo(0, size.height * 0.8);
    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.8 + 20 * (animationValue < 0.5 ? animationValue : 1 - animationValue) * (i / size.width),
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
