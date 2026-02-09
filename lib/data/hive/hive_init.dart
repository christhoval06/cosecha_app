import 'package:hive_flutter/hive_flutter.dart';

import 'package:cosecha_app/core/services/logger_service.dart';

import 'package:cosecha_app/data/models/business.dart';
import 'package:cosecha_app/data/models/product.dart';
import 'package:cosecha_app/data/models/product_price_history.dart';
import 'package:cosecha_app/data/models/sale_transaction.dart';

import 'boxes.dart';

class HiveInitializer {
  HiveInitializer._();

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
  }

  static Future<void> _openBoxes() async {
    await Hive.openBox<Business>(HiveBoxes.business);
    await Hive.openBox<Product>(HiveBoxes.products);
    await Hive.openBox<ProductPriceHistory>(HiveBoxes.productPriceHistory);
    await Hive.openBox<SaleTransaction>(HiveBoxes.transactions);
  }
}
