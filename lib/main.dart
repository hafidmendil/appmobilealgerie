import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projetmascara/core/theme/app_theme.dart';
import 'package:projetmascara/core/theme/theme_mode_provider.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/navigation/app_router.dart';
import 'package:projetmascara/core/localization/locale_provider.dart';
import 'package:projetmascara/core/data/database_seed_service.dart';
import 'package:projetmascara/core/data/hive_config.dart';
import 'package:projetmascara/core/data/migration/database_migration_service.dart';

import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/error/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Configuration
  AppConfig.init(
    env: Environment.prod,
    deploymentMode: DeploymentMode.offline,
    enableDemoData: true,
  );

  // Initialize Error Handling
  ErrorHandler.initialize();

  // Initialize Hive
  await HiveConfig.init();

  // Run Database Schema Migrations
  await DatabaseMigrationService().runMigrations();

  // Seed initial data if necessary
  await DatabaseSeedService.seed();

  runApp(const ProviderScope(child: NeuroSyncApp()));
}

class NeuroSyncApp extends ConsumerWidget {
  const NeuroSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr'), Locale('ar')],
      routerConfig: router,
    );
  }
}
