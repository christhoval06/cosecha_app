import '../../constants/app_routes.dart';

class ReminderDestinationSpec {
  const ReminderDestinationSpec({
    required this.id,
    required this.route,
    this.arguments,
  });

  final String id;
  final String route;
  final Map<String, dynamic>? arguments;
}

class ReminderDestinations {
  ReminderDestinations._();

  static const String newProduct = 'new_product';
  static const String newSale = 'new_sale';
  static const String reports = 'reports';
  static const String salesHistory = 'sales_history';
  static const String profile = 'profile';
  static const String performanceToday = 'performance_today';
  static const String performanceWeek = 'performance_week';
  static const String performanceMonth = 'performance_month';
  static const String dataBackup = 'data_backup';
  static const String settings = 'settings';
  static const String notificationSettings = 'notification_settings';
  static const String notificationReminders = 'notification_reminders';

  static const List<String> selectableIds = <String>[
    newProduct,
    newSale,
    reports,
    salesHistory,
    profile,
    performanceToday,
    performanceWeek,
    performanceMonth,
  ];

  static const Map<String, ReminderDestinationSpec> specs = {
    newProduct: ReminderDestinationSpec(
      id: newProduct,
      route: AppRoutes.productEdit,
    ),
    newSale: ReminderDestinationSpec(id: newSale, route: AppRoutes.saleAdd),
    reports: ReminderDestinationSpec(id: reports, route: AppRoutes.reports),
    salesHistory: ReminderDestinationSpec(
      id: salesHistory,
      route: AppRoutes.salesHistory,
    ),
    profile: ReminderDestinationSpec(
      id: profile,
      route: AppRoutes.profileSetup,
      arguments: {'isEdit': true},
    ),
    performanceToday: ReminderDestinationSpec(
      id: performanceToday,
      route: AppRoutes.homePerformanceDetail,
      arguments: {'period': 'daily'},
    ),
    performanceWeek: ReminderDestinationSpec(
      id: performanceWeek,
      route: AppRoutes.homePerformanceDetail,
      arguments: {'period': 'weekly'},
    ),
    performanceMonth: ReminderDestinationSpec(
      id: performanceMonth,
      route: AppRoutes.homePerformanceDetail,
      arguments: {'period': 'monthly'},
    ),
    dataBackup: ReminderDestinationSpec(
      id: dataBackup,
      route: AppRoutes.dataBackup,
    ),
    settings: ReminderDestinationSpec(id: settings, route: AppRoutes.settings),
    notificationSettings: ReminderDestinationSpec(
      id: notificationSettings,
      route: AppRoutes.notificationSettings,
    ),
    notificationReminders: ReminderDestinationSpec(
      id: notificationReminders,
      route: AppRoutes.notificationReminders,
    ),
  };
}
