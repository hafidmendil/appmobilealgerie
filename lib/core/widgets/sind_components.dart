import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/tokens/app_colors.dart';
import '../theme/tokens/app_spacing.dart';
import '../theme/tokens/app_radii.dart';
import '../theme/tokens/app_shadows.dart';

class SindPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const SindPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(label),
              ],
            ),
    ).animate(target: onPressed == null ? 0 : 1).fadeIn().scale();
  }
}

class SindSecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SindSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(label),
        ],
      ),
    );
  }
}

class SindGlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const SindGlassCard({
    super.key,
    required this.child,
    this.blur = 12,
    this.opacity = 0.9, // Increased default opacity
    this.padding,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = color ?? (isDark ? AppColors.darkCard : Colors.white);

    Widget card = ClipRRect(
      borderRadius: AppRadii.largeRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: baseColor.withOpacity(opacity),
            borderRadius: AppRadii.largeRadius,
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.25) : AppColors.textMuted.withOpacity(0.4), // Stronger borders
              width: 1.5,
            ),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            child: child,
          ),
        ),
      ),
    );

    if (margin != null) {
      card = Padding(padding: margin!, child: card);
    }

    return card;
  }
}

class SindProgressBar extends StatelessWidget {
  final double value;
  final String? label;

  const SindProgressBar({
    super.key,
    required this.value,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Container(
          height: 12, // Slightly thicker
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.15) : AppColors.textMuted.withOpacity(0.25), // Better track visibility
            borderRadius: AppRadii.pillRadius,
          ),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.softOlive, AppColors.oliveGreen],
                ),
                borderRadius: AppRadii.pillRadius,
              ),
            ),
          ),
        ).animate().shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.5)),
      ],
    );
  }
}

class SindAnswerOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSafetyTrigger;

  const SindAnswerOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSafetyTrigger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color getBgColor() {
      if (!isSelected) return isDark ? AppColors.darkCard : Colors.white;
      if (isSafetyTrigger) return AppColors.danger.withOpacity(0.2); // Increased opacity
      return AppColors.oliveGreen.withOpacity(0.15); // Increased opacity
    }

    Color getBorderColor() {
      if (!isSelected) return isDark ? Colors.white.withOpacity(0.15) : AppColors.textMuted.withOpacity(0.2); // Visible unselected border
      if (isSafetyTrigger) return AppColors.danger;
      return AppColors.oliveGreen;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: getBgColor(),
          borderRadius: AppRadii.largeRadius,
          border: Border.all(color: getBorderColor(), width: 2),
          boxShadow: isSelected ? [] : AppShadows.soft,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected 
                    ? (isSafetyTrigger ? AppColors.danger : (isDark ? AppColors.darkPrimary : AppColors.deepOlive))
                    : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: isSafetyTrigger ? AppColors.danger : AppColors.oliveGreen,
              ).animate().scale(),
          ],
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scale(begin: const Offset(1, 1), end: const Offset(0.98, 0.98));
  }
}
