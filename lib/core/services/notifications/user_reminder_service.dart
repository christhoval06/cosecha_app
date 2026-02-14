import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';

import '../../../data/models/reminder_item.dart';
import '../../../data/repositories/reminder_repository.dart';
import '../logger_service.dart';
import 'flutter_local_notification_service.dart';
import 'notification_payload.dart';
import 'notification_service.dart';
import 'reminder_destinations.dart';

class UserReminderService {
  UserReminderService(this._notificationService, this._repository);

  final NotificationService _notificationService;
  final ReminderRepository _repository;

  static const _uuid = Uuid();
  static const String _channelId = 'user_reminders';
  static const String _channelName = 'Recordatorios';
  static const String _channelDescription =
      'Recordatorios personalizados creados por el usuario';
  static bool _timezoneInitialized = false;

  ValueListenable<Box<ReminderItem>> listenable() => _repository.listenable();

  List<ReminderItem> getAll() => _repository.getAll();

  int count() => _repository.count();

  Future<ReminderItem> create({
    required String title,
    required String description,
    required String label,
    required int hour,
    required int minute,
    required List<int> weekdays,
    bool enabled = true,
    String? destinationId,
  }) async {
    final sanitizedWeekdays = _sanitizeWeekdays(weekdays);
    final now = DateTime.now().millisecondsSinceEpoch;

    final reminder = ReminderItem(
      id: _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      label: label.trim(),
      enabled: enabled,
      hour: hour,
      minute: minute,
      weekdays: sanitizedWeekdays,
      destinationId: destinationId,
      createdAtMs: now,
      notificationBaseId: await _repository.takeNextNotificationBase(),
    );

    await _repository.save(reminder);
    await _syncReminder(reminder);
    return reminder;
  }

  Future<void> update(ReminderItem reminder) async {
    final current = _repository.getById(reminder.id);
    if (current == null) return;

    final updated = reminder.copyWith(
      title: reminder.title.trim(),
      description: reminder.description.trim(),
      label: reminder.label.trim(),
      weekdays: _sanitizeWeekdays(reminder.weekdays),
      notificationBaseId:
          reminder.notificationBaseId ?? current.notificationBaseId,
      createdAtMs: reminder.createdAtMs ?? current.createdAtMs,
    );

    await _cancelReminder(current);
    await _repository.save(updated);
    await _syncReminder(updated);
  }

  Future<void> setEnabled(String id, bool enabled) async {
    final current = _repository.getById(id);
    if (current == null) return;
    final updated = current.copyWith(enabled: enabled);
    await update(updated);
  }

  Future<void> delete(String id) async {
    final current = _repository.getById(id);
    if (current == null) return;
    await _cancelReminder(current);
    await _repository.delete(id);
  }

  Future<void> syncAllScheduled() async {
    final reminders = _repository.getAll();
    for (final reminder in reminders) {
      await _cancelReminder(reminder);
      await _syncReminder(reminder);
    }
  }

  Future<void> _syncReminder(ReminderItem reminder) async {
    final baseId = reminder.notificationBaseId;
    if (!reminder.enabled || baseId == null) return;

    try {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        LoggerService.warning(
          'Notification permission denied while scheduling reminders',
          tag: 'NOTIFICATIONS',
        );
        return;
      }

      _ensureTimezoneInitialized();

      for (final weekday in reminder.weekdays) {
        final scheduledDate = _nextWeeklyDate(
          weekday: weekday,
          hour: reminder.hour,
          minute: reminder.minute,
        );

        await _scheduleWeekly(
          id: _notificationId(baseId, weekday),
          title: reminder.title,
          body: reminder.description,
          destinationId: reminder.destinationId,
          scheduledDate: scheduledDate,
        );
      }
    } catch (error, stackTrace) {
      LoggerService.error(
        'Failed to schedule user reminder',
        tag: 'NOTIFICATIONS',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _cancelReminder(ReminderItem reminder) async {
    final baseId = reminder.notificationBaseId;
    if (baseId == null) return;

    for (var weekday = 1; weekday <= 7; weekday++) {
      await _notificationService.cancel(_notificationId(baseId, weekday));
    }
  }

  Future<void> _scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? destinationId,
  }) async {
    final service = _notificationService;
    if (service is! FlutterLocalNotificationService) return;

    final payload = _payloadForDestination(destinationId).encode();
    final plugin = service.plugin;

    await plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          icon: 'app_icon',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  NotificationPayload _payloadForDestination(String? destinationId) {
    if (destinationId == null) {
      return const NotificationPayload(type: 'user_reminder');
    }

    final spec = ReminderDestinations.specs[destinationId];
    if (spec == null) {
      return const NotificationPayload(type: 'user_reminder');
    }

    return NotificationPayload(
      type: 'user_reminder',
      route: spec.route,
      arguments: spec.arguments,
    );
  }

  tz.TZDateTime _nextWeeklyDate({
    required int weekday,
    required int hour,
    required int minute,
  }) {
    final nowLocal = DateTime.now();
    final targetLocal = _nextLocalDate(
      now: nowLocal,
      weekday: weekday,
      hour: hour,
      minute: minute,
    );
    final targetUtc = targetLocal.toUtc();

    // Keep scheduling deterministic without requiring native timezone lookup.
    return tz.TZDateTime.from(targetUtc, tz.UTC);
  }

  DateTime _nextLocalDate({
    required DateTime now,
    required int weekday,
    required int hour,
    required int minute,
  }) {
    final normalizedWeekday = min(max(weekday, 1), 7);
    var candidate = DateTime(now.year, now.month, now.day, hour, minute);
    while (candidate.weekday != normalizedWeekday || !candidate.isAfter(now)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  int _notificationId(int baseId, int weekday) {
    return 20000 + (baseId * 10) + weekday;
  }

  List<int> _sanitizeWeekdays(List<int> weekdays) {
    final unique = weekdays
        .where((value) => value >= 1 && value <= 7)
        .toSet()
        .toList();
    unique.sort();
    if (unique.isEmpty) {
      return <int>[DateTime.monday];
    }
    return unique;
  }

  void _ensureTimezoneInitialized() {
    if (_timezoneInitialized) return;
    tz_data.initializeTimeZones();
    _timezoneInitialized = true;
  }
}
