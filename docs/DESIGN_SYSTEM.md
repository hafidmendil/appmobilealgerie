# NeuroSync 4.0 (SIND) Design System

## 1. Visual Identity
- **Concept**: Modern Wellness, Premium Glassmorphism, Soft Minimalism.
- **Tone**: Human, Reassuring, Calm, Professional.

## 2. Palette
### Primary (Olive)
- Olive Green: `#6B7D4A`
- Deep Olive: `#4E6135`
- Soft Olive: `#879866`

### Background
- Warm Beige: `#F6F1E8`
- Soft Cream: `#FBF8F2`

### Secondary & Accent
- Sky Blue: `#8FC9D8`
- Warm Sand: `#D9C6A5`

## 3. Typography
- **Latin**: Manrope (via Google Fonts)
- **Arabic**: Noto Sans Arabic
- **Styles**: 
  - `DisplayLarge`: 32pt Bold
  - `HeadlineLarge`: 24pt Bold
  - `TitleLarge`: 18pt SemiBold
  - `BodyLarge`: 16pt Normal (1.5 height)

## 4. Components
- **SindPrimaryButton**: Elevated button with olive green background.
- **SindGlassCard**: Translucent card with background blur (sigma 10).
- **SindProgressBar**: Animated shimmer progress bar.
- **SindAnswerOption**: Premium tactile card for questionnaire options.

## 5. Layout & Tokens
- **Spacing**: Multiples of 8 (sm: 8, md: 16, lg: 24, xl: 32).
- **Radii**: 
  - Large: 20px (Cards)
  - Extra Large: 28px (Question Cards)
  - Pill: 999px (Progress bars, chips)

## 6. Animations
- **Library**: `flutter_animate`
- **Principles**: 
  - Subtle FadeIn & Scale for entry.
  - SlideX for transitions between questions.
  - Shimmer for loading/progress.
  - Smooth 4-4-4 cycle for breathing exercises.

## 7. Accessibility
- Minimum touch target: 48x48.
- High contrast compliant colors.
- Full RTL (Arabic/Darija) support.
- Dark Mode support with dedicated palette.
