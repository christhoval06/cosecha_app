import 'notifications/backup_reminder_notification_service.dart';
import 'notifications/flutter_local_notification_service.dart';

class AppServices {
  AppServices._();

  static final notifications = FlutterLocalNotificationService.instance;
  static final backupReminders = BackupReminderNotificationService(
    notifications,
  );
}
