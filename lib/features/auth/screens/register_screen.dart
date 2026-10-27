import '../../../core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/user_role.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_radii.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../generated/l10n/app_localizations.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.user;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister(AppLocalizations l10n) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.error_fill_all_fields),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.auto_veuillez_entrer_une_adresse),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.auto_mot_passe_doit_faire),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    try {
      await ref
          .read(authProvider.notifier)
          .register(email, password, _selectedRole);
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
            'RegisterScreen: User authenticated, navigating to root for redirection',
          );
          context.go('/');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.warmBeige,
      appBar: AppBar(
        title: Text(l10n.register_button),
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
                LucideIcons.user_plus,
                size: 80,
                color: AppColors.oliveGreen,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.registerTitle,
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
                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      l10n.roleSelection,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.userAccount),
                            selected: _selectedRole == UserRole.user,
                            onSelected: (val) =>
                                setState(() => _selectedRole = UserRole.user),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: ChoiceChip(
                            label: Text(l10n.professionalAccount),
                            selected: _selectedRole == UserRole.psychologist,
                            onSelected: (val) => setState(
                              () => _selectedRole = UserRole.psychologist,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    if (authState.isLoading)
                      const CircularProgressIndicator()
                    else
                      SindPrimaryButton(
                        label: l10n.register_button,
                        onPressed: () => _handleRegister(l10n),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(l10n.already_have_account),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
