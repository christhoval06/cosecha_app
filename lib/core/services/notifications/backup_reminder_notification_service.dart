import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_prefs.dart';
import '../logger_service.dart';
import '../../../l10n/app_localizations.dart';
import 'notification_payload.dart';
import 'notification_service.dart';
import 'reminder_destinations.dart';

class BackupReminderNotificationService {
  BackupReminderNotificationService(this._notificationService);

  final NotificationService _notificationService;

  static const int _notificationId = 8001;
  static const int _testNotificationId = 8002;
  static const String _channelId = 'backup_reminders';
  static const String _testChannelId = 'backup_reminders_high';

  static const List<String> availableTapDestinationIds = <String>[
    ReminderDestinations.dataBackup,
    ReminderDestinations.settings,
    ReminderDestinations.notificationSettings,
  ];

  Future<void> ensureScheduled() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(AppPrefs.backupReminderEnabled) ?? true;
    if (!enabled) {
      await _notificationService.cancel(_notificationId);
      return;
    }

    final l10n = _localizedStrings();
    final repeat = _readFrequency(prefs);
    final tapDestinationId = _readTapDestinationId(prefs);
    await _notificationService.showPeriodic(
      NotificationRequest(
        id: _notificationId,
        title: l10n.backupReminderNotificationTitle,
        body: l10n.backupReminderNotificationBody,
        channel: NotificationChannelConfig(
          id: _channelId,
          name: l10n.backupReminderNotificationChannelName,
          description: l10n.backupReminderNotificationChannelDescription,
        ),
        payload: _payloadForDestination(tapDestinationId),
      ),
      repeat: repeat,
    );
  }

  Future<void> onBackupCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppPrefs.backupLastCompletedAtMs,
      DateTime.now().millisecondsSinceEpoch,
    );

    await ensureScheduled();
  }

  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefs.backupReminderEnabled, enabled);
    if (!enabled) {
      await _notificationService.cancel(_notificationId);
      return;
    }
    await ensureScheduled();
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppPrefs.backupReminderEnabled) ?? true;
  }

  Future<AppNotificationRepeat> getFrequency() async {
    final prefs = await SharedPreferences.getInstance();
    return _readFrequency(prefs);
  }

  Future<void> setFrequency(AppNotificationRepeat repeat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppPrefs.backupReminderFrequency, repeat.name);
    await ensureScheduled();
  }

  Future<String> getTapDestinationId() async {
    final prefs = await SharedPreferences.getInstance();
    return _readTapDestinationId(prefs);
  }

  Future<void> setTapDestinationId(String destinationId) async {
    if (!availableTapDestinationIds.contains(destinationId)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppPrefs.backupReminderTapRoute, destinationId);
    await ensureScheduled();
  }

  Future<void> sendTestNotification() async {
    try {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        throw StateError('notification_permission_denied');
      }
      final l10n = _localizedStrings();
      final prefs = await SharedPreferences.getInstance();
      final tapDestinationId = _readTapDestinationId(prefs);
      await _notificationService.show(
        NotificationRequest(
          id: _testNotificationId,
          title: l10n.backupReminderNotificationTitle,
          body: l10n.backupReminderNotificationBody,
          channel: NotificationChannelConfig(
            id: _testChannelId,
            name: l10n.backupReminderNotificationChannelName,
            description: l10n.backupReminderNotificationChannelDescription,
          ),
          highPriority: true,
          payload: _payloadForDestination(tapDestinationId),
        ),
      );
    } catch (error, stackTrace) {
      LoggerService.error(
        'sendTestNotification failed',
        tag: 'NOTIFICATIONS',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  AppLocalizations _localizedStrings() {
    final locale = ui.PlatformDispatcher.instance.locale;
    return lookupAppLocalizations(locale);
  }

  AppNotificationRepeat _readFrequency(SharedPreferences prefs) {
    final raw = prefs.getString(AppPrefs.backupReminderFrequency);
    return switch (raw) {
      'hourly' => AppNotificationRepeat.hourly,
      'daily' => AppNotificationRepeat.daily,
      'weekly' => AppNotificationRepeat.weekly,
      _ => AppNotificationRepeat.weekly,
    };
  }

  String _readTapDestinationId(SharedPreferences prefs) {
    final raw = prefs.getString(AppPrefs.backupReminderTapRoute);

    if (raw != null && availableTapDestinationIds.contains(raw)) {
      return raw;
    }

    return switch (raw) {
      '/data-backup' => ReminderDestinations.dataBackup,
      '/settings' => ReminderDestinations.settings,
      '/notification-settings' => ReminderDestinations.notificationSettings,
      _ => ReminderDestinations.dataBackup,
    };
  }

  String _payloadForDestination(String destinationId) {
    final spec = ReminderDestinations.specs[destinationId];
    return NotificationPayload(
      type: 'backup_reminder',
      route: spec?.route,
      arguments: spec?.arguments,
    ).encode();
  }
}
