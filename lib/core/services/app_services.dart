import 'notifications/backup_reminder_notification_service.dart';
import 'notifications/flutter_local_notification_service.dart';
import 'notifications/user_reminder_service.dart';
import '../../data/repositories/reminder_repository.dart';

class AppServices {
  AppServices._();

  static final notifications = FlutterLocalNotificationService.instance;
  static final remindersRepository = ReminderRepository();
  static final backupReminders = BackupReminderNotificationService(
    notifications,
  );
  static final userReminders = UserReminderService(
    notifications,
    remindersRepository,
  );
}
