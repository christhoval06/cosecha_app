import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_prefs.dart';
import 'premium_config.dart';

class PremiumAccess {
  PremiumAccess._();

  static final PremiumAccess instance = PremiumAccess._();

  final ValueNotifier<bool> _isPremium = ValueNotifier<bool>(
    !PremiumConfig.enablePremiumMode,
  );
  bool _loaded = false;

  ValueListenable<bool> get listenable => _isPremium;
  bool get isPremium => !PremiumConfig.enablePremiumMode || _isPremium.value;

  Future<void> ensureLoaded() async {
    if (!PremiumConfig.enablePremiumMode) {
      _isPremium.value = true;
      _loaded = true;
      return;
    }
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _isPremium.value = prefs.getBool(AppPrefs.premiumEnabled) ?? false;
    _loaded = true;
  }

  Future<void> setPremium(bool value) async {
    if (!PremiumConfig.enablePremiumMode) {
      _isPremium.value = true;
      _loaded = true;
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefs.premiumEnabled, value);
    _isPremium.value = value;
    _loaded = true;
  }
}
