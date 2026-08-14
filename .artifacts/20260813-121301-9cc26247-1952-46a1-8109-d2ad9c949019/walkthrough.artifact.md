# Walkthrough - UI Visibility and Contrast Improvements

I have improved the application's visibility and contrast, particularly in dark mode, by making the theme reactive to brightness and removing hardcoded dark colors from critical components.

## Changes

### Theme & Typography
- **[app_typography.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_typography.dart)**:
    - Updated `getTextTheme` to require an explicit `Brightness` parameter. This ensures that text colors are correctly assigned based on the intended theme, rather than relying on a potentially stale global theme state during initialization.
- **[app_theme.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/app_theme.dart)**:
    - Enhanced the `darkTheme` definition with explicit `inputDecorationTheme`, `outlinedButtonTheme`, and `textButtonTheme`.
    - Improved contrast for input fields in dark mode by using `AppColors.darkSecondary` for borders and hints, and `AppColors.darkPrimary` for focused states.
    - Updated `AppTypography` calls to pass the correct brightness.

### Components
- **[sind_components.dart](file:///home/hafid/Bureau/projetmascara/lib/core/widgets/sind_components.dart)**:
    - **`SindAnswerOption`**: Removed hardcoded `AppColors.textPrimary`. It now uses `theme.textTheme.bodyLarge?.color` for unselected text and `AppColors.darkPrimary` for selected text in dark mode, ensuring high contrast.
    - **`SindGlassCard`**: Updated to use the theme's text color dynamically.
- **[splash_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/onboarding/splash_screen.dart)**:
    - Updated typography call to pass current brightness.

## Verification Results

### Static Analysis
I ran `flutter analyze` to verify that all calls to `getTextTheme` were updated correctly. The analysis confirmed that the previous positional argument errors were resolved.

### Manual Verification
- **Login Screen**: Verified that labels (Email, Password) and hint texts are now clearly visible in dark mode.
- **Form Fields**: Verified that input borders have sufficient contrast.
- **Assessment Options**: Verified that unselected options use white/light text in dark mode instead of near-black colors.
- **Buttons**: Verified that secondary/text buttons use the primary accent color (`AppColors.darkPrimary`) in dark mode.

> [!TIP]
> The improvements to `inputDecorationTheme` in `AppTheme.darkTheme` specifically address the issue where form labels and icons were nearly invisible against the dark background.
