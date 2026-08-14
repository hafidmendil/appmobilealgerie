import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../assessment/assessment_state.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      
      final userState = ref.read(authProvider);
      if (userState.hasError) {
        throw userState.error!;
      }
      
      final user = userState.value;
      if (user == null) throw Exception("Identifiants incorrects.");

      final guestAssessments = await ref.read(guestAssessmentsProvider.future);
      
      if (guestAssessments.isNotEmpty && mounted) {
        final shouldMigrate = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.migratePromptTitle),
            content: Text(l10n.migratePromptBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.opt_no),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.transfer),
              ),
            ],
          ),
        );

        if (shouldMigrate == true) {
          await ref.read(assessmentRepositoryProvider).migrateGuestAssessments(user.id);
        }
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_occurred}: ${e.toString()}'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const AppLogo(size: 80).animate().fadeIn().scale(),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.xxl),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(LucideIcons.mail, size: 20),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? l10n.email : null,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  prefixIcon: const Icon(LucideIcons.lock, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? LucideIcons.eye_off : LucideIcons.eye, size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                obscureText: _obscurePassword,
                validator: (value) => value!.isEmpty ? l10n.password : null,
              ).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () {},
                  child: Text(l10n.forgotPassword),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SindPrimaryButton(
                label: l10n.login,
                onPressed: _login,
                isLoading: _isLoading,
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noAccount),
                  TextButton(
                    onPressed: () => context.pushReplacement('/register'),
                    child: Text(l10n.signUp),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
