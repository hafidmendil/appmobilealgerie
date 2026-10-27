import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:projetmascara/core/auth/auth_provider.dart';
import 'package:projetmascara/core/theme/tokens/app_colors.dart';
import 'package:projetmascara/core/theme/tokens/app_spacing.dart';
import 'package:projetmascara/core/widgets/sind_components.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';

class OfflineAdminSetupScreen extends ConsumerStatefulWidget {
  const OfflineAdminSetupScreen({super.key});

  @override
  ConsumerState<OfflineAdminSetupScreen> createState() =>
      _OfflineAdminSetupScreenState();
}

class _OfflineAdminSetupScreenState
    extends ConsumerState<OfflineAdminSetupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(authProvider.notifier)
          .initializeOfflineAdministrator(
            _emailController.text,
            _passwordController.text,
          );
      if (mounted) context.go('/admin');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_prefix}$error'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.offlineAdminSetup)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SindGlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.admin_panel_settings_outlined,
                    color: AppColors.oliveGreen,
                    size: 56,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.offlineAdminSetupDescription,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: l10n.email),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.newPassword),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SindPrimaryButton(
                    label: l10n.createOfflineAdministrator,
                    onPressed: _submitting ? null : () => _submit(l10n),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
