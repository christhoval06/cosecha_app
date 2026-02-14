import 'package:hive_flutter/hive_flutter.dart';

import 'package:cosecha_app/core/services/logger_service.dart';

import 'package:cosecha_app/data/models/business.dart';
import 'package:cosecha_app/data/models/product.dart';
import 'package:cosecha_app/data/models/product_price_history.dart';
import 'package:cosecha_app/data/models/reminder_item.dart';
import 'package:cosecha_app/data/models/sale_transaction.dart';

import 'boxes.dart';

class HiveInitializer {
  HiveInitializer._();

  static const String _legacyReminderMetaKey = '__meta_next_notification_base';

  static Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapters();
    await _openBoxes();

    LoggerService.info('Hive initialized successfully', tag: 'HIVE');
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BusinessAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProductAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProductPriceHistoryAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(SaleTransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ReminderItemAdapter());
    }
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<Business>(HiveBoxes.business);
    await Hive.openBox<Product>(HiveBoxes.products);
    await Hive.openBox<ProductPriceHistory>(HiveBoxes.productPriceHistory);
    await Hive.openBox<SaleTransaction>(HiveBoxes.transactions);
    final legacyReminderBox = await Hive.openBox<dynamic>(HiveBoxes.reminders);
    await _migrateLegacyReminderBox(legacyReminderBox);
    await legacyReminderBox.close();
    await Hive.openBox<ReminderItem>(HiveBoxes.reminders);
  }

  static Future<void> _migrateLegacyReminderBox(Box<dynamic> box) async {
    final keys = box.keys.toList();
    for (final key in keys) {
      if (key == _legacyReminderMetaKey) {
        await box.delete(key);
        continue;
      }

      final value = box.get(key);
      if (value is ReminderItem) continue;

      if (value is Map) {
        final migrated = ReminderItem.fromMap(value.cast<dynamic, dynamic>());
        if (migrated.id.isEmpty) {
          await box.delete(key);
          continue;
        }
        await box.put(key, migrated);
        continue;
      }

      await box.delete(key);
    }
  }
}
