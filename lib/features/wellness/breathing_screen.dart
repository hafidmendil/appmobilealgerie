import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/localization/l10n_extension.dart';
import '../../core/theme/tokens/app_colors.dart';
import '../../core/theme/tokens/app_spacing.dart';
import '../../core/widgets/sind_components.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isSoundEnabled = true;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // 4s inhale, 4s hold, 4s exhale
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _controller.stop();
      } else {
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrow_left, color: AppColors.deepOlive),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.l10n.breath_title,
          style: const TextStyle(
            color: AppColors.deepOlive,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isSoundEnabled ? LucideIcons.volume_2 : LucideIcons.volume_x,
              color: AppColors.deepOlive,
            ),
            onPressed: () => setState(() => _isSoundEnabled = !_isSoundEnabled),
            tooltip: context.l10n.breath_sound_tooltip,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Ambient calming gradient background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double progress = 0.0;
                double elapsed = _controller.value * 12;
                if (elapsed < 4.0) {
                  progress = elapsed / 4.0;
                } else if (elapsed < 8.0) {
                  progress = 1.0;
                } else {
                  progress = (12.0 - elapsed) / 4.0;
                }
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.2 + progress * 0.3,
                      colors: [
                        AppColors.softBlue.withOpacity(0.3 + progress * 0.4),
                        AppColors.warmBeige,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Calming background particles floating upwards
          ...List.generate(10, (index) {
            final delay = (index * 1.2).seconds;
            return Positioned(
              bottom: -20,
              left: (index * 40 + 20).toDouble(),
              child:
                  Container(
                        width: (index % 3 + 1) * 8.0,
                        height: (index % 3 + 1) * 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.oliveGreen.withOpacity(0.12),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .moveY(
                        begin: 0,
                        end: -600,
                        duration: 8.seconds,
                        delay: delay,
                        curve: Curves.easeInOut,
                      )
                      .fadeOut(duration: 8.seconds),
            );
          }),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Breathing Visualizer Box
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      double elapsed = _controller.value * 12;
                      String phaseTitle = '';
                      String phaseTitleDarja = '';
                      double phaseProgress = 0.0;
                      int secondsRemaining = 0;
                      Color circleColor = AppColors.oliveGreen;

                      if (elapsed < 4.0) {
                        // Inhale
                        phaseTitle = l10n.breathe_in;
                        phaseTitleDarja = context.l10n.breath_in_sub;
                        phaseProgress = elapsed / 4.0;
                        secondsRemaining = (4.0 - elapsed).ceil();
                        circleColor = AppColors.oliveGreen;
                      } else if (elapsed < 8.0) {
                        // Hold
                        phaseTitle = l10n.breathe_hold;
                        phaseTitleDarja = context.l10n.breath_hold_sub;
                        phaseProgress = 1.0;
                        secondsRemaining = (8.0 - elapsed).ceil();
                        circleColor = AppColors.deepOlive;
                      } else {
                        // Exhale
                        phaseTitle = l10n.breathe_out;
                        phaseTitleDarja = context.l10n.breath_out_sub;
                        phaseProgress = (12.0 - elapsed) / 4.0;
                        secondsRemaining = (12.0 - elapsed).ceil();
                        circleColor = const Color(0xFF6B8A7A);
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Custom Breathing Circle
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Calming outer aura glow
                              Container(
                                    width: 280,
                                    height: 280,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: circleColor.withOpacity(
                                        0.06 + (phaseProgress * 0.1),
                                      ),
                                    ),
                                  )
                                  .animate(target: phaseProgress)
                                  .scale(
                                    begin: const Offset(0.9, 0.9),
                                    end: const Offset(1.1, 1.1),
                                    curve: Curves.easeInOut,
                                  ),

                              // Outer circular progress boundary
                              SizedBox(
                                width: 230,
                                height: 230,
                                child: CircularProgressIndicator(
                                  value: _controller.value,
                                  strokeWidth: 4,
                                  backgroundColor: AppColors.oliveGreen
                                      .withOpacity(0.1),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    circleColor.withOpacity(0.4),
                                  ),
                                ),
                              ),

                              // Filled and Animated Breathing Circle
                              CustomPaint(
                                size: const Size(200, 200),
                                painter: _BreathingCirclePainter(
                                  progress: phaseProgress,
                                  color: circleColor,
                                  isHolding: elapsed >= 4.0 && elapsed < 8.0,
                                ),
                              ),

                              // Inside Circle Text (Timer & Instruction)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, animation) =>
                                        ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                    child: Text(
                                      '$secondsRemaining',
                                      key: ValueKey(secondsRemaining),
                                      style: const TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black26,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.breath_sec,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.xxl),

                          // Phase title
                          Text(
                            phaseTitle,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: AppColors.deepOlive,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                          ),

                          const SizedBox(height: AppSpacing.xs),

                          // Secondary title in Darja or French
                          Text(
                            phaseTitleDarja,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.oliveGreen.withOpacity(0.8),
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      );
                    },
                  ),

                  if (_isSoundEnabled) ...[
                    const SizedBox(height: AppSpacing.lg),
                    // Sound waves animation indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) =>
                            Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  width: 4,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: AppColors.oliveGreen.withOpacity(
                                      0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                )
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .scaleY(
                                  begin: 0.5,
                                  end: 2.0,
                                  duration: (600 + (index * 150)).milliseconds,
                                  curve: Curves.easeInOut,
                                ),
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Interactive Play/Pause & Finish Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Row(
                      children: [
                        // Pause / Play Button
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              side: const BorderSide(
                                color: AppColors.oliveGreen,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _togglePlayPause,
                            child: Icon(
                              _isPaused ? LucideIcons.play : LucideIcons.pause,
                              color: AppColors.oliveGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        // Finish Button
                        Expanded(
                          flex: 2,
                          child: SindPrimaryButton(
                            label: l10n.finish,
                            onPressed: () => context.pop(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreathingCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isHolding;

  _BreathingCirclePainter({
    required this.progress,
    required this.color,
    required this.isHolding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Background circle container
    final bgPaint = Paint()
      ..color = AppColors.oliveGreen.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius, bgPaint);

    // Inner breathing circle which grows/shrinks
    final double currentRadius = 50.0 + (maxRadius - 50.0) * progress;

    // Create a beautiful glowing radial gradient for the circle
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        color.withOpacity(isHolding ? 0.95 : 0.8),
        color.withOpacity(0.6),
      ],
    );

    final fillPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: currentRadius),
      )
      ..style = PaintingStyle.fill;

    // Drop shadow under the circle
    final shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: currentRadius));
    canvas.drawShadow(shadowPath, Colors.black38, 4.0, true);

    // Draw the main circle
    canvas.drawCircle(center, currentRadius, fillPaint);

    // Subtle breathing border ring
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3 + (progress * 0.4))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, currentRadius - 3, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _BreathingCirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isHolding != isHolding;
  }
}
