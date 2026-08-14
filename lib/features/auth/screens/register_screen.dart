import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/auth/user_role.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../assessment/assessment_state.dart';
import '../../../core/data/wilaya_data.dart';
import '../../../core/models/wilaya_model.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/sind_components.dart';
import '../../../core/theme/tokens/app_spacing.dart';
import '../../../core/theme/tokens/app_colors.dart';
import '../../../core/theme/tokens/app_radii.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.user;
  String? _selectedWilayaId;
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWilayaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner votre Wilaya")),
      );
      return;
    }
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _selectedRole,
          );
      
      final userState = ref.read(authProvider);
      if (userState.hasError) {
        throw userState.error!;
      }
      
      final user = userState.value;
      if (user == null) throw Exception("Erreur lors de la création du compte.");

      // Update Wilaya
      final updatedUser = user.copyWith(wilayaId: _selectedWilayaId);
      await ref.read(authRepositoryProvider).updateUser(updatedUser);

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
                child: Text(l10n.later),
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
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.accountCreated),
            backgroundColor: AppColors.success,
          ),
        );
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
              const AppLogo(size: 80).animate().fadeIn().scale(),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.registerTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.registerSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: AppSpacing.xxl),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  prefixIcon: const Icon(LucideIcons.mail, size: 20),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? l10n.email : null,
              ).animate().fadeIn(delay: 400.ms),
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
                validator: (value) => value!.length < 6 ? l10n.min_password_length : null,
              ).animate().fadeIn(delay: 500.ms),
              
              const SizedBox(height: AppSpacing.lg),
              
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Wilaya",
                  prefixIcon: const Icon(LucideIcons.map_pin, size: 20),
                ),
                value: _selectedWilayaId,
                items: algerianWilayas.map((w) {
                  final isRtl = Directionality.of(context) == TextDirection.rtl;
                  return DropdownMenuItem(
                    value: w.id,
                    child: Text(isRtl ? w.nameAr : w.nameFr),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedWilayaId = val),
                validator: (val) => val == null ? "Sélection requise" : null,
              ).animate().fadeIn(delay: 550.ms),

              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.roleSelection, 
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  _RoleButton(
                    label: l10n.userAccount,
                    icon: LucideIcons.user,
                    isSelected: _selectedRole == UserRole.user,
                    onTap: () => setState(() => _selectedRole = UserRole.user),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  _RoleButton(
                    label: l10n.professionalAccount.split('/').first.trim(),
                    icon: LucideIcons.heart_pulse,
                    isSelected: _selectedRole == UserRole.psychologist,
                    onTap: () => setState(() => _selectedRole = UserRole.psychologist),
                  ),
                ],
              ).animate().fadeIn(delay: 700.ms),
              
              const SizedBox(height: AppSpacing.xxl),
              SindPrimaryButton(
                label: l10n.createAccount,
                onPressed: _register,
                isLoading: _isLoading,
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.oliveGreen.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: isSelected ? AppColors.oliveGreen : AppColors.textMuted.withOpacity(0.2),
              width: 2,
            ),
            borderRadius: AppRadii.largeRadius,
          ),
          child: Column(
            children: [
              Icon(
                icon, 
                color: isSelected ? AppColors.oliveGreen : AppColors.textMuted,
                size: 28,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.oliveGreen : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
