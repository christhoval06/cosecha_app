import 'package:flutter/material.dart';

import '../../features/business/profile_setup_screen.dart';
import '../../features/home/home_performance_detail_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/products/product_edit_screen.dart';
import '../../features/products/product_list_screen.dart';
import '../../features/settings/developer_screen.dart';
import '../../features/settings/data_backup_screen.dart';
import '../../features/settings/notification_settings_screen.dart';
import '../../features/reminders/reminders_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/transactions/add_sale_screen.dart';
import '../../features/transactions/sales_history_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../data/models/product.dart';
import '../../data/repositories/performance_period_repository.dart';
import '../../l10n/app_localizations.dart';
import '../constants/app_routes.dart';
import '../widgets/widgets.dart';

class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> routes = {
    AppRoutes.onboarding: (context) => const OnboardingScreen(),
    AppRoutes.profileSetup: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return ProfileSetupScreen(isEdit: _readIsEdit(args));
    },
    AppRoutes.home: (context) => const HomeScreen(),
    AppRoutes.products: (context) => const ProductListScreen(),
    AppRoutes.salesHistory: (context) => const SalesHistoryScreen(),
    AppRoutes.saleAdd: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Product) {
        return AddSaleScreen(product: args);
      }
      return const AddSaleScreen();
    },
    AppRoutes.homePerformanceDetail: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final period = _readPerformancePeriod(args);
      if (period != null) {
        return HomePerformanceDetailScreen(period: period);
      }
      return InvalidRouteArgsScreen(
        message: AppLocalizations.of(context).invalidProductMessage,
      );
    },
    AppRoutes.settings: (context) => const SettingsScreen(),
    AppRoutes.notificationSettings: (context) =>
        const NotificationSettingsScreen(),
    AppRoutes.notificationReminders: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      return RemindersScreen(autoOpenCreate: _readAutoOpenCreate(args));
    },
    AppRoutes.productEdit: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null) {
        return const ProductEditScreen();
      }
      if (args is Product) {
        return ProductEditScreen(product: args);
      }
      return InvalidRouteArgsScreen(
        message: AppLocalizations.of(context).invalidProductMessage,
      );
    },
    AppRoutes.dataBackup: (context) => const DataBackupScreen(),
    AppRoutes.reports: (context) => const ReportsScreen(),
    AppRoutes.developer: (context) => const DeveloperScreen(),
  };

  static bool _readIsEdit(Object? args) {
    if (args is bool) return args;
    if (args is Map && args['isEdit'] is bool) {
      return args['isEdit'] as bool;
    }
    return false;
  }

  static bool _readAutoOpenCreate(Object? args) {
    if (args is Map && args['autoOpenCreate'] is bool) {
      return args['autoOpenCreate'] as bool;
    }
    return false;
  }

  static PerformancePeriod? _readPerformancePeriod(Object? args) {
    if (args is HomePerformanceDetailArgs) {
      return args.period;
    }
    if (args is Map && args['period'] is String) {
      return switch ((args['period'] as String).toLowerCase()) {
        'daily' => PerformancePeriod.daily,
        'weekly' => PerformancePeriod.weekly,
        'monthly' => PerformancePeriod.monthly,
        _ => null,
      };
    }
    return null;
  }
}
