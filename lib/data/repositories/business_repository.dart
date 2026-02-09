import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../hive/boxes.dart';
import '../models/business.dart';

class BusinessRepository {
  static const String currentKey = 'current_profile';

  Box<Business> get _box => Hive.box<Business>(HiveBoxes.business);

  Business? getCurrent() => _box.get(currentKey);

  Future<void> saveProfile(Business business) async {
    await _box.put(currentKey, business);
  }

  Future<void> clearProfile() async {
    await _box.delete(currentKey);
  }

  ValueListenable<Box<Business>> listenable() {
    return Hive.box<Business>(
      HiveBoxes.business,
    ).listenable(keys: const [currentKey]);
  }
}
