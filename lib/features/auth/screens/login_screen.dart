import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_radii.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../generated/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secondFactorController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _secondFactorController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AppLocalizations l10n) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.error_fill_all_fields)));
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            secondFactorCode: _secondFactorController.text.trim().isEmpty
                ? null
                : _secondFactorController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_prefix}${e.toString()}'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    // Listen to auth changes for navigation
    ref.listen(authProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        if (mounted) {
          logger.i(
            'LoginScreen: User authenticated, navigating to root for redirection',
          );
          context.go('/');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: Text(l10n.login_button),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                LucideIcons.shield_check,
                size: 80,
                color: AppColors.oliveGreen,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              SindGlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(LucideIcons.mail),
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.mediumRadius,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: l10n.password,
                        prefixIcon: const Icon(LucideIcons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? LucideIcons.eye_off
                                : LucideIcons.eye,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.mediumRadius,
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _secondFactorController,
                      decoration: InputDecoration(
                        labelText: l10n.localSecondFactorCode,
                        helperText: l10n.localSecondFactorHint,
                        prefixIcon: const Icon(LucideIcons.shield_check),
                        border: OutlineInputBorder(
                          borderRadius: AppRadii.mediumRadius,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    if (authState.isLoading)
                      const CircularProgressIndicator()
                    else
                      SindPrimaryButton(
                        label: l10n.login_button,
                        onPressed: () => _handleLogin(l10n),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => context.push('/register'),
                child: Text("${l10n.noAccount} ${l10n.signUp}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
