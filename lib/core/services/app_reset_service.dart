import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_routes.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/business.dart';
import '../../data/models/product.dart';
import '../../data/models/product_price_history.dart';
import '../../data/models/sale_transaction.dart';
import 'business_session.dart';

class AppResetService {
  AppResetService._();

  static Future<void> resetAll() async {
    await Hive.box<Business>(HiveBoxes.business).clear();
    await Hive.box<Product>(HiveBoxes.products).clear();
    await Hive.box<SaleTransaction>(HiveBoxes.transactions).clear();
    await Hive.box<ProductPriceHistory>(HiveBoxes.productPriceHistory).clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    BusinessSession.instance.setCurrent(null);
  }

  static String initialRouteAfterReset() => AppRoutes.onboarding;
}
