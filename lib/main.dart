import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosecha_app/l10n/app_localizations.dart';

import 'core/constants/app_prefs.dart';
import 'core/constants/app_routes.dart';
import 'core/router/app_router.dart';
import 'core/services/business_session.dart';
import 'core/theme/app_theme.dart';
import 'data/hive/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitializer.init();
  await BusinessSession.instance.load();
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding =
      prefs.getBool(AppPrefs.onboardingComplete) ?? false;
  final hasCompletedProfileSetup =
      prefs.getBool(AppPrefs.profileSetupComplete) ?? false;

  String initialRoute = AppRoutes.onboarding;
  if (hasCompletedOnboarding) {
    if (hasCompletedProfileSetup) {
      initialRoute = AppRoutes.home;
    } else {
      initialRoute = AppRoutes.profileSetup;
    }
  }

  runApp(CosechaApp(initialRoute: initialRoute));
}

class CosechaApp extends StatelessWidget {
  final String initialRoute;
  const CosechaApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: initialRoute,
      routes: AppRouter.routes,
    );
  }
}
