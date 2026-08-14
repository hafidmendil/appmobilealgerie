import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projetmascara/core/theme/app_theme.dart';
import 'package:projetmascara/generated/l10n/app_localizations.dart';
import 'package:projetmascara/core/navigation/app_router.dart';
import 'package:projetmascara/core/auth/user_role.dart';
import 'package:projetmascara/core/models/user_model.dart';
import 'package:projetmascara/features/assessment/assessment_record.dart';
import 'package:projetmascara/features/professional/models/access_request.dart';
import 'package:projetmascara/core/models/wilaya_model.dart';
import 'package:projetmascara/core/models/sync_item.dart';
import 'package:projetmascara/features/professional/models/professional_profile.dart';
import 'package:projetmascara/core/models/admin/security_log.dart';
import 'package:projetmascara/core/localization/locale_provider.dart';
import 'package:projetmascara/core/data/database_seed_service.dart';

import 'package:projetmascara/core/config/app_config.dart';
import 'package:projetmascara/core/error/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Configuration
  AppConfig.init(env: Environment.dev);
  
  // Initialize Error Handling
  ErrorHandler.initialize();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(UserRoleAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AssessmentRecordAdapter());
  Hive.registerAdapter(AccessRequestStatusAdapter());
  Hive.registerAdapter(AccessRequestAdapter());
  Hive.registerAdapter(SyncOperationAdapter());
  Hive.registerAdapter(SyncItemAdapter());
  Hive.registerAdapter(ProfessionalProfileAdapter());
  Hive.registerAdapter(SecurityLogAdapter());
  Hive.registerAdapter(WilayaAdapter());
  
  // Seed initial data if necessary
  await DatabaseSeedService.seed();
  
  runApp(
    const ProviderScope(
      child: NeuroSyncApp(),
    ),
  );
}

class NeuroSyncApp extends ConsumerWidget {
  const NeuroSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.system,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('ar'),
      ],
      routerConfig: router,
    );
  }
}
