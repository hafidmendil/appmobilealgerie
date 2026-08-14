# Implementation Plan - UI Visibility and Contrast Improvements

This plan aims to resolve visibility issues in both light and dark modes, with a focus on dark mode contrast as reported by the user.

## Proposed Changes

### Theme & Typography
Fix the reactive theme building to ensure correct text colors are applied based on the theme's brightness.

#### [app_typography.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_typography.dart)
- Update `getTextTheme` to accept an explicit `Brightness` parameter.
- Remove dependence on `Theme.of(context)` within `getTextTheme`.
- Ensure `secondaryTextColor` has sufficient contrast in dark mode.

#### [app_theme.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/app_theme.dart)
- Update calls to `AppTypography.getTextTheme` to pass the appropriate `Brightness`.
- Explicitly define `inputDecorationTheme`, `outlinedButtonTheme`, and `textButtonTheme` for `darkTheme` to ensure high contrast for form fields and buttons.
- Adjust `inputDecorationTheme` colors for dark mode.

### Components
Update custom components to use theme-aware colors instead of hardcoded values.

#### [sind_components.dart](file:///home/hafid/Bureau/projetmascara/lib/core/widgets/sind_components.dart)
- **`SindAnswerOption`**: Fix text color to use `theme.textTheme.bodyLarge?.color` or a theme-aware color instead of hardcoding `AppColors.textPrimary`.
- **`SindGlassCard`**: Ensure it respects the theme's text color.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure no regressions.

### Manual Verification
- Render Compose Previews (if available) or use `take_screenshot` to verify contrast on multiple screens (Login, Assessment, Home).
- Inspect UI state to ensure text colors are correct.
- Specifically verify:
    - Login screen labels and hint text in dark mode.
    - Assessment question text and option labels in dark mode.
    - Professional login link visibility.
