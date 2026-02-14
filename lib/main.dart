import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cosecha_app/l10n/app_localizations.dart';

import 'core/constants/app_prefs.dart';
import 'core/constants/app_routes.dart';
import 'core/premium/premium_access.dart';
import 'core/router/app_navigator.dart';
import 'core/router/app_router.dart';
import 'core/services/business_session.dart';
import 'core/services/app_services.dart';
import 'core/services/image_path_repair_service.dart';
import 'core/services/notifications/notification_payload.dart';
import 'core/services/notifications/reminder_destinations.dart';
import 'core/theme/app_theme.dart';
import 'data/hive/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveInitializer.init();
  await ImagePathRepairService.repairIfNeeded();
  await BusinessSession.instance.load();
  final prefs = await SharedPreferences.getInstance();
  final hasCompletedOnboarding =
      prefs.getBool(AppPrefs.onboardingComplete) ?? false;
  final hasCompletedProfileSetup =
      prefs.getBool(AppPrefs.profileSetupComplete) ?? false;
  await PremiumAccess.instance.ensureLoaded();
  await AppServices.notifications.initialize(onTap: _handleNotificationTap);
  await AppServices.backupReminders.ensureScheduled();
  await AppServices.userReminders.syncAllScheduled();

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
      navigatorKey: AppNavigator.navigatorKey,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: initialRoute,
      routes: AppRouter.routes,
    );
  }
}

Future<void> _handleNotificationTap(String? rawPayload) async {
  final payload = NotificationPayload.tryDecode(rawPayload);
  final route = _resolveNotificationRoute(payload);
  if (route == null || !AppRouter.routes.containsKey(route)) return;
  AppNavigator.pushNamed(route, arguments: payload?.arguments);
}

String? _resolveNotificationRoute(NotificationPayload? payload) {
  final directRoute = payload?.route;
  if (directRoute != null && directRoute.isNotEmpty) {
    return directRoute;
  }

  return switch (payload?.type) {
    'backup_reminder' =>
      ReminderDestinations.specs[ReminderDestinations.dataBackup]?.route,
    _ => null,
  };
}
