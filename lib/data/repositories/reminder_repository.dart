import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../hive/boxes.dart';
import '../models/reminder_item.dart';

class ReminderRepository {
  ReminderRepository();

  Box<ReminderItem> get _box => Hive.box<ReminderItem>(HiveBoxes.reminders);

  ValueListenable<Box<ReminderItem>> listenable() => _box.listenable();

  List<ReminderItem> getAll() {
    final reminders = _box.values.where((item) => item.id.isNotEmpty).toList();

    reminders.sort((a, b) {
      final createdAtA = a.createdAtMs ?? 0;
      final createdAtB = b.createdAtMs ?? 0;
      return createdAtA.compareTo(createdAtB);
    });

    return reminders;
  }

  ReminderItem? getById(String id) {
    return _box.get(id);
  }

  Future<void> save(ReminderItem reminder) async {
    final exists = _box.containsKey(reminder.id);
    if (!exists && count() >= AppConstants.remindersMaxCount) {
      throw StateError('reminder_limit_reached');
    }
    await _box.put(reminder.id, reminder);
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  int count() {
    return getAll().length;
  }

  Future<int> takeNextNotificationBase() async {
    final next =
        _box.values
            .map((item) => item.notificationBaseId ?? 0)
            .fold<int>(0, (max, value) => value > max ? value : max) +
        1;
    return next;
  }
}
