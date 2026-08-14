# Implementation Plan - NeuroSync 4.0 (SIND) UI/UX Overhaul

Transform the existing NeuroSync application into a premium, calm, and accessible mobile experience ("Modern Wellness" style).

## User Review Required

> [!IMPORTANT]
> - **Logo Design**: I will implement a placeholder logo component using the specified elements (Heart + Brain Wave + Olive Leaf) using CustomPainter or SVGs if available.
> - **Animations**: I propose adding `flutter_animate` to achieve the high-quality micro-interactions requested.
> - **Navigation**: I will transition to a more modern bottom navigation bar as requested.

## Proposed Changes

### 1. Design System & Infrastructure
Establish the foundation of the new visual identity.

#### [NEW] [app_colors.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_colors.dart)
- Define design tokens for Primary (Olive), Background (Beige), Secondary (Blue), and Semantic colors.
- Implement Dark Mode palette.

#### [NEW] [app_typography.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_typography.dart)
- Configure Inter/Noto Sans Arabic text styles.

#### [NEW] [app_spacing.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_spacing.dart), [app_radii.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_radii.dart), [app_shadows.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/tokens/app_shadows.dart)
- Standardize layout tokens.

#### [app_theme.dart](file:///home/hafid/Bureau/projetmascara/lib/core/theme/app_theme.dart)
- Update to use the new tokens.
- Implement comprehensive `ThemeData` for light and dark modes.

#### [NEW] [sind_components.dart](file:///home/hafid/Bureau/projetmascara/lib/core/widgets/sind_components.dart)
- Create reusable premium components: `SindButton`, `SindGlassCard`, `SindProgressBar`, `SindAnswerOption`.

---

### 2. Entry & Onboarding Experience
Create a welcoming and reassuring first impression.

#### [NEW] [splash_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/onboarding/splash_screen.dart)
- Implement the organic startup animation sequence.

#### [welcome_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/onboarding/welcome_screen.dart) & [NEW] Onboarding Flow
- Redesign into a 4-step interactive onboarding experience with illustrations.

---

### 3. Core Assessment & Results
Overhaul the primary user journey.

#### [assessment_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/assessment/assessment_screen.dart)
- Transform into a premium card-based experience.
- Add smooth transitions between questions.
- Implement the "Final Message" text area page after 15 questions.

#### [results_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/results/results_screen.dart)
- Implement human-centered synthesis (no raw scores).
- Create "Needs Cards" and "Priority Visualization" with supportive tone.

---

### 4. New Wellness Modules
Implement the requested supportive features.

#### [NEW] [breathing_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/wellness/breathing_screen.dart)
- Immersive breathing exercise with animated growth/shrink circle.

#### [NEW] [spiritual_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/wellness/spiritual_screen.dart)
- Elegant display of spiritual support content from the engine.

#### [NEW] [plan_7_days_screen.dart](file:///home/hafid/Bureau/projetmascara/lib/features/wellness/plan_7_days_screen.dart)
- Timeline view of the 7-day personalized path.

---

### 5. Dashboard & Navigation
Update the main interface for returning users.

#### [user_dashboard.dart](file:///home/hafid/Bureau/projetmascara/lib/features/dashboard/user_dashboard.dart)
- Implement the Hero Card ("How do you feel today?").
- Add Quick Actions grid and Daily Check-in.

#### [app_router.dart](file:///home/hafid/Bureau/projetmascara/lib/core/navigation/app_router.dart)
- Integrate new screens into the routing system.

## Verification Plan

### Automated Tests
- `flutter test`: Run existing tests to ensure no regressions in business logic.
- `flutter analyze`: Ensure code quality and no lint errors.

### Manual Verification
- **Visual Audit**: Verify colors, typography, and spacing against the design system tokens.
- **RTL Check**: Switch language to Arabic and verify layout mirroring.
- **Dark Mode**: Toggle system dark mode and verify readability and aesthetics.
- **Accessibility**: Test with high text scaling and verify touch targets (min 48x48).
- **Navigation Flow**: Walk through the entire journey from Splash to Results and Wellness modules.
